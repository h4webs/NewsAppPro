//
//  ViewController.swift
//  SliderMenu
//
//  Created by Uber - Abdul on 21/02/17.
//  Copyright © 2017 example.com. All rights reserved.
//

import UIKit

class SlideMenu: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    //====Declare Variables====//
    @IBOutlet weak var lblname:UILabel!
    @IBOutlet weak var mytableview:UITableView!
    @IBOutlet weak var logoImageview:UIImageView!
    @IBOutlet weak var lblappname:UILabel!
    var SectionOneArray = NSArray()
    var SectionTwoArray = NSArray()
    var SectionOneImageArray = NSArray()
    var SectionTwoImageArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //======Initialize Slide Menu======//
        self.navigationController?.isNavigationBarHidden = true
        SideMenuManager.menuFadeStatusBar = false
        
        //====Initialize Array====//
        SectionOneArray = NSArray(objects: "Latest News","Categories","Favourites")
        SectionOneImageArray = NSArray(objects: "ic_latest_red","ic_category","ic_favourite")
        
        SectionTwoArray = NSArray(objects: "Rate App","More App","Share App","About Us","Privacy Policy")
        SectionTwoImageArray = NSArray(objects: "ic_rate96","ic_more96","ic_share96","ic_about96","ic_privacy96")
        
        //====Set Company Name and logo===//
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            self.logoImageview.frame = CGRect(x: 250, y: 20, width: 100, height: 100)
            self.lblappname.frame = CGRect(x: 215, y: 128, width: 170, height: 27)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //====UITableview Methods====//
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return SectionOneArray.count
        } else {
            return SectionTwoArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifire = "cell"
        var cell:SlideMenuCustomCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifire) as? SlideMenuCustomCell
        if (cell == nil) {
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                let nib:Array = Bundle.main.loadNibNamed("SlideMenuCustomCell_iPad", owner: self, options: nil)!
                cell = nib[0] as? SlideMenuCustomCell
            } else {
                let nib:Array = Bundle.main.loadNibNamed("SlideMenuCustomCell", owner: self, options: nil)!
                cell = nib[0] as? SlideMenuCustomCell
            }
        }
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell?.lblname?.textColor = UIColor.red
            }
            let strimgname: NSString = NSString(format:"%@",SectionOneImageArray[indexPath.row] as! CVarArg)
            cell?.imgview.image = UIImage(named:strimgname as String)
            cell?.lblname?.text = SectionOneArray[indexPath.row] as? String
        } else {
            let strimgname: NSString = NSString(format:"%@",SectionTwoImageArray[indexPath.row] as! CVarArg)
            cell?.imgview.image = UIImage(named:strimgname as String)
            cell?.lblname?.text = SectionTwoArray[indexPath.row] as? String
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            return 50
        } else {
            return 40
        }
    }
    func tableView( _ tableView : UITableView, titleForHeaderInSection section: Int)->String? {
        if (section == 0) {
            return ""
        } else {
            return "Communicate"
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0
        } else {
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                return 50
            } else {
                return 40
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section==0) {
            switch indexPath.row {
            case 0:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
                self.navigationController?.pushViewController(nextViewController,animated:true)
            case 1:
                let userDefaults = Foundation.UserDefaults.standard
                userDefaults.set(true, forKey: "CALL")

                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "categories") as! Categories
                self.navigationController?.pushViewController(nextViewController,animated:true)
            case 2:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "favourites") as! Favourites
                self.navigationController?.pushViewController(nextViewController,animated:true)
            default :
                break
            }
        } else if(indexPath.section==1) {
            switch indexPath.row {
            case 0:
                let url = NSURL(string:CommonUtils.getRateAppURL())
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url! as URL)
                }
            case 1:
                let url = NSURL(string:CommonUtils.getMoreAppURL())
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url! as URL)
                }
            case 2:
                let newsVideoLink: NSString = NSString(format:CommonUtils.getShareAppURL() as NSString)
                let videoLink = URL(string: newsVideoLink as String)
                
                let shareItems:Array = ["NewsAppPro",videoLink ?? 0] as [Any]
                let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
                activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
                self.present(activityViewController, animated: true, completion: nil)
            case 3:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "aboutUs") as! AboutUs
                self.navigationController?.pushViewController(nextViewController,animated:true)
            case 4:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "privacypolicy") as! PrivacyPolicy
                self.navigationController?.pushViewController(nextViewController,animated:true)
            default :
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

