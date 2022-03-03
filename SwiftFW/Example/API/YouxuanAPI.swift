//
//  YouxuanAPI.swift
//  HDCam
//
//  Created by liyishu on 2022/2/23.
//

import UIKit

class YouxuanAPI: NetworkAPI {
    var parametersType: ParametersType?
    
    var url: APIHost {
        return "https://meituan.thexxdd.cn"
    }
    
    var path: APIPath {
        return "/api/forshop/getprefer"
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
