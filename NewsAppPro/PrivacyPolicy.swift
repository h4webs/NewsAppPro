//
//  PrivacyPolicy.swift
//  NewsAppPro
//
//  Created by Vishal Parmar on 27/05/17.
//  Copyright © 2017 Vishal Parmar. All rights reserved.
//

import UIKit

class PrivacyPolicy: UIViewController,UIWebViewDelegate
{
    @IBOutlet weak var myWebview:UIWebView?
    var PrivacyArray : NSArray = NSMutableArray()
    
    // The banner view.
//    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //========Check Internet Connection=======//
        if (Reachability.shared.isConnectedToNetwork()) {
            //===========Get About Json Data==========//
            ACProgressHUD.shared.showHUD(withStatus: "Loading...")
            getPrivacyJasonData()
        } else {
            NetworkErrorMsg()
        }
    }
    
    //================Get Privacy Jason Data===============//
    func getPrivacyJasonData()
    {
        let latesturlString: NSString = CommonUtils.getBaseUrl() + CommonUtils.AboutUsAPI() as NSString
        let urlEncodedString = latesturlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        print("Privacy Policy API : ",urlEncodedString ?? true)
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
                        self.PrivacyArray = (JSONDictionary["NEWS_APP"] as? NSArray!)!
                    }
                    print("PrivacyArray Count : ",self.PrivacyArray.count)
                    
                    DispatchQueue.main.async {
                        let appprivacy : String? = (self.PrivacyArray.value(forKey: "app_privacy_policy") as! NSArray).object(at: 0) as? String
                        self.myWebview?.loadHTMLString(appprivacy!, baseURL: nil)
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

    //====UIButton Click====//
    @IBAction func OnBackClick(sender:UIButton) {
        _ = navigationController?.popViewController(animated:true)
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

