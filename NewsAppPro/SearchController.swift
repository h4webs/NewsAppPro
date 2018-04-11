//
//  SearchController.swift
//  NewsAppPro
//
//  Created by Vishal Parmar on 10/06/17.
//  Copyright © 2017 Vishal Parmar. All rights reserved.
//

import UIKit

class SearchController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    @IBOutlet var myCollectionview:UICollectionView?
    @IBOutlet var lblnofound : UILabel?
    var SearchArray : NSArray = NSMutableArray()
    
    // The banner view.
//    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //========Define UICollectionview Layout========//
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        self.myCollectionview!.collectionViewLayout = layout
        
        //=========UIcollectionviewCell Nib Register========//
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            let nibName = UINib(nibName: "LatestCustoCell_iPad", bundle:nil)
            self.myCollectionview?.register(nibName, forCellWithReuseIdentifier: "cell")
        } else {
            let nibName = UINib(nibName: "LatestCustoCell", bundle:nil)
            self.myCollectionview?.register(nibName, forCellWithReuseIdentifier: "cell")
        }
        
        //========Check Internet Connection=======//
        if (Reachability.shared.isConnectedToNetwork()) {
            //===========Get Search Json Data==========//
            ACProgressHUD.shared.showHUD(withStatus: "Loading...")
            getSearchJasonData()
        } else {
            NetworkErrorMsg()
        }
    }

    //================Get Search News Json Data===============//
    func getSearchJasonData()
    {
        let userDefaults = Foundation.UserDefaults.standard
        let searchText  = userDefaults.string(forKey: "search")
        
        let searchStr = String(format: "%@%@%@",CommonUtils.getBaseUrl(), CommonUtils.SearchNewsAPI(), searchText!)
        print("Search News API : ",searchStr)
        let url = URL(string: searchStr)
        URLSession.shared.dataTask(with:url!)
        {
            (data, response, error) in
            if (error != nil) {
                print("Url Error")
            } else {
                do {
                    let response = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    print("Responce Data : ",response)
                    if let JSONDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        self.SearchArray = (JSONDictionary["NEWS_APP"] as? NSArray!)!
                    }
                    print("SearchArray Count : ",self.SearchArray.count)
                    
                    if (self.SearchArray.count == 0) {
                        self.lblnofound?.isHidden = false
                    } else {
                        self.lblnofound?.isHidden = true
                    }
                    
                    DispatchQueue.main.async {
                        self.myCollectionview?.reloadData()
                        ACProgressHUD.shared.hideHUD()
                    }
                    
                    //=========Display Google Admob Banner=========//
//                    DispatchQueue.main.async {
//                        self.bannerView.adUnitID = CommonUtils.getAdmobID()
//                        self.bannerView.frame = CGRect(x:0, y:self.view.frame.size.height - self.bannerView.frame.size.height, width:self.bannerView.frame.size.width,                                                  height:self.bannerView.frame.size.height)
//                        self.bannerView.rootViewController = self
//                        self.view .addSubview(self.bannerView)
//                        self.bannerView.load(GADRequest())
//                    }
                } catch _ as NSError {
                    self.ServerNetworkErrorMsg()
                }
            }
        }.resume()
    }
    
    
    
    //============UICollectionview Delegates Methods============//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.SearchArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellIdentifire = "cell"
        let cell : LatestCustoCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifire, for: indexPath) as! LatestCustoCell
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        let videoID: NSString = NSString(format:"%@",((SearchArray.value(forKey: "video_id") as! NSArray).object(at: indexPath.row) as? String)!)
        if (videoID .isEqual(to: "")) {
            let strimgname: NSString = NSString(format:"%@",((SearchArray.value(forKey: "news_image_b") as! NSArray).object(at: indexPath.row) as? String)!)
            let encodedString = strimgname.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
            let url = URL(string: encodedString!)
            let placeimg = UIImage(named : "placeholder_small")
            cell.imgView?.kf.setImage(with: url, placeholder: placeimg, options: nil, progressBlock: nil, completionHandler: nil)
            cell.btnplay?.isHidden = true
        } else {
            let strimgname: NSString = NSString(format:"https://img.youtube.com/vi/%@/0.jpg",videoID)
            let encodedString = strimgname.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
            let url = URL(string: encodedString!)
            let placeimg = UIImage(named : "placeholder_small")
            cell.imgView?.kf.setImage(with: url, placeholder: placeimg, options: nil, progressBlock: nil, completionHandler: nil)
            cell.btnplay?.isHidden = false
        }
        
        cell.lbltitle?.text = (SearchArray.value(forKey: "news_title") as! NSArray).object(at: indexPath.row) as? String
        cell.lbldate?.text = (SearchArray.value(forKey: "news_date") as! NSArray).object(at: indexPath.row) as? String
        cell.lblviews?.text = (SearchArray.value(forKey: "news_views") as! NSArray).object(at: indexPath.row) as? String
        
        //========Set Image for a Favourite Button=======//
        let studentInfo: NewsInfo = NewsInfo()
        studentInfo.nid = ((self.SearchArray.value(forKey: "id") as! NSArray).object(at: indexPath.row) as? String)!
        let isNewsExist = Singleton.getInstance().checkStudentData(studentInfo)
        if (isNewsExist.count == 0) {
            cell.btnfavourite?.setImage(UIImage(named: "ic_fav")!, for: UIControlState.normal)
        } else {
            cell.btnfavourite?.setImage(UIImage(named: "ic_favhov")!, for: UIControlState.normal)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if (indexPath.row % 4 == 0) {
                return CGSize(width: self.view.frame.size.width-20, height: 330)
            } else {
                let bounds = UIScreen.main.bounds
                let height = bounds.size.height
                switch height
                {
                case 1024.0:
                    return CGSize(width: 242, height: 330);
                case 480.0:
                    return CGSize(width: 145, height: 230);
                case 568.0:
                    return CGSize(width: 145, height: 230);
                case 667.0:
                    return CGSize(width: 172, height: 230);
                case 736.0:
                    return CGSize(width: 192, height: 230);
                default:
                    print("not an iPhone")
                    return CGSize(width: 145, height: 230);
                }
            }
        } else {
            if (indexPath.row % 3 == 0) {
                return CGSize(width: self.view.frame.size.width-20, height: 230)
            } else {
                let bounds = UIScreen.main.bounds
                let height = bounds.size.height
                switch height
                {
                case 1024.0:
                    return CGSize(width: 225, height: 330);
                case 480.0:
                    return CGSize(width: 145, height: 230);
                case 568.0:
                    return CGSize(width: 145, height: 230);
                case 667.0:
                    return CGSize(width: 172, height: 230);
                case 736.0:
                    return CGSize(width: 192, height: 230);
                default:
                    print("not an iPhone")
                    return CGSize(width: 145, height: 230);
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userDefaults = Foundation.UserDefaults.standard
        let news_ID = (SearchArray.value(forKey: "id") as! NSArray).object(at: indexPath.row) as? String
        userDefaults.set(news_ID, forKey:"newsid")
        let news_NAME = (SearchArray.value(forKey: "news_title") as! NSArray).object(at: indexPath.row) as? String
        userDefaults.set(news_NAME, forKey:"newsname")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "detailview") as! DetailView
        self.navigationController?.pushViewController(nextViewController,animated:true)
    }

    //====UIButton Click====//
    @IBAction func OnBackClick(sender:UIButton) {
        _ = navigationController?.popViewController(animated:true)
    }
    
    //================Internet Error Message===============//
    func NetworkErrorMsg()
    {
        SWMessage.sharedInstance.showNotificationInViewController(self,
                                                                  title: "Error!",
                                                                  subtitle:CommonUtils.ShowInternetErrorMessage(),
                                                                  image: nil,
                                                                  type: .error,
                                                                  duration: .automatic,
                                                                  callback: nil,
                                                                  buttonTitle: nil,
                                                                  buttonCallback: nil,
                                                                  atPosition: .bottom,
                                                                  canBeDismissedByUser: false)
    }
    func ServerNetworkErrorMsg()
    {
        SWMessage.sharedInstance.showNotificationInViewController(self,
                                                                  title: "Error!",
                                                                  subtitle:CommonUtils.ShowInternalServerErrorMessage(),
                                                                  image: nil,
                                                                  type: .error,
                                                                  duration: .automatic,
                                                                  callback: nil,
                                                                  buttonTitle: nil,
                                                                  buttonCallback: nil,
                                                                  atPosition: .bottom,
                                                                  canBeDismissedByUser: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
