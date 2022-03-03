//
//  GetShopService.swift
//  HDCam
//
//  Created by liyishu on 2022/2/27.
//

import UIKit

class GetShopService: BaseService {
    static let shared = { GetShopService() }()
    internal func getShop(success: @escaping ([ShopModel]) -> (), failure: @escaping (String) -> ()) {
        APIProvider.rx.request(api: ShopAPI())
            .asObservable()
            .subscribe { (successResponse) in
                print("\(successResponse)")
                let resultList = successResponse as? [[String: AnyObject]]
                var modelList: [ShopModel] = []
                guard let count = resultList?.count else { return }
                guard let dicList = resultList else { return }
                for index in 0..<count {
                    print(dicList[index])
                    let jsonString = ConvertUtility.convertDictionaryToString(dict: dicList[index])
                    let model = HandyJsonUtil.jsonToModel(jsonString, ShopModel.self) as! ShopModel
                    modelList.append(model)
                    success(modelList)
                }
            } onError: { (error) in
                failure(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
