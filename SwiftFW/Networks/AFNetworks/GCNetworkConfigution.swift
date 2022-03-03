//
//  GCNetworkConfigution.swift
//  GoodCam
//
//  Created by liyishu on 2021/11/18.
//

import UIKit
import AFNetworking

enum  GCNetworkRequestType: String {
    case get = "GET"
    case post = "POST"
}

class GCNetworkConfigution: NSObject {
    
    var baseURLString: String {
        get {
            return ""
        }
    }
    
    // 最大缓存数
    var countLimint: Int = 300
    // 请求超时时间
    var timeoutInterval: Int = 20
    // 缓存版本
    var memoryCacheVersion: String?
    // Cache expiration time
    var cacheTimeInSeconds: TimeInterval = 300
    // 请求头
    var mutableHTTPRequestHeaders: [String : String]?
    // 调试日志（是/否）
    var dubugLogeEnable: Bool = true
    // SQL日志（是/否）
    var SQLLogEnable: Bool = false
    // 日志 password
    var ne_sqlitePassword: String?
    // 请求最大数
    var ne_saveRequestMaxCount: Int?
    
    var isReachable: Bool {
        get {
            if AFNetworkReachabilityManager.shared().networkReachabilityStatus == .notReachable {
                return false
            } else {
                return true
            }
        }
    }
    
    static let shared: GCNetworkConfigution = {
        let help = GCNetworkConfigution()
        return help
    }()
    
    override init() {
        super.init()
    }
}
