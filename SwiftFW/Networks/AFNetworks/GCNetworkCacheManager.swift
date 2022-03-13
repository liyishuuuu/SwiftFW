//
//  GCNetworkCacheManager.swift
//  SwiftFW
//
//  Created by liyishu on 2021/11/18.
//

import UIKit

fileprivate let RequestCacheErrorDomain = "com.network.request.caching"
fileprivate let NetworknFailingDataErrorDomain = "com.network.error.data"

class GCNetworkCacheManager: NSObject {

    static let shared: GCNetworkCacheManager = {
        let share = GCNetworkCacheManager()
        return share
    }()
    
    /// 寻找缓存
    /// - Parameters:
    ///   - requesConfig: 请求配置
    ///   - success: 成功
    ///   - failure: 失败
    func findCache(NetworkRequestConfig requesConfig: GCNetworkRequestConfig,
                   SuccessBlock success: GCRequestManagerSuccess,
                   FailureBlock failure:GCRequestManagerFailure) {
        // 缓存key
        let cacheKey = self.getCachePath(requesConfig)
        var validationError: NSError? = nil
        // 缓存数据是否可用
        let cacheReponse: GCURLResponse? = self.cacheDataAvailable(RequestConfig: requesConfig, cacheKey)
        if cacheReponse != nil {
            // 有错误
            failure(cacheReponse!)
            return
        }
        let data: Data? = GCNetworkCacheOperate.shared.getResponseCacheObject(Key: cacheKey) as? Data
        if data == nil {
            let reponse: GCURLResponse = GCURLResponse.init(with: requesConfig)
            validationError = GCNetworkHelper.getError(Domain: RequestCacheErrorDomain,
                                                       Info: "failed:缓存的为空数据",
                                                       Code: GCNetworkErrorType.typeCacheDataeError.rawValue)
            reponse.errorType = GCNetworkErrorType.typeCacheDataeError
            reponse.error = validationError
            failure(reponse)
            return
        }
        // 有正确数据
        let respondData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        let reposeObject: GCURLResponse = GCURLResponse.init(with: requesConfig, CacheResponse: respondData)
        success(reposeObject)
    }
    
    /// 存储缓存对象
    /// - Parameters:
    ///   - object: 对象
    ///   - requesConfig: 请求配置
    func storeCacheObject(With object: Any?, _ requesConfig: GCNetworkRequestConfig) {
        let cacheKey = self.getCachePath(requesConfig)
        autoreleasepool {
            if let responseData:Data =  try? JSONSerialization.data(withJSONObject: object!, options: .prettyPrinted){
                GCNetworkCacheOperate.shared.setResponseCache(Object:responseData, Key: cacheKey)
                let cacheConfig = cacheConfigModel.init(CacheTime: GCNetworkHelper.timeIntervalString(Date: Date()))
                GCNetworkCacheOperate.shared.setConfigModelCache(Object: cacheConfig, Key: cacheKey)
            }
        }
    }

    func deleteCacheObject(_ requesConfig: GCNetworkRequestConfig) {
        let cacheKey = self.getCachePath(requesConfig)
        GCNetworkCacheOperate.shared.removeResponseCacheObject(Key: cacheKey)
        GCNetworkCacheOperate.shared.removeConfigModelCacheObject(Key: cacheKey)
    }
}

extension GCNetworkCacheManager {
    
    /// 获取缓存路径
    /// - Parameter requesConfig: 请求配置
    /// - Returns: 路径
    fileprivate func getCachePath(_ requesConfig: GCNetworkRequestConfig) -> String {
        let requesString = String(describing: "method:\(String(describing: requesConfig.method)) url:\(String(describing: requesConfig.urlString)) params:\(String(describing: requesConfig.params))")
        return requesString.MD5String()
    }
    
    /// 获取可用的缓存数据
    /// - Parameters:
    ///   - requsetConfig: 请求配置
    ///   - cacheKey: 焕春键
    /// - Returns: 缓存
    fileprivate func cacheDataAvailable(RequestConfig requsetConfig: GCNetworkRequestConfig,
                                        _ cacheKey: String) -> GCURLResponse? {

        let reponse: GCURLResponse = GCURLResponse.init(with: requsetConfig)
        var validationError: NSError? = nil
        let model: cacheConfigModel? = GCNetworkCacheOperate.shared.getConfigModelCacheObject(Key: cacheKey) as? cacheConfigModel
        if model == nil {

            // 没有缓存配置文件
            validationError = GCNetworkHelper.getError(Domain: RequestCacheErrorDomain,
                                                       Info: "----failed: 没有缓冲数据----",
                                                       Code: GCNetworkErrorType.typeCacheDataeError.rawValue)
            reponse.errorType = GCNetworkErrorType.typeCacheDataeError
            reponse.error = validationError
            return reponse
        }

        // 数据是否超时间了
        if GCNetworkHelper.cacheContentOverTime(CacheTime: model!.cacheTime!){
            validationError = GCNetworkHelper.getError(Domain: RequestCacheErrorDomain,
                                                       Info: "----failed: 缓存数据过期了----",
                                                       Code: GCNetworkErrorType.typeCacheExpire.rawValue)
            reponse.errorType = GCNetworkErrorType.typeCacheExpire
            reponse.error = validationError
            return reponse
        }

        let currentAppVersion = GCNetworkHelper.getAppVersion()
        let cacheAppVersion = model!.appVersion
        if currentAppVersion != cacheAppVersion {
            // 数据是否属于当前版本的数据，不属于
            validationError = GCNetworkHelper.getError(Domain: RequestCacheErrorDomain,
                                                       Info: "----failed: 缓存数据的版本过期----",
                                                       Code: GCNetworkErrorType.typeAppVersionExpire.rawValue)
            reponse.errorType = GCNetworkErrorType.typeAppVersionExpire
            reponse.error = validationError
            return reponse
        }

        if validationError != nil {
            // 把这条没用数据删除
            GCNetworkCacheOperate.shared.removeResponseCacheObject(Key: cacheKey)
            GCNetworkCacheOperate.shared.removeConfigModelCacheObject(Key: cacheKey)
        }
        return nil
    }
}
