//
//  GCNetworkTestManager.swift
//  GoodCam
//
//  Created by liyishu on 2021/11/19.
//

import UIKit

class GCNetworkTestManager: GCNetworkDelegateManager, GCAPIManager, GCAPIManagerValidator {
    override init() {
        super.init()
        self.validatorDelegate = self
    }
    
    func methodName() -> String {
        return "https://api.binstd.com/calendar/query?"
    }
    
    func requestType() -> String {
        return GCNetworkRequestType.get.rawValue
    }
    
    func shouldCache() -> Bool {
        return true
    }
    
    func checkParams(Manager manager: GCNetworkDelegateManager, CorrectParamsData params: [String : Any]?) -> Bool {
        return true
    }
    
    func checkCallBackData(Manager manager: GCNetworkDelegateManager, CorrectWithCallBackData data: Any?) -> Bool {
        return true
    }
}
