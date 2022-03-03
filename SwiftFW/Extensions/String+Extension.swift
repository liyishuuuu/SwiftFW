//
//  String+Extension.swift
//  GoodCam
//
//  Created by liyishu on 2021/12/1.
//

import UIKit
import CommonCrypto

/**
 * 字符串扩展
 */
extension String {
    
    // MARK: - 使用下标截取字符串中的单个字符
    
    /// String使用下标截取字符串
    /// string[index] 例如："abcdefg"[3] // c
    subscript(i: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    
    // MARK: - 使用下标截取字符串中的范围内的子字符串
    
    /// String使用下标截取字符串
    /// string[index..<index] 例如："abcdefg"[3..<4] // d
    subscript(r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
    // MARK: - 使用下标截取字符串中的范围内的子字符串（从i开始n个）
    
    /// String使用下标截取字符串
    /// string[index,length] 例如："abcdefg"[3,2] // de
    subscript(index: Int, length: Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    
    // MARK: - 使用下标截取字符串中的范围内的子字符串（从头到i位置）
    
    // 截取 从头到i位置
    func substring(to: Int) -> String {
        return self[0..<to]
    }
    
    // MARK: - 使用下标截取字符串中的范围内的子字符串（从i到尾部）
    
    // 截取 从i到尾部
    func substring(from: Int) -> String {
        return self[from..<self.count]
    }
    
    // MARK: - 获取String宽度
    
    func sizeWith(_ font : UIFont , _ maxSize : CGSize) -> CGSize {
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        var attributes : [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.font] = font
        let textBouds = self.boundingRect(with: maxSize,
                                                  options: options,
                                                  attributes: attributes,
                                                  context: nil)
        return textBouds.size
    }
}

/**
 * MD5加密
 */
extension String {
    func MD5String() -> String! {
        let cStr = self.cString(using: String.Encoding.utf8)
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_SHA256(cStr!, (CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString()
        for i in 0 ..< 16 {
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return String(format: md5String as String)
    }
}
