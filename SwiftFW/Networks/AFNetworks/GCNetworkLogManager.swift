//
//  GCNetworkLogManager.swift
//  SwiftFW
//
//  Created by liyishu on 2021/11/19.
//

import UIKit

class GCNetworkLogManager: NSObject {
    
    static let shared: GCNetworkLogManager = GCNetworkLogManager()
    
    func logDebugInfo(Request reques: URLRequest, RequsetConfig config: GCNetworkRequestConfig ) {
#if DEBUG
        var logString:String = """
                               
                               ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊ AFN API Request Start ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
                               
                               """
        logString.append("URLSting:\t\t\(String(describing: config.urlString))\n")
        logString.append("Method:\t\t\t\(String(describing: config.method))\n")
        logString.append("Params:\n\(String(describing: config.params))")
        let newLogS = self.appendURL(Request: reques, LogString: logString)
        print("\(newLogS)")
#endif
    }
    
    func logDebugInfo(URLResponse responsed:GCURLResponse) {
#if DEBUG
        var logString: String = """
                               
                               ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊ AFN API Request Start ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
                               
                               """
        var shouldLogError : Bool = false
        logString.append("StartTime:\t\(String(describing: responsed.startTime))\n")
        logString.append("EndTime:\t\(String(describing: responsed.startTime))\n")
        logString.append("Status:\t\(String(describing: responsed.httpResponse?.statusCode))\t(\(HTTPURLResponse.localizedString(forStatusCode: responsed.httpResponse?.statusCode ?? 0)))\n")
        logString.append("Content:\n\t\(String(describing: responsed.contentString))\n\n")
        
        if let responseData:Any =  try? JSONSerialization.jsonObject(with: responsed.responseData!, options: .mutableContainers) {
            let content:[String:Any] = responseData as! [String:Any]
            let code = content["code"] as? Int
            if code != 0 && code != nil{
                shouldLogError = true
            }
        }
        if responsed.httpResponse?.statusCode != 200 || responsed.error != nil { shouldLogError = true }
        if shouldLogError {
            logString.append("Error URL:\t\t\t\(String(describing: responsed.request?.url?.absoluteString))\n")
            logString.append("Error Domain:\t\t\t\t\t\t\t\(String(describing: responsed.error?.domain))\n")
            logString.append("Error Domain Code:\t\t\t\t\t\t\(String(describing: responsed.error?.code))\n")
            logString.append("Error Localized Description:\t\t\t\(String(describing: responsed.error?.localizedDescription))\n")
            logString.append("Error Localized Failure Reason:\t\t\t\(String(describing: responsed.error?.localizedFailureReason))\n")
            logString.append("Error Localized Recovery Suggestion:\t\(String(describing: responsed.error?.localizedRecoverySuggestion))\n\n")
        }
        logString.append("""
                         
                         ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊ AFN API Request Content ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
                         
                         """)
        var newLogS = self.appendURL(Request: responsed.request!, LogString:logString)
        newLogS.append("""
                        
                       ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊ AFN API requestEnd ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
                        
                       """)
        print("\(newLogS)")
#endif
    }
    
    func appendURL(Request request: URLRequest, LogString logString: String) -> String {
        var log = logString
        log.append("\n\nHTTP URL:\n\t\(String(describing: request.url))")
        if let allHeader = request.allHTTPHeaderFields {
            log.append("\n\nHTTP Header:\n\(allHeader)")
        }else {
            log.append("\n\nHTTP Header:\n\t\t\t\t\tN/A")
        }
        var httpBody:String = "N/A"
        if request.httpBody != nil{
            httpBody = String(describing: String(data: request.httpBody!, encoding: .utf8))
        }
        log.append("\n\nHTTP Body:\n\t\(httpBody)")
        return log
    }
}
