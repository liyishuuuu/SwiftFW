//
//  GCNetworkRequestConfig.swift
//  GoodCam
//
//  Created by liyishu on 2021/11/18.
//

import UIKit

class GCNetworkRequestConfig: NSObject {

    // 请求方式
    var method: String?
    // 请求地址
    var urlString: String?
    // 请求参数
    var params: [String: Any]?
    // 请求控制器名字
    var classVCName: String?
    // 是否忽略缓存
    var shouldAllIgnoreCache: Bool = true
    // 是否需要序列化
    var needSerializer: Bool = false

    init(with method: String?,
         _ APIUrl: String?,
         _ params: [String: Any]?,
         _ classVCName: String?) {
        self.method = method
        let baseURLString: String = GCNetworkConfigution.shared.baseURLString
        if APIUrl == "" {
            self.urlString = baseURLString
        } else {
            self.urlString = APIUrl
        }
        self.params = params
        self.classVCName = classVCName
    }
}
