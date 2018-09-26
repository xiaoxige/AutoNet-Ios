//
//  NetConfig.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/21.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation

final class NetConfing{
    
    private final var baseUrls: Dictionary<String, String>?
    private final var urlSessionConfiguration:URLSessionConfiguration?
    private final var intercepors: Array<Interceptor>?
    
    private init(){
    }
    
    private init(builder: Builder){
        self.baseUrls = builder.baseUrls;
        self.urlSessionConfiguration = builder.urlSessionConfiguration
        self.intercepors = builder.intercepors
    }
    
    func getBaseUrls() ->Dictionary<String, String>{
        return self.baseUrls!
    }
    
    func getUrlSessionConfiguration() ->URLSessionConfiguration{
        return self.urlSessionConfiguration!
    }
    
    func getIntercepors() -> Array<Interceptor> {
        return self.intercepors!
    }
    
    public final class Builder{
        
        var baseUrls: Dictionary<String, String>
        var urlSessionConfiguration:URLSessionConfiguration
        var intercepors: Array<Interceptor>

        public init() {
            baseUrls = Dictionary<String, String>()
            urlSessionConfiguration = .default
            urlSessionConfiguration.httpMaximumConnectionsPerHost = 1
            urlSessionConfiguration.timeoutIntervalForRequest = 15
            intercepors = Array<Interceptor>()
        }
        
        public func addDefaultBaseUrl(baseUrl: String) -> Builder{
            self.baseUrls["default"] = baseUrl
            return self
        }
        
        public func addBaseUrl(baseKey: String, baseUrl: String, isApped: Bool = true) -> Builder{
            if(!isApped){
                self.baseUrls.removeAll()
            }
            self.baseUrls[baseKey] = baseUrl
            return self
        }
        
        public func setBaseUrl(baseUrls: Dictionary<String, String>, isApped: Bool = true) -> Builder{
            if(!isApped){
                self.baseUrls.removeAll()
            }
            for key in baseUrls.keys{
                self.baseUrls[key] = baseUrls[key]
            }
            self.baseUrls = AutoNetUtil.mergeDictionary(first: self.baseUrls, second: baseUrls) as! Dictionary<String, String>
            return self
        }
        
        public func removeBaseUrl(baseKey: String) -> Builder{
            self.baseUrls.removeValue(forKey: baseKey)
            return self
        }
        
        public func setURLSessionConfiguration(urlSessionCOnfiguration: URLSessionConfiguration) -> Builder{
            self.urlSessionConfiguration = urlSessionCOnfiguration
            return self
        }
        
        public func addInterceptor(interceptor: Interceptor, isApped: Bool) -> Builder{
            if(!isApped){
                self.intercepors.removeAll()
            }
            self.intercepors.append(interceptor)
            return self
        }
        
        public func setInterceptor(interceptors: Array<Interceptor>, isApped: Bool = true) -> Builder{
            if(!isApped){
                self.intercepors.removeAll()
            }
            for interceptor in interceptors{
                self.intercepors.append(interceptor)
            }
            return self
        }
        
        public func build() -> NetConfing{
            return NetConfing(builder: self)
        }
        
    }
}
