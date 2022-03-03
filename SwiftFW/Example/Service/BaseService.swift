//
//  BaseService.swift
//  HDCam
//
//  Created by liyishu on 2022/2/27.
//

import UIKit

class BaseService: NSObject {
    public let disposeBag = DisposeBag()
    /// 配置加载动画插件
    public let APIProvider: MoyaProvider<MultiTarget> = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 30
        let session = Moya.Session(configuration: configuration, startRequestsImmediately: false)
        let loading = NetworkLoadingPlugin.init()
        let debugging = NetworkDebuggingPlugin()
        return MoyaProvider<MultiTarget>(session: session, plugins: [loading, debugging])
    }()
}
