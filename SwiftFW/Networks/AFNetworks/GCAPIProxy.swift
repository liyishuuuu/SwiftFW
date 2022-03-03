//
//  GCAPIProxy.swift
//  GoodCam
//
//  Created by liyishu on 2021/11/18.
//

import UIKit
import AFNetworking

// 成功回调
typealias GCRequestManagerSuccess = (_ successResponse: GCURLResponse) -> Void
// 失败回调
typealias GCRequestManagerFailure = (_ failResponse: GCURLResponse) -> Void
// 请求进程
typealias GCRequestManagerProgress = (_ progress: Progress?) -> Void
// 域
fileprivate let RequestErrorDomain = "com.network.request"

/**
 * APIProxy
 */
class GCAPIProxy: NSObject {
    var sessionManager: AFHTTPSessionManager?
    var requestDic: [String : GCURLResponse]?
    
    static let shared: GCAPIProxy = {
        let share = GCAPIProxy()
        share.requestDic = [:]
        return share
    }()
    
    /// 网络请求
    /// - Parameters:
    ///   - requestConfig: request配置
    ///   - successCompletionBlock: 成功回调
    ///   - failureCompletionBlock: 失败回调
    func callNetwork(with requestConfig: GCNetworkRequestConfig,
                     _ successCompletionBlock: @escaping GCRequestManagerSuccess,
                     _ failureCompletionBlock: @escaping GCRequestManagerFailure) {
        sessionManager = self.getSessionManager(with: requestConfig)
        var dataTask: URLSessionDataTask?
        guard let request: URLRequest = generateRequest(with: requestConfig) as URLRequest? else { return }
        dataTask = sessionManager!.dataTask(with: request,
                                            uploadProgress: nil,
                                            downloadProgress: nil,
                                            completionHandler: { (response, responseObject, error) in
            
            guard let requestId = dataTask?.taskIdentifier else { return }
            var urlRespose: GCURLResponse? = self.requestDic?[String(requestId)]
            let httpRespose: HTTPURLResponse = response as! HTTPURLResponse
            
            if urlRespose == nil {
                urlRespose = GCURLResponse(with: requestConfig, requestId, request)
            }
            var dataTip: Any? = responseObject
            if responseObject == nil {
                dataTip = ["data" : "后台没有返回数据，请检查网络是否连接，接口是否存在"]
            }
            var responseString: String?
            var newResposeData: Data?
            if let responseData: Data = try? JSONSerialization.data(withJSONObject: dataTip!, options: .prettyPrinted) {
                newResposeData = responseData
                responseString = String(data: responseData, encoding: .utf8)
            }
            
            if (error != nil) {
                // 请求返回
                let response: GCURLResponse = self.reponseParams(with: urlRespose!,
                                                                 content: dataTip,
                                                                 responseString,
                                                                 error as NSError?,
                                                                 newResposeData,
                                                                 dataTask,
                                                                 httpRespose)
                // 打印日志
                GCNetworkLogManager.shared.logDebugInfo(URLResponse: response)
                // 网络连接异常
                if (response.error?.code == -1009) {
                    GCToastView.showBottomWithText(text: "无法连接网络 错误码：\(String(describing: response.error!.code))")
                }
                // 回调
                failureCompletionBlock(response)
            } else {
                let response: GCURLResponse = self.reponseParams(with: urlRespose!, content: dataTip, responseString, nil,
                                                                 newResposeData, dataTask,httpRespose)
                // 打印日志
                GCNetworkLogManager.shared.logDebugInfo(URLResponse: response)
                let responseContent = responseObject as? [String : Any]
                let code = responseContent?["code"] as? Int
                if code != nil {
                    
                    // 如果后台返回了code，检测code是否合法
                    if GCNetworkCodeCheck.checkCode(Code: code!)  {
                        
                        // 检测code，合法
                        successCompletionBlock(response)
                        if !requestConfig.shouldAllIgnoreCache {
                            
                            // 把数据缓存下
                            GCNetworkCacheManager.shared.storeCacheObject(With: responseObject, requestConfig)
                        }
                    } else {
                        
                        // 不合法code
                        let userInfo = [NSLocalizedDescriptionKey: "----failed: code错误----"]
                        let error = NSError.init(domain: RequestErrorDomain, code: code!, userInfo: userInfo)
                        response.errorType = GCNetworkErrorType.typeTokenError
                        response.error = error
                        failureCompletionBlock(response)
                    }
                } else {
                    successCompletionBlock(response)
                }
            }
            self.requestDic?.removeValue(forKey: String(requestId))
        })
        dataTask?.resume()
        self.startLoadRequest(with: request, dataTask, requestConfig)
    }
    
    /// 取消具体某个请求
    /// - Parameter requestId: requestId
    func cancelRequest(with requestId: Int){
        let reponse:GCURLResponse? = self.requestDic?[String(requestId)]
        guard let reponsed = reponse else { return }
        let requestOperation: URLSessionDataTask? = reponsed.task
        requestOperation?.cancel()
        self.requestDic?.removeValue(forKey: String(requestId))
    }
    
    // 取消全部请求
    func cancelAllRequest() {
        guard let requestDic = self.requestDic else { return}
        for key in requestDic.keys {
            self.cancelRequest(with: Int(key)!)
        }
    }
}

extension GCAPIProxy {
    
    fileprivate func getSessionManager(with configution: GCNetworkRequestConfig) -> AFHTTPSessionManager {
        let sessionManager : AFHTTPSessionManager = AFHTTPSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
        if configution.needSerializer {
            sessionManager.requestSerializer = AFJSONRequestSerializer()
            
            // 请求头设置
            sessionManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
            sessionManager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        sessionManager.requestSerializer.timeoutInterval = TimeInterval(GCNetworkConfigution.shared.timeoutInterval)
        sessionManager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "application/json",
                                                                       "text/json",
                                                                       "text/javascript",
                                                                       "text/html",
                                                                       "text/plain",
                                                                       "application/atom+xml",
                                                                       "application/xml",
                                                                       "text/xml",
                                                                       "application/octet-stream",
                                                                       "multipart/mixed")
        return sessionManager
    }
    
    fileprivate func generateRequest(with configution: GCNetworkRequestConfig) -> NSURLRequest? {
        guard let method = configution.method else { return nil }
        guard let urlString = configution.urlString else { return nil }
        guard let params = configution.params else { return nil }
        let request: NSMutableURLRequest?
        do {
            request = try self.sessionManager!.requestSerializer.request(withMethod: method, urlString: urlString, parameters: params)
            return request
        } catch {
            return nil
        }
    }
    
    fileprivate func startLoadRequest(with request: URLRequest,
                                      _ dataTask: URLSessionDataTask?,
                                      _ requestConfig: GCNetworkRequestConfig) {
        let requestId: Int = dataTask?.taskIdentifier ?? 0
        let urlRespose: GCURLResponse = GCURLResponse(with: requestConfig, requestId, request)
        urlRespose.startTime = getNowTime()
        self.requestDic?[String(requestId)] = urlRespose
    }
    
    fileprivate func reponseParams(with urlRespose:GCURLResponse,
                                   content: Any?,
                                   _ responseString:String?,
                                   _ error:NSError?,
                                   _ responseData: Data?,
                                   _ dataTask:URLSessionDataTask?,
                                   _ httpResponse:HTTPURLResponse) -> GCURLResponse {
        urlRespose.contentString = responseString
        urlRespose.errorType = urlRespose.responseStatus(with: error as NSError?)
        urlRespose.content = content
        urlRespose.responseData = responseData
        urlRespose.error = error
        urlRespose.task = dataTask
        urlRespose.endTime = self.getNowTime()
        urlRespose.isFormeCache = false
        urlRespose.httpResponse = httpResponse
        return urlRespose
    }
}

extension GCAPIProxy {
    func getNowTime() -> String {
        let nowDate = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: nowDate) as String
        return strNowTime
    }
}
