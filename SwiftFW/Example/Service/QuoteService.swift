//
//  QuoteService.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/2/20.
//  Copyright © 2020 Zafar. All rights reserved.
//
import Foundation

class QuoteService {
    
    static let shared = { QuoteService() }()
    let disposeBag = DisposeBag()
    
    func getQuotes(count: Int, success: @escaping (Int, [Quote]) -> (), failure: @escaping (Int) -> ()) {
        var api = NetworkAPIManager.init()
        api.url = APIManager.shared.baseURL+self.configureApiCall(Endpoints.QUOTES, "count", "\(count)")
        api.method = .get
        api.plugins = [NetworkLoadingPlugin.init()]
        api.request()
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe { (successResponse) in
                print("\(successResponse)")
                let resultList = successResponse as? [[String: AnyObject]]
                var modelList: [Quote] = []
                guard let count = resultList?.count else { return }
                guard let dicList = resultList else { return }
                for index in 0..<count {
                    print(dicList[index])
                    let jsonString = ConvertUtility.convertDictionaryToString(dict: dicList[index])
                    let model = HandyJsonUtil.jsonToModel(jsonString, Quote.self) as! Quote
                    modelList.append(model)
                    success(200, modelList)
                }
            } onError: { (error) in
                print("Network failed: \(error.localizedDescription)")
                failure(500)
            }
            .disposed(by: disposeBag)
    }
    
    func configureApiCall(_ baseURL: String, _ parameter: String, _ value: String) -> String {
        return baseURL + "?" + parameter + "=" + value
    }
}
