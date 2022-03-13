//
//  Color+Extentsion.swift
//  SwiftFW
//
//  Created by liyishu on 2021/11/29.
//

import UIKit

// MARK: - RGBA

/// RGBA
func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r/225.0, green: g/225.0, blue: b/225.0, alpha: a)
}

// MARK: - RGB

/// RGB
func RGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: r/225.0, green: g/225.0, blue: b/225.0, alpha: 1.0)
}

// MARK: - 颜色扩展

/**
 * 颜色扩展
 */
extension UIColor {
    
    /// rgba
    public static func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    /// rgb
    public static func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return RGBA(r, g, b, 1.0)
    }
    
    /// UIColor转化为16进制
    public var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        var rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8
        rgb = rgb | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
    
    // MARK: - 颜色 十六进制 
    /// 16进制转rgb
    /// 调用 example: backgroundColor = UIColor.init(hexString: "0xEDEDED")
    public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        
        // 将传过来的字符串格式format ("0x" -> ""; "#" -> "")
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        
        // 将格式化后的字符串转为十六进制数
        if let hex = Int(formatted, radix: 16) {
            
            // 十六进制数转rgb
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16) / 255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8) / 255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0) / 255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
}

