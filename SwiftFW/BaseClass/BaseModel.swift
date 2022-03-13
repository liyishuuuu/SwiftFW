//
//  BaseModel.swift
//  SwiftFW
//
//  Created by liyishu on 2021/12/29.
//

import UIKit
import HandyJSON

/**
 * Model 基类 继承至HandyJSON
 */
class BaseModel: HandyJSON {
    required init() {}
    
    // 自定义解析规则
    func mapping(mapper: HelpingMapper) {
    }
}
