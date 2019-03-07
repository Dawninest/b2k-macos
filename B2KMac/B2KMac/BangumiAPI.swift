//
//  BangumiAPI.swift
//  B2KMac
//
//  Created by 蒋一博 on 2019/3/6.
//  Copyright © 2019 dawninest. All rights reserved.
//

import Cocoa

struct dailyData: CustomStringConvertible {
    var date: String
    var date_ts: Float
    var day_of_week: String
    var is_today: Bool
    var seasons: Array<bangumiData>

    var description: String
}

struct bangumiData: CustomStringConvertible {
    var description: String
    
    var cover: String
    var season_id: String
    var title: String
    var pub_index: String
    var pub_time: String
    
}


class BangumiAPI {
    let urlStr = "https://bangumi.bilibili.com/web_api/timeline_global"
    //let urlStr = "https://www.baidu.com"
    func fetchData (success: @escaping ([Dictionary<String,Any>]) -> Void) {
        let session = URLSession(configuration: .default)
        let url = NSURL(string: urlStr)
        let request = URLRequest(url: url! as URL)
       
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                let bangumiData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                let showData = self.getReturnData(bangumiData)
                success(showData)
            } catch {
                print("无法连接到服务器")
                return
            }
        }
        task.resume()
    }
    
    func getReturnData (_ data: NSDictionary) -> [Dictionary<String,Any>]{
        
        // 提供的数据是 前六天 + 当天 + 后六天 共 13 天数据
        // 这里咱只需要 前三天 + 当天 + 后三天 共 7 天数据
        let result: Array<Any> = data.object(forKey: "result") as! Array<Any>
        var returnDataArr = Array<Dictionary<String, Any>>()
        let weekArr = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期天", "星期天"]
        for (index, value) in result.enumerated() {
            var dailyData: Dictionary<String,Any> = value as! Dictionary<String, Any>
            if (index > 2 && index < 10) {
                let isToday = dailyData["is_today"] as! Int
                if isToday == 1 {
                    dailyData["dateStr"] = "今天"
                } else {
                    let date = dailyData["date"] as! String
                    let newDate = date.replacingOccurrences(of: "-", with: ".", options: .literal, range: nil)
                    dailyData["dateStr"] = newDate
                }
                let weekInt = dailyData["day_of_week"] as! Int
                dailyData["weekStr"] = weekArr[weekInt - 1]
                returnDataArr.append(dailyData)
            }
        }
        return returnDataArr;
    }

    
    func getCNStr (uncode: String) -> String {
        var returnStr:String = ""
        let tempStr1 = uncode.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        print(returnStr);
        return "11"
    }
}
