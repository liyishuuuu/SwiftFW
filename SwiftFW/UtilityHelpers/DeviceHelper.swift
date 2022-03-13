//
//  DeviceHelper.swift
//  SwiftFW
//
//  Created by liyishu on 2021/12/30.
//

import UIKit
import Foundation
import CoreLocation
import LocalAuthentication
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

class DeviceHelper: NSObject {
    
    static func getStatusBarHeight() -> CGFloat {
        var statusBarHeight = 0 as CGFloat
        if #available(iOS 13.0, *) {
            guard let statusBarManager = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first!.windowScene!.statusBarManager else { return 0.0}
            statusBarHeight = statusBarManager.statusBarFrame.size.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    static func getNowTime() -> String {
        let nowDate = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
        let strNowTime = timeFormatter.string(from: nowDate) as String
        return strNowTime
    }
    
    static func getUsedSSID() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = emptyString
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                }
            }
        }
        return ssid
    }
    
    static func getWindowSafeAreaInset() -> UIEdgeInsets {
        var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            
            let window: UIWindow = UIApplication.shared.connectedScenes
                                    .filter({$0.activationState == .foregroundActive})
                                    .map({$0 as? UIWindowScene})
                                    .compactMap({$0})
                                    .first?.windows
                                    .filter({$0.isKeyWindow}).last! ?? UIWindow()
            
            insets = window.safeAreaInsets
        }
        return insets
    }
}
