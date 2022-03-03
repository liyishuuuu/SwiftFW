//
//  GetYouxuanService.swift
//  HDCam
//
//  Created by liyishu on 2022/2/27.
//

import UIKit

class GetYouxuanService: BaseService {
    
    static let shared = { GetYouxuanService() }()
    
    internal func getYouxuan(success: @escaping ([YouxuanModel]) -> (), failure: @escaping (String) -> ()) {
        APIProvider.rx.request(api: YouxuanAPI())
            .asObservable()
            .subscribe { (successResponse) in
                print("\(successResponse)")
                let resultList = successResponse as? [[String: AnyObject]]
                var modelList: [YouxuanModel] = []
                guard let count = resultList?.count else { return }
                guard let dicList = resultList else { return }
                for index in 0..<count {
                    print(dicList[index])
                    let jsonString = ConvertUtility.convertDictionaryToString(dict: dicList[index])
                    let model = HandyJsonUtil.jsonToModel(jsonString, YouxuanModel.self) as! YouxuanModel
                    modelList.append(model)
                }
                success(modelList)
            } onError: { (error) in
                failure(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
