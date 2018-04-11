//
//  CommonUtils.swift
//  NewsAppPro
//
//  Created by Vishal Parmar on 29/05/17.
//  Copyright © 2017 Vishal Parmar. All rights reserved.
//

import UIKit

class CommonUtils: NSObject
{
    class func getBaseUrl() -> String {
        return "http://localhost:8888/youcan/"
        //return "http://www.viaviweb.in/envato/cc/news_app_demo/"
    }
    
    class func LatestNewsAPI() -> String {
        return "api.php?latest"
    }
    
    class func AllCategoryNewsAPI() -> String {
        return "api.php?cat_list"
    }

    class func NewsListByCatIDAPI() -> String {
        return "api.php?cat_id="
    }

    class func SingleNewsDetailAPI() -> String {
        return "api.php?news_id="
    }

    class func SearchNewsAPI() -> String {
        return "api.php?search="
    }

    class func AboutUsAPI() -> String {
        return "api.php"
    }

    class func getOneSignalAppID() -> String {
        return "a095860d-c90e-4466-aee7-a81e6d135c83"
    }
    
    class func getAdmobID() -> String {
        return "ca-app-pub-4794178845041176/9314202842"
    }
    
    class func getInterstitialID() -> String {
        return "ca-app-pub-4794178845041176/4884003243"
    }

    class func getRateAppURL() -> String {
        return "https://itunes.apple.com/us/app/independence-day-wallpapers/id1142171487?ls=1&mt=8"
    }

    class func getMoreAppURL() -> String {
        return "https://itunes.apple.com/us/app/ios-hdwallpaper/id1141291248?ls=1&mt=8"
    }

    class func getShareAppURL() -> String {
        return "https://itunes.apple.com/us/app/ios-hdwallpaper/id1141291248?ls=1&mt=8"
    }

    class func ShowInternetErrorMessage() -> String {
        return "Internet Connection Not available."
    }
    
    class func ShowInternalServerErrorMessage() -> String {
        return "Internal server error."
    }

    
    class func getPath(_ fileName: String) -> String {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        return fileURL.path
    }
    
    class func copyFile(_ fileName: NSString) {
        let dbPath: String = getPath(fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            let alert: UIAlertView = UIAlertView()
            if (error != nil) {
                alert.title = "Error Occured"
                alert.message = error?.localizedDescription
            } else {
                alert.title = "Successfully Copy"
                alert.message = "Your database copy successfully"
            }
            alert.delegate = nil
            alert.addButton(withTitle: "Ok")
            //alert.show()
        }
    }

}
