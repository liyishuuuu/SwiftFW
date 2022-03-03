//
//  HandyJsonUtil.swift
//  GoodCam
//
//  Created by liyishu on 2021/12/6.
//

import UIKit
import HandyJSON

/**
 * HandyJSON 封装
 */
class HandyJsonUtil: NSObject {
    
    // MARK: - Json转对象
    
    /// Json转对象
    ///
    /// - Parameters:
    ///   - jsonStr: json字符串
    ///   - modelType: 对象类型
    /// - Returns: 对象
    static func jsonToModel(_ jsonStr: String, _ modelType: HandyJSON.Type) -> BaseModel {
        if jsonStr == "" || jsonStr.count == 0 {
            print("jsonoModel: 字符串为空")
            return BaseModel()
        }
        return modelType.deserialize(from: jsonStr)  as! BaseModel
    }
    
    // MARK: - Json转数组对象
    
    /// Json转数组对象
    ///
    /// - Parameters:
    ///   - jsonArrayStr: json数组字符串
    ///   - modelType: 对象类型
    /// - Returns: 对象
    static func jsonArrayToModel(_ jsonArrayStr: String, _ modelType: HandyJSON.Type) -> [BaseModel] {
        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
            print("jsonToModelArray:字符串为空")
            return []
        }
        var modelArray: [BaseModel] = []
        let data = jsonArrayStr.data(using: String.Encoding.utf8)
        let peoplesArray = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for people in peoplesArray! {
            modelArray.append(dictionaryToModel(people as! [String : Any], modelType))
        }
        return modelArray
    }
    
    // MARK: - 字典转对象
    
    /// 字典转对象
    ///
    /// - Parameters:
    ///   - dictionStr: 字典字符串
    ///   - modelType: 对象类型
    /// - Returns: 对象
    static func dictionaryToModel(_ dictionStr: [String:Any],_ modelType:HandyJSON.Type) -> BaseModel {
        if dictionStr.count == 0 {
            print("dictionaryToModel:字符串为空")
            return BaseModel()
        }
        return modelType.deserialize(from: dictionStr) as! BaseModel
    }
    
    // MARK: - 对象转JSON
    
    /// 对象转JSON
    ///
    /// - Parameter model: 对象
    /// - Returns: JSON字符串
    static func modelToJson(_ model: BaseModel?) -> String {
        if model == nil {
            print("modelToJson:model为空")
            return ""
        }
        return (model?.toJSONString())!
    }
    
    // MARK: - 对象转字典
    
    /// 对象转字典
    /// 
    /// - Parameter model: 对象
    /// - Returns: 字典
    static func modelToDictionary(_ model: BaseModel?) -> [String: Any] {
        if model == nil {
            print("modelToJson:model为空")
            return [:]
        }
        return (model?.toJSON())!
    }
}
