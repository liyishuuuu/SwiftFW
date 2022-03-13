//
//  ShopAPI.swift
//  SwiftFW
//
//  Created by 赵耿怀 on 2022/2/24.
//

import UIKit

class ShopAPI: NetworkAPI {
    var parametersType: ParametersType?
    
    var url: APIHost {
        return "https://meituan.thexxdd.cn"
    }
    
    var path: APIPath {
        return "/api/forshop/wxshop"
    }
    
    var method: APIMethod {
        return .get
    }
    
    var parameters: APIParameters? {
        let params: [String: Any] = [:]
        return params
    }
    
    var plugins: APIPlugins {
        let loading = NetworkLoadingPlugin()
        return [loading]
    }
}
