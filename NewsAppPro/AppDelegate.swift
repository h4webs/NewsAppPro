//
//  AppDelegate.swift
//  NewsAppPro
//
//  Created by Vishal Parmar on 26/05/17.
//  Copyright © 2017 Vishal Parmar. All rights reserved.
//

import UIKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Local Database Path
        CommonUtils.copyFile("NewsAppPro.sqlite")
        
        //One Signal for Push Notification
        DispatchQueue.main.async {
            let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
            OneSignal.initWithLaunchOptions(launchOptions,
                                            appId: CommonUtils.getOneSignalAppID(),
                                            handleNotificationAction: nil,
                                            settings: onesignalInitSettings)
            
            OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                print("User accepted notifications: \(accepted)")
            })
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set( "NO", forKey: "FIRSTORNOT")
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        if self.window?.rootViewController?.presentedViewController is XCDYouTubeVideoPlayerViewController
        {
            let secondController = self.window!.rootViewController!.presentedViewController as! XCDYouTubeVideoPlayerViewController
            if secondController.isBeingDismissed {
                return UIInterfaceOrientationMask.portrait;
            } else {
                return [.portrait, .landscapeLeft, .landscapeRight]
            }
        } else {
            return UIInterfaceOrientationMask.portrait;
        }
    }
}

