//
//  GCNetworkCodeCheck.swift
//  SwiftFW
//
//  Created by liyishu on 2021/11/19.
//

import UIKit

/**
 * 检查 系统和后台 返回的错误码
 *
 * 异常处理
 */
class GCNetworkCodeCheck: NSObject {

    class func checkCode(Code code: NSInteger) -> Bool {
        // 系统返回错误码
        if code >= -4 && code < 0 {
            if code == 1009 {
                print("无网络")
            }
            return false
        }
        // 后台返回错误码
        if code == 401 {
            return false
        }
        return true
    }
}
