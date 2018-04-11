//
//  AboutUs.swift
//  NewsAppPro
//
//  Created by Vishal Parmar on 27/05/17.
//  Copyright © 2017 Vishal Parmar. All rights reserved.
//

import UIKit

class AboutUs: UIViewController,UIWebViewDelegate
{
    //====Declare Variables====//
    @IBOutlet var mywebview:UIWebView?
    var AboutUsArray : NSArray = NSMutableArray()
    @IBOutlet var myScrollview : UIScrollView?
    @IBOutlet var myView1 : UIView?
    @IBOutlet var myView2 : UIView?
    @IBOutlet var myView3 : UIView?
    @IBOutlet var imglogo : UIImageView?
    @IBOutlet var lblappname : UILabel?
    @IBOutlet var lblappversion : UILabel?
    @IBOutlet var lblappwebsite : UILabel?
    @IBOutlet var lblappemail : UILabel?
    @IBOutlet var lblappmobno : UILabel?
    @IBOutlet var lblappcompanyname : UILabel?
    @IBOutlet var lblappdesc : UILabel?

    // The banner view.
//    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        myScrollview?.layer.masksToBounds = false
        myScrollview?.layer.shadowColor = UIColor.lightGray.cgColor
        myScrollview?.layer.shadowOpacity = 0.2
        myScrollview?.layer.shadowOffset = CGSize(width: 1, height: 1)
        myScrollview?.layer.shadowRadius = 1
        myScrollview?.layer.shadowPath = UIBezierPath(rect: (myScrollview?.bounds)!).cgPath
        myScrollview?.layer.shouldRasterize = true
        myScrollview?.layer.rasterizationScale = UIScreen.main.scale
        
        myView1?.layer.shadowColor = UIColor.lightGray.cgColor
        myView1?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        myView1?.layer.shadowRadius = 2.0
        myView1?.layer.shadowOpacity = 1.0
        myView1?.layer.masksToBounds = false
        myView1?.layer.shadowPath = UIBezierPath(roundedRect: (myView1?.bounds)!, cornerRadius: (myView1?.layer.cornerRadius)!).cgPath

        myView2?.layer.shadowColor = UIColor.lightGray.cgColor
        myView2?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        myView2?.layer.shadowRadius = 2.0
        myView2?.layer.shadowOpacity = 1.0
        myView2?.layer.masksToBounds = false
        myView2?.layer.shadowPath = UIBezierPath(roundedRect: (myView2?.bounds)!, cornerRadius: (myView2?.layer.cornerRadius)!).cgPath
        
        myView3?.layer.shadowColor = UIColor.lightGray.cgColor
        myView3?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        myView3?.layer.shadowRadius = 2.0
        myView3?.layer.shadowOpacity = 1.0
        myView3?.layer.masksToBounds = false
        myView3?.layer.shadowPath = UIBezierPath(roundedRect: (myView3?.bounds)!, cornerRadius: (myView3?.layer.cornerRadius)!).cgPath

//        ACProgressHUD.shared.showHUD(withStatus: "Loading...")
//        let htmlFile = Bundle.main.path(forResource: "index", ofType: "html")
//        let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
//        mywebview?.loadHTMLString(html!, baseURL: nil)
        
        //========Check Internet Connection=======//
        if (Reachability.shared.isConnectedToNetwork()) {
            //===========Get About Json Data==========//
            ACProgressHUD.shared.showHUD(withStatus: "Loading...")
            getAboutJasonData()
        } else {
            NetworkErrorMsg()
        }
    }
    
    //================Get About Us Json Data===============//
    func getAboutJasonData()
    {
        let latesturlString: NSString = CommonUtils.getBaseUrl() + CommonUtils.AboutUsAPI() as NSString
        let urlEncodedString = latesturlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        print("About Us API : ",urlEncodedString ?? true)
        let url = URL(string: urlEncodedString!)
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
                        self.AboutUsArray = (JSONDictionary["NEWS_APP"] as? NSArray!)!
                    }
                    print("AboutUsArray Count : ",self.AboutUsArray.count)
                    
                    let applogo : String? = (self.AboutUsArray.value(forKey: "app_logo") as! NSArray).object(at: 0) as? String
                    let strimgname: NSString = NSString(format:"http://www.viaviweb.in/envato/cc/news_app_demo/images/%@",applogo!)
                    let encodedString = strimgname.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
                    let url = URL(string: encodedString!)
                    self.imglogo?.kf.setImage(with: url)
                    
                    DispatchQueue.main.async {
                        let appnamestr : String? = (self.AboutUsArray.value(forKey: "app_name") as! NSArray).object(at: 0) as? String
                        self.lblappname?.text = appnamestr
                        
                        let appversionstr : String? = (self.AboutUsArray.value(forKey: "app_version") as! NSArray).object(at: 0) as? String
                        self.lblappversion?.text = appversionstr
                        
                        let appwebsitestr : String? = (self.AboutUsArray.value(forKey: "app_website") as! NSArray).object(at: 0) as? String
                        self.lblappwebsite?.text = appwebsitestr
                        
                        let appemailstr : String? = (self.AboutUsArray.value(forKey: "app_email") as! NSArray).object(at: 0) as? String
                        self.lblappemail?.text = appemailstr
                        
                        let appmobnostr : String? = (self.AboutUsArray.value(forKey: "app_contact") as! NSArray).object(at: 0) as? String
                        self.lblappmobno?.text = appmobnostr
                        
                        let appdescstr : String? = (self.AboutUsArray.value(forKey: "app_description") as! NSArray).object(at: 0) as? String
                        self.mywebview?.loadHTMLString(appdescstr!, baseURL: nil)

                        self.myScrollview?.contentSize = CGSize(width: (self.myScrollview?.frame.size.width)!, height: 780)

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

    //====UIWebview Delegate Methods====//
    func webViewDidStartLoad(_ webView : UIWebView) {
        
    }
    func webViewDidFinishLoad(_ webView : UIWebView) {
        ACProgressHUD.shared.hideHUD()
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
