//
//  NetworkAPI+Extension.swift
//  RxNetworks
//
//  Created by liyishu on 2021/10/5.
//

import Foundation
import Moya
import RxSwift
import Alamofire

/// 协议默认实现方案
/// Protocol default implementation scheme
extension NetworkAPI {
    
    public func request() -> APIObservableJSON {
        return request(callbackQueue: nil)
    }
    
    public func request(callbackQueue: DispatchQueue?) -> APIObservableJSON {
        var tempPlugins: APIPlugins = self.plugins
        NetworkUtil.defaultPlugin(&tempPlugins, api: self)
        let target = MultiTarget.target(self)
        let (result, end) = NetworkUtil.handyConfigurationPlugin(tempPlugins, target: target)
        if end == true {
            let single = NetworkUtil.transformAPIObservableJSON(result)
            return single
        }
        let configuration = URLSessionConfiguration.default
        configuration.headers = Alamofire.HTTPHeaders.default
        configuration.timeoutIntervalForRequest = 30
        let session = Moya.Session(configuration: configuration, startRequestsImmediately: false)
        let MoyaProvider = MoyaProvider<MultiTarget>(stubClosure: { _ in
            return stubBehavior
        }, session: session, plugins: tempPlugins)
        return MoyaProvider.rx.request(api: self, callbackQueue: callbackQueue, result: result)
    }
}

extension NetworkAPI {
    public var url: APIHost {
        return NetworkConfig.baseURL
    }
    
    public var parameters: APIParameters? {
        return nil
    }
    
    public var parametersType: ParametersType? {
        return .queryString
    }
    
    public var plugins: APIPlugins {
        return []
    }
    
    public var stubBehavior: APIStubBehavior {
        return APIStubBehavior.never
    }
    
    public var retry: APINumber {
        return 0
    }
    
    // moya
    public var baseURL: URL {
        return URL(string: url)!
    }
    
    public var path: APIPath {
        return ""
    }
    
    public var validationType: Moya.ValidationType {
        return Moya.ValidationType.successCodes
    }
    
    public var method: APIMethod {
        return NetworkConfig.baseMethod
    }
    
    public var sampleData: Data {
        return "{\"liyishu\":\"liyishu17@163.com\"}".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    public var task: Moya.Task {
        var param = NetworkConfig.baseParameters
        if let parameters = parameters {
            
            // Merge the dictionaries and take the second value
            param = NetworkConfig.baseParameters.merging(parameters) { $1 }
        }
        switch method {
        case APIMethod.get:
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case APIMethod.post:
            switch parametersType {
            case .queryString:
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            case .json:
                return .requestParameters(parameters: param, encoding: JSONEncoding.default)
            case .none:
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            }
        default:
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
}
