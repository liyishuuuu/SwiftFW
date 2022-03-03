//
//  NetworkAPIManager.swift
//  RxNetworks
//
//  Created by liyishu on 2021/10/5.
//

import Foundation
import Moya

/// 请求参数类型
public enum ParametersType {
    case json
    case queryString
}

/// OOP, Convenient for the usage habits of OC partners
public struct NetworkAPIManager {
    
    /// Request host
    public var url: APIHost?
    /// Request path
    public var path: APIPath?
    /// Request parameters
    public var parameters: APIParameters?
    /// Request parameters type
    public var parametersType: ParametersType = .queryString
    /// Request type
    public var method: APIMethod?
    /// Plugin array
    public var plugins: APIPlugins?
    /// Failed retry count
    public var retry: APINumber = 0
    /// Test data, after setting the value of this property, only the test data is taken
    public var testJSON: String?
    /// Test data return time, the default is half a second
    public var testTime: TimeInterval = 0.5
    
    /// OOP Network request.
    /// Example:
    ///
    ///     var api = NetworkAPIOO.init()
    ///     api.cy_ip = "https://www.httpbin.org"
    ///     api.cy_path = "/ip"
    ///     api.cy_method = APIMethod.get
    ///     api.cy_plugins = [NetworkLoadingPlugin.init()]
    ///     api.cy_testJSON = "{\"liyishu\":\"ykj310@126.com\"}"
    ///
    ///     api.cy_HTTPRequest()
    ///         .asObservable()
    ///         .observe(on: MainScheduler.instance)
    ///         .subscribe { (data) in
    ///             print("\(data)")
    ///         } onError: { (error) in
    ///             print("Network failed: \(error.localizedDescription)")
    ///         }
    ///         .disposed(by: disposeBag)
    ///
    /// - Parameter callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Observable sequence JSON object. May be thrown twice.
    public func request(_ callbackQueue: DispatchQueue? = nil) -> APIObservableJSON {
        var api = NetworkObjectAPI.init()
        api._url = url
        api._path = path
        api._parameters = parameters
        api._parametersType = parametersType
        api._method = method
        api._plugins = plugins
        api._retry = retry
        if let json = testJSON {
            api._test = json
            if testTime > 0 {
                api._stubBehavior = StubBehavior.delayed(seconds: testTime)
            } else {
                api._stubBehavior = StubBehavior.immediate
            }
        } else {
            api._stubBehavior = StubBehavior.never
        }
        return api.request(callbackQueue: callbackQueue)
    }
    public init() { }
}

internal struct NetworkObjectAPI: NetworkAPI {
    var _url: APIHost?
    var _path: APIPath?
    var _parameters: APIParameters?
    var _parametersType: ParametersType?
    var _method: APIMethod?
    var _plugins: APIPlugins?
    var _retry: APINumber?
    var _stubBehavior: APIStubBehavior?
    var _test: String?
    
    public var url: APIHost {
        return _url ?? NetworkConfig.baseURL
    }
    
    public var path: String {
        return _path ?? ""
    }
    
    public var parametersType: ParametersType? {
        return _parametersType ?? .queryString
    }
    
    public var parameters: APIParameters? {
        return _parameters
    }
    
    public var method: APIMethod {
        return _method ?? NetworkConfig.baseMethod
    }
    
    public var plugins: APIPlugins {
        return _plugins ?? []
    }
    
    public var retry: APINumber {
        return _retry ?? 0
    }
    
    public var stubBehavior: APIStubBehavior {
        return _stubBehavior ?? StubBehavior.never
    }
    
    public var sampleData: Data {
        if let json = _test {
            return json.data(using: String.Encoding.utf8)!
        }
        return "{\"liyishu\":\"liyishu@163.com\"}".data(using: String.Encoding.utf8)!
    }
}
