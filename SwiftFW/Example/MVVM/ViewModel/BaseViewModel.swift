//
//  ViewModel.swift
//  Rickenbacker
//
//  Created by liyishu on 2021/10/2.
//

import Foundation
import RxSwift
import RxCocoa

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    /// 输入 --> 输出，子类去写真正的业务逻辑代码
    /// Input conversion output, sub-category to write the real business logic code
    func transform(input: Input) -> Output
}

public protocol ViewModelPrefix {
    /// inputs修饰前缀
    /// inputs modifier prefix
    var inputs: Self { get }
    /// outputs修饰前缀
    /// outputs modifier prefix
    var outputs: Self { get }
}

open class BaseViewModel: NSObject {
    
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
    
    required public override init() { }
    
    deinit {
        print("\(self.description): ViewModel Deinited")
    }
}

extension BaseViewModel: ViewModelPrefix {
    public var inputs: Self {
        return self
    }
    
    public var outputs: Self {
        return self
    }
}
