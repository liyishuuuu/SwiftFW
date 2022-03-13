//
//  GCNetworkCacheOperate.swift
//  SwiftFW
//
//  Created by liyishu on 2021/11/18.
//

import UIKit
import YYCache

class cacheConfigModel: NSObject,NSSecureCoding {
    
    private let cacheVersionEncode = "cacheVersion_encode"
    private let cacheTimeEncode = "cacheTime_encode"
    private let appVersionEncode = "appVersion_encode"
    var cacheVersion: String?
    var cacheTime: String?
    var appVersion : String?
    
    static var supportsSecureCoding: Bool {
        get { return true }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.cacheVersion, forKey: cacheVersionEncode)
        aCoder.encode(self.cacheTime, forKey: cacheTimeEncode)
        aCoder.encode(self.appVersionEncode, forKey: appVersionEncode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.cacheVersion = aDecoder.decodeObject(of: NSString.self, forKey: cacheVersionEncode) as String?
        self.cacheTime = aDecoder.decodeObject(of: NSString.self, forKey: cacheTimeEncode) as String?
        self.appVersion = aDecoder.decodeObject(of: NSString.self, forKey: appVersionEncode) as String?
        
    }
    
    init(CacheTime time:String) {
        self.cacheTime = time
        self.cacheVersion = GCNetworkConfigution.shared.memoryCacheVersion
        self.appVersion = GCNetworkHelper.getAppVersion()
    }
}

class GCNetworkCacheOperate: NSObject {
    
    let configModelCache : YYCache
    let responseCache : YYCache
    
    static let shared: GCNetworkCacheOperate = {
        let share = GCNetworkCacheOperate()
        return share
    }()
    
    override init() {
        self.configModelCache = YYCache.init(name: NSStringFromClass(cacheConfigModel.self))!
        self.configModelCache.memoryCache.countLimit = UInt(GCNetworkConfigution.shared.countLimint)
        self.configModelCache.diskCache.countLimit = UInt(GCNetworkConfigution.shared.countLimint)
        self.responseCache = YYCache.init(name: NSStringFromClass(GCNetworkCacheOperate.self))!
        self.responseCache.memoryCache.countLimit = UInt(GCNetworkConfigution.shared.countLimint)
        self.responseCache.diskCache.countLimit = UInt(GCNetworkConfigution.shared.countLimint)
    }
}

extension GCNetworkCacheOperate {
    
    func setConfigModelCache(Object object:Any?, Key key:String){
        self.configModelCache.setObject(object as? NSCoding, forKey: key)
    }
    
    func getConfigModelCacheObject(Key key:String) -> Any? {
        return self.configModelCache.object(forKey: key)
    }
    
    func removeConfigModelCacheObject(Key key:String){
        self.configModelCache.removeObject(forKey: key)
    }
    
    func removeAllConfigModelCacheObject() {
        self.configModelCache.removeAllObjects()
    }
}

extension GCNetworkCacheOperate {
    
    func setResponseCache(Object object: Any?, Key key: String){
        self.responseCache.setObject(object as? NSCoding, forKey: key)
    }
    
    func getResponseCacheObject(Key key: String) -> Any? {
        return self.responseCache.object(forKey: key)
    }
    
    func removeResponseCacheObject(Key key:String){
        self.responseCache.removeObject(forKey: key)
    }
    
    func removeAllResponseCacheObject() {
        self.responseCache.removeAllObjects()
    }
}
