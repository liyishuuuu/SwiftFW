//
//  HandyDataModel.swift
//  RxNetworks
//
//  Created by liyishu on 2021/10/6.
//

import Foundation
import HandyJSON

public final class HandyDataModel<T>: HandyJSON {
    public var code: String?
    public var message: String?
    public var data: T?

    public required init() { }
}

extension HandyDataModel {
    public func isSuccess() -> Bool {
        guard let code = code else {
            return false
        }
        return Int.init(code)! == 200
    }
}

/// Example:
///
///     let data = PublishRelay<[CacheModel]>()
///
///         CacheAPI.cache.request()
///             .asObservable()
///             .mapHandyJSON(HandyDataModel<[CacheModel]>.self)
///             .compactMap { $0.data }
///             .bind(to: data)
///             .disposed(by: disposeBag)
///
///
