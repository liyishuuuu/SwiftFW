//
//  GCNetworkHelper.swift
//  GoodCam
//
//  Created by liyishu on 2021/11/18.
//

import UIKit

class GCNetworkHelper: NSObject {

    // 获取app 版本
    class func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }

    // 缓存数据超时
    class func cacheContentOverTime(CacheTime cacheTime: String) -> Bool {
        let nowDate = Date()
        let cacheDate: Date = self.getDate(TimeIntervalString: cacheTime)
        let differenceTime: TimeInterval = nowDate.timeIntervalSince(cacheDate)
        let configCacheTime = GCNetworkConfigution.shared.cacheTimeInSeconds
        if Int(differenceTime) > Int(configCacheTime) {
            return true
        }
        return false
    }

    // 时间转换成时间戳
    class func timeIntervalString(Date date: Date) -> String {
        let timeInterval = date.timeIntervalSince1970
        return String(timeInterval)
    }

    // 获取日期
    class func getDate(TimeIntervalString timeIntervalS: String) -> Date {
        
        let interval = TimeInterval(Int(timeIntervalS)!)
        let date = Date(timeIntervalSince1970: interval)
        return date
    }

    // 获取错误
    class func getError(Domain domain: String, Info info: String, Code code: Int) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: info]
        let error = NSError.init(domain: domain, code: code, userInfo: userInfo)
        return error
    }
}
