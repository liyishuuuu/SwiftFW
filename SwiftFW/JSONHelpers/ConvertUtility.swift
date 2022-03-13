//
//  ConvertUtility.swift
//  SwiftFW
//
//  Created by liyishu on 2021/12/6.
//

import UIKit

/**
 * 数据类型转换工具类
 */
class ConvertUtility: NSObject {
    
    // MARK: - 字符串转字典
    
    ///  字符串转字典
    ///
    /// - Parameters
    ///  - text: 字符串
    /// - Returns: 字典
    static func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data,
                                                        options: [JSONSerialization.ReadingOptions.init(rawValue: 0)])
                as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    // MARK: - 字典转字符串
    
    ///  字典转字符串
    ///
    /// - Parameters
    ///  - dict: 字典
    /// - Returns: 字符串
    static func convertDictionaryToString(dict: [String: AnyObject]) -> String {
        var result:String = emptyString
        do {
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: dict,
                                                      options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
        } catch {
            result = emptyString
        }
        return result
    }
    
    // MARK: - 数组转字符串
    
    /// 数组转字符串
    ///
    /// - Parameters
    ///  - arr: 数组
    /// - Returns: 字符串
    static func convertArrayToString(arr: [AnyObject]) -> String {
        var result:String = emptyString
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arr,
                                                      options: JSONSerialization.WritingOptions.init(rawValue: 0))
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
        } catch {
            result = emptyString
        }
        return result
    }
    
    // 颜色转图片
    static func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
    // 时间戳转成字符串
    static func timeIntervalChangeToTimeStr(timeInterval:Double, _ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        let date:Date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        } else {
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    
    // URL转图片
    static func imageFromUrl(iconUrl: NSString?) -> UIImage {
        var resultImage = UIImage()
        guard let urlString = iconUrl else {
            return resultImage
        }
        guard let url: URL = URL(string: urlString as String) else {
            return resultImage
        }
        if let data: NSData = NSData(contentsOf: url) {
            resultImage = UIImage(data: data as Data) ?? UIImage()
        }
        return resultImage
    }
}
