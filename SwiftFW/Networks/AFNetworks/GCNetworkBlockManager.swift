//
//  GCNetworkBlockManager.swift
//  GoodCam
//
//  Created by liyishu on 2021/11/18.
//

import UIKit
import AFNetworking

fileprivate let RequestErrorDomain = "com.network.request"

/// 网络请求（闭包方式）
class GCNetworkBlockManager: NSObject {

    static let shared: GCNetworkBlockManager = {
        let share = GCNetworkBlockManager()
        return share
    }()

    /// 请求
    /// - Parameters:
    ///   - method: 请求方法类型
    ///   - apiUrl: 请求地址
    ///   - params: 请求参数
    ///   - needSerializer: 是否序列化（后台需要传JSON 格式参数时打开）
    ///   - success: 成功
    ///   - failure: 失败
    func request(Method method: GCNetworkRequestType,
                 APIUrl apiUrl: String?,
                 Parameters params: [String: Any]?,
                 NeedSerializer needSerializer: Bool = false,
                 SuccessBlock success: @escaping GCRequestManagerSuccess,
                 FailureBlock failure: @escaping GCRequestManagerFailure) {
        let requestConfig: GCNetworkRequestConfig = GCNetworkRequestConfig.init(with: method.rawValue, apiUrl, params, nil)
        requestConfig.needSerializer = needSerializer
        self.request(RequestConfig: requestConfig, SuccessBlock: success, FailureBlock: failure)
    }

    /// 请求
    /// - Parameters:
    ///   - requsetConfig: 配置
    ///   - success: 成功
    ///   - failure: 失败
    func request(RequestConfig requsetConfig: GCNetworkRequestConfig,
                 SuccessBlock success: @escaping GCRequestManagerSuccess,
                 FailureBlock failure: @escaping GCRequestManagerFailure) {
        if requsetConfig.shouldAllIgnoreCache {

            // 忽略缓存，直接网络请求
            self.requesNetwork(RequestConfig: requsetConfig, SuccessBlock: success, FailureBlock: failure)
        } else {

            // 从缓存中找数据
            GCNetworkCacheManager.shared.findCache(NetworkRequestConfig: requsetConfig, SuccessBlock: { (successResponse) in
                success(successResponse)
            }) { (failResponse) in

                // 缓存查找失败，进行网络请求
                self.requesNetwork(RequestConfig: requsetConfig, SuccessBlock: success, FailureBlock: failure)
            }
        }
    }

    /// 请求网络
    /// - Parameters:
    ///   - requsetConfig: 配置
    ///   - success: 成功
    ///   - failure: 失败
    func requesNetwork(RequestConfig requsetConfig: GCNetworkRequestConfig,
                       SuccessBlock success: @escaping GCRequestManagerSuccess,
                       FailureBlock failure: @escaping GCRequestManagerFailure) {
        if GCNetworkConfigution.shared.isReachable {
            GCAPIProxy.shared.callNetwork(with: requsetConfig, { (successResponse) in
                success(successResponse)
            }) { (failResponse) in
                failure(failResponse)
            }
        } else {

        // 无网络,直接给出错误
        let userInfo = [NSLocalizedDescriptionKey:"----Request failed: not network----"]
        let error = NSError.init(domain: RequestErrorDomain, code: GCNetworkErrorType.typeNoNetwork.rawValue, userInfo: userInfo)
        let reponse:GCURLResponse = GCURLResponse.init(with: requsetConfig)
        reponse.errorType = GCNetworkErrorType.typeNoNetwork
        reponse.error = error
        failure(reponse)
            print("--------- error alert -------")
            print("暂无网络，请检查网络设置")
            print("--------- error alert -------")
        }
     }
}
