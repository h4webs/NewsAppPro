//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let sharedInstance = Singleton()

class Singleton: NSObject {
    
    var database: FMDatabase? = nil

    class func getInstance() -> Singleton
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: CommonUtils.getPath("NewsAppPro.sqlite"))
        }
        return sharedInstance
    }
    
    func addStudentData(_ studentInfo: NewsInfo) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO Favourite (nid, cat_id, news_type, news_title, video_url, video_id, news_image_b, news_image_s, news_description, news_date, news_views, cid, category_name, category_text) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsIn: [studentInfo.nid, studentInfo.cat_id, studentInfo.news_type, studentInfo.news_title, studentInfo.video_url, studentInfo.video_id, studentInfo.news_image_b, studentInfo.news_image_s, studentInfo.news_description, studentInfo.news_date, studentInfo.news_views, studentInfo.cid, studentInfo.category_name, studentInfo.category_text])
        sharedInstance.database!.close()
        return isInserted
    }
    
    func checkStudentData(_ studentInfo: NewsInfo) -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Favourite WHERE nid=?", withArgumentsIn: [studentInfo.nid])
        let StudentInfoArray : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let newsInfo : NewsInfo = NewsInfo()
                newsInfo.nid = resultSet.string(forColumn: "nid")
                StudentInfoArray.add(newsInfo)
            }
        }
        sharedInstance.database!.close()
        return StudentInfoArray
    }

    func deleteStudentData(_ studentInfo: NewsInfo) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM Favourite WHERE nid=?", withArgumentsIn: [studentInfo.nid])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func getAllNewsData() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Favourite", withArgumentsIn: nil)
        let StudentInfoArray : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let newsInfo : NewsInfo = NewsInfo()
                newsInfo.nid = resultSet.string(forColumn: "nid")
                newsInfo.cat_id = resultSet.string(forColumn: "cat_id")
                newsInfo.news_type = resultSet.string(forColumn: "news_type")
                newsInfo.news_title = resultSet.string(forColumn: "news_title")
                newsInfo.video_url = resultSet.string(forColumn: "video_url")
                newsInfo.video_id = resultSet.string(forColumn: "video_id")
                newsInfo.news_image_b = resultSet.string(forColumn: "news_image_b")
                newsInfo.news_image_s = resultSet.string(forColumn: "news_image_s")
                newsInfo.news_description = resultSet.string(forColumn: "news_description")
                newsInfo.news_date = resultSet.string(forColumn: "news_date")
                newsInfo.news_views = resultSet.string(forColumn: "news_views")
                newsInfo.cid = resultSet.string(forColumn: "cid")
                newsInfo.category_name = resultSet.string(forColumn: "category_name")
                newsInfo.category_text = resultSet.string(forColumn: "category_text")
                StudentInfoArray.add(newsInfo)
            }
        }
        sharedInstance.database!.close()
        return StudentInfoArray
    }

    //    func updateStudentData(_ studentInfo: NewsInfo) -> Bool {
    //        sharedInstance.database!.open()
    //        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE student_info SET Name=?, Marks=? WHERE RollNo=?", withArgumentsIn: [studentInfo.Name, studentInfo.Marks, studentInfo.RollNo])
    //        sharedInstance.database!.close()
    //        return isUpdated
    //    }

}
