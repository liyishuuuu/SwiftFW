//
//  GCNetworkDelegateManager.swift
//  SwiftFW
//
//  Created by liyishu on 2021/11/18.
//

import UIKit

fileprivate let RequestErrorDomain = "com.network.request"

/// 成功/失败的回调
protocol GCNetworkManagerCallBackDelegate: NSObjectProtocol {
    
    func requesApiSuccess(Manager manager: GCNetworkDelegateManager)
    
    func requesApiFailure(Manager manager: GCNetworkDelegateManager)
}

/// 参数源
@objc protocol GCAPIManagerParamSource: NSObjectProtocol {
    @objc func configeApiParams(Manager manager: GCNetworkDelegateManager) -> [String: Any]?
    @objc optional
    func configeApiParamsForMoreData(Manager manager: GCNetworkDelegateManager) -> [String: Any]?
}

/// 用于数据改造，把请求的结果数据改造成自己想的
@objc protocol XHAPIDataReformerDelegate: NSObjectProtocol {
    @objc optional
    func reformerData(Manager manager: GCNetworkDelegateManager, ReformData reformData: [String: Any]?)
    
    func reformerData(Manager manager: GCNetworkDelegateManager, FailedReform reformData: [String: Any]?)

}

/// 用于数据/参数检测，如果检测返回no则请求会丢到fail的代理里面，并给出GCNetworkErrorTypeNoContent错误
protocol GCAPIManagerValidator: NSObjectProtocol {
    func checkParams(Manager manager: GCNetworkDelegateManager, CorrectParamsData params: [String: Any]?) -> Bool
    func checkCallBackData(Manager manager: GCNetworkDelegateManager, CorrectWithCallBackData data: Any?) -> Bool
}

/// 获取必须的参数，该代理必须实现否则会崩溃
@objc protocol GCAPIManager: NSObjectProtocol {
    func methodName() -> String
    func requestType() -> String
    func shouldCache() -> Bool
    @objc optional
    func cleanData()
    @objc optional
    func reformParams(Params params: [String: Any]) -> [String: Any]
}

/// 网络请求（代理方式）
class GCNetworkDelegateManager: NSObject {
    
    weak var callBackDelagate : GCNetworkManagerCallBackDelegate? = nil
    weak var paramSourceDelegate: GCAPIManagerParamSource? = nil
    weak var validatorDelegate: GCAPIManagerValidator? = nil
    weak var childDelegate: GCAPIManager? = nil
    var errorType: GCNetworkErrorType
    var isMoreData: Bool = false
    var requestConfig: GCNetworkRequestConfig?
    var response: GCURLResponse?
    var isLoading: Bool = false

    override init() {
        errorType = GCNetworkErrorType.typeDefault
        super.init()
        if self.conforms(to: GCAPIManager.self) {
            self.childDelegate = self as? GCAPIManager
        } else {
            let exception:NSException = NSException(name: NSExceptionName(rawValue: "GCNetworkManager提示"), reason: String("\(self.childDelegate)没有遵循GCAPIManager协议"), userInfo: nil)
            print("\(exception)")
        }
    }
}

extension GCNetworkDelegateManager {

    // MARK: - calling api
    
    func loadData() {
        let shouldCache = self.childDelegate?.shouldCache()
        let params = self.paramSourceDelegate?.configeApiParams(Manager: self)
        let apiString = self.childDelegate?.methodName()
        let method = self.childDelegate?.requestType()
        requestConfig = GCNetworkRequestConfig(with: method, apiString, params, nil)
        requestConfig?.shouldAllIgnoreCache = !shouldCache!
        // 准备好参数，开始请求
        self.requesData(RequesConfig: requestConfig!)
    }

    func loadMoreData() {
        let shouldCache = self.childDelegate?.shouldCache()
        let params = self.paramSourceDelegate?.configeApiParamsForMoreData?(Manager: self)
        let apiString = self.childDelegate?.methodName()
        let method = self.childDelegate?.requestType()
        requestConfig = GCNetworkRequestConfig(with: method, apiString, params, nil)
        requestConfig?.shouldAllIgnoreCache = !shouldCache!
        // 准备好参数，开始请求
        self.requesData(RequesConfig: requestConfig!)
    }
}

extension GCNetworkDelegateManager {
    
    /// 请求数据
    /// - Parameter requestConfig: 请求配置
    fileprivate func requesData(RequesConfig requestConfig: GCNetworkRequestConfig) {
        // 判断是否需要拦截请求 检验参数是否合理
        if (self.validatorDelegate?.checkParams(Manager: self, CorrectParamsData: requestConfig.params))! {
            // 正确
            if requestConfig.shouldAllIgnoreCache {
                // 忽略缓存，进行网络请求
                self.isLoading = true
                self.requesNetwork(RequestConfig: requestConfig)
            } else {
                // 从缓存中找数据
                GCNetworkCacheManager.shared.findCache(NetworkRequestConfig: requestConfig, SuccessBlock: { (successResponse) in
                    // 缓存查找成功
                }) { (failResponse) in
                    // 缓存查找失败，进行网络请求
                    self.isLoading = true
                    self.requesNetwork(RequestConfig: requestConfig)
                }
            }
        } else {
            // 参数出错
            let response:GCURLResponse = GCURLResponse(with: requestConfig)
            self.requesApiFailure(response, GCNetworkErrorType.typeParamsError)
        }
    }
    
    /// 请求网络
    /// - Parameter requsetConfig: 请求额配置
    fileprivate func requesNetwork(RequestConfig requsetConfig:GCNetworkRequestConfig) {
        if GCNetworkConfigution.shared.isReachable {
            GCAPIProxy.shared.callNetwork(with: requsetConfig, { (successResponse) in
                self.requesApiSuccess(successResponse)
            }) { (failResponse) in
                self.requesApiFailure(failResponse, GCNetworkErrorType.typeDefault)
            }
        } else {
            // 无网络,直接给出错误
            let response:GCURLResponse = GCURLResponse(with: requsetConfig)
            self.requesApiFailure(response, GCNetworkErrorType.typeNoNetwork)
            // 提示无网络
        }
    }
    
    /// 检查数据是否合法
    /// - Parameter response: 响应数据
    fileprivate func checkData(_ response: GCURLResponse) {
        if (self.validatorDelegate?.checkCallBackData(Manager: self, CorrectWithCallBackData:response.content))! {
            // 返回数据合法
            self.callBackDelagate?.requesApiSuccess(Manager: self)
        } else {
            // 检测返回数据不合法
            GCNetworkCacheManager.shared.deleteCacheObject(response.requesConfig)
            self.requesApiFailure(response, GCNetworkErrorType.typeNoContent)
        }
    }
}

extension GCNetworkDelegateManager {
    
    // MARK: - 成功
    func requesApiSuccess(_ response: GCURLResponse) {
        // 成功拿到数据后
        self.isLoading = false
        self.response = response
        // 去检测数据
        self.checkData(response)
    }

    // MARK: - 失败
    func requesApiFailure(_ response: GCURLResponse, _ errorType: GCNetworkErrorType) {
        self.response = response
        self.isLoading = false
        self.errorType = errorType
        var failureError:NSError?
        switch errorType {
        case .typeParamsError:
            failureError = GCNetworkHelper.getError(Domain: RequestErrorDomain, Info: "--------failed:请求的参数错误------", Code: errorType.rawValue)
        case .typeNoNetwork:
            failureError = GCNetworkHelper.getError(Domain: RequestErrorDomain, Info: "--------failed:暂无网络，请检查------", Code: errorType.rawValue)
        case .typeNoContent:
            failureError = GCNetworkHelper.getError(Domain: RequestErrorDomain, Info: "--------failed:返回的数据不合法------", Code: errorType.rawValue)
        default:
            failureError = GCNetworkHelper.getError(Domain: RequestErrorDomain, Info: "--------failed:暂无网络，请检查------", Code: errorType.rawValue)
            print("--------- error alert -------")
            print("暂无网络，请检查网络设置")
            print("--------- error alert -------")
        }
        // 默认的错误在底部API已处理过
        if errorType != GCNetworkErrorType.typeDefault {
            self.response?.errorType = errorType
            self.response?.error = failureError
        }
        self.callBackDelagate?.requesApiFailure(Manager: self)
    }
}
