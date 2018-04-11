//
//  Categories.swift
//  NewsAppPro
//
//  Created by Vishal Parmar on 27/05/17.
//  Copyright © 2017 Vishal Parmar. All rights reserved.
//

import UIKit

class Categories: KHTabPagerViewController,KHTabPagerDelegate,KHTabPagerDataSource
{
    var CategoryArray : NSArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //========Check Internet Connection=======//
        if (Reachability.shared.isConnectedToNetwork()) {
            //===========Get Json Data==========//
            ACProgressHUD.shared.showHUD(withStatus: "Loading...")
            getJasonData()
        } else {
            NetworkErrorMsg()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //================Get Category Json Data===============//
    func getJasonData()
    {
        let latesturlString: NSString = CommonUtils.getBaseUrl() + CommonUtils.AllCategoryNewsAPI() as NSString
        let urlEncodedString = latesturlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)
        print("Category API : ",urlEncodedString ?? true)
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
                        self.CategoryArray = (JSONDictionary["NEWS_APP"] as? NSArray!)!
                    }
                    print("CategoryArray Count : ",self.CategoryArray.count)
                    
                    let userDefaults = UserDefaults.standard
                    let catID: NSString = NSString(format:"%@",((self.CategoryArray.value(forKey: "cid") as! NSArray).object(at: 0) as? String)!)
                    userDefaults.set( catID, forKey: "CatArray")
                    
                    DispatchQueue.main.async {
                        //====KHTabPagerViewController Reload Data====//
                        self.dataSource = self
                        self.delegate = self
                        self.reloadData()
                    }

                } catch _ as NSError {
                    self.ServerNetworkErrorMsg()
                }
            }
            }.resume()
    }

    
    //============KHTabPagerViewController Delegate Methods============//
    func numberOfViewControllers() -> Int {
        return self.CategoryArray.count
    }
    func viewController(for index: Int) -> UIViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let pageVC = storyBoard.instantiateViewController(withIdentifier: "PageSliderView") as! PageSliderView
        return pageVC
    }
    func titleForTab(at index: Int) -> String {
        let catName: NSString = NSString(format:"%@",((self.CategoryArray.value(forKey: "category_name") as! NSArray).object(at: index) as? String)!)
        return catName as String
    }
    func tabHeight() -> CGFloat {
        return 50.0
    }
    func tabBarTopViewHeight() -> CGFloat {
        return 74.0
    }
    func tabColor() -> UIColor {
        return UIColor.init(hexString: "#C93C35")
    }
    func tabBackgroundColor() -> UIColor {
        return UIColor.black
    }
    func titleFont() -> UIFont {
        return UIFont(name: "HelveticaNeue", size: 18.0)!
    }
    func titleColor() -> UIColor {
        return UIColor.white
    }
    func tabPager(_ tabPager: KHTabPagerViewController, willTransitionToTabAt index: Int) {
        print("PageTabIndex : \(Int(index))")
        let userDefaults = Foundation.UserDefaults.standard
        let cat_ID = (CategoryArray.value(forKey: "cid") as! NSArray).object(at: index) as? String
        userDefaults.set(cat_ID, forKey:"catid")
        let cat_NAME = (CategoryArray.value(forKey: "category_name") as! NSArray).object(at: index) as? String
        userDefaults.set(cat_NAME, forKey:"catname")
        
        //NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    func tabPager(_ tabPager: KHTabPagerViewController, didTransitionToTabAt index: Int) {
        print("PageSwipeIndex : \(Int(index))")
        let userDefaults = Foundation.UserDefaults.standard
        let cat_ID = (CategoryArray.value(forKey: "cid") as! NSArray).object(at: index) as? String
        userDefaults.set(cat_ID, forKey:"catid")
        let cat_NAME = (CategoryArray.value(forKey: "category_name") as! NSArray).object(at: index) as? String
        userDefaults.set(cat_NAME, forKey:"catname")
        
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    //==============Search Button Click===============//
    @IBAction func OnSearchClick(sender:UIButton) {
        let alertController = UIAlertController(title: "Search News ?", message: "Please input news keyword", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Search", style: .default) { (_) in
            let field = alertController.textFields?[0].text
            if (field != "") {
                print(field ?? 0)
                let userDefaults = Foundation.UserDefaults.standard
                userDefaults.set(field, forKey:"search")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "searchview") as! SearchController
                self.navigationController?.pushViewController(nextViewController,animated:true)
            } else {
                SWMessage.sharedInstance.showNotificationInViewController(self,
                                                                          title: "",
                                                                          subtitle:"Please enter text for news search",
                                                                          image: nil,
                                                                          type: .error,
                                                                          duration: .automatic,
                                                                          callback: nil,
                                                                          buttonTitle: nil,
                                                                          buttonCallback: nil,
                                                                          atPosition: .bottom,
                                                                          canBeDismissedByUser: false)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Keyword"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
