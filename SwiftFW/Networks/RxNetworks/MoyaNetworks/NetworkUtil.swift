//
//  NetworkUtil.swift
//  RxNetworks
//
//  Created by liyishu on 2021/10/5.
//

import Foundation
import Moya
import RxSwift

internal struct NetworkUtil {
    
    static func defaultPlugin(_ plugins: inout APIPlugins, api: NetworkAPI) {
        var temp = plugins
        if NetworkConfig.addIndicator {
            #if RxNetworks_MoyaPlugins_Indicator
            if !temp.contains(where: { $0 is NetworkIndicatorPlugin}) {
                let Indicator = NetworkIndicatorPlugin.init()
                temp.insert(Indicator, at: 0)
            }
            #endif
        }
        if NetworkConfig.addDebugging {
            #if DEBUG && RxNetworks_MoyaPlugins_Debugging
            if !temp.contains(where: { $0 is NetworkDebuggingPlugin}) {
                let Debugging = NetworkDebuggingPlugin.init()
                temp.append(Debugging)
            }
            #endif
        }
        plugins = temp
    }
    
    static func transformAPIObservableJSON(_ result: MoyaResult?) -> APIObservableJSON {
        return APIObservableJSON.create { (observer) in
            if let result = result {
                switch result {
                case let .success(response):
                    do {
                        let response = try response.filterSuccessfulStatusCodes()
                        let jsonObject = try response.mapJSON()
                        observer.onNext(jsonObject)
                        observer.onCompleted()
                    } catch MoyaError.jsonMapping(let response) {
                        observer.onError(MoyaError.jsonMapping(response))
                    } catch MoyaError.statusCode(let response) {
                        observer.onError(MoyaError.statusCode(response))
                    } catch {
                        observer.onError(error)
                    }
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create { }
        }
    }
    
    static func handyConfigurationPlugin(_ plugins: APIPlugins, target: TargetType) -> ConfigurationTuple {
        var tuple: ConfigurationTuple
        tuple.result = nil // Empty data, convenient for subsequent plugin operations
        tuple.endRequest = false
        plugins.forEach { tuple = $0.configuration(tuple, target: target, plugins: plugins) }
        return tuple
    }
    
    static func handyLastNeverPlugin(_ plugins: APIPlugins, result: MoyaResult, target: TargetType) -> LastNeverTuple {
        var tuple: LastNeverTuple
        tuple.result = result
        tuple.againRequest = false
        plugins.forEach { tuple = $0.lastNever(tuple, target: target) }
        return tuple
    }
}
