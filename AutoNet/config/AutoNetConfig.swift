//
//  AutoNetConfig.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * AutoNet 网络配置
 **/
public final class AutoNetConfig {
    
    /**
     * baseUrl, 域名
     **/
    private final var domainNames: Dictionary<String, String>
    /**
     * 头部信息
     **/
    private final var headParam: Dictionary<String, Any>
    /**
     * 拦截器
     **/
    private final var interceptors: Array<Interceptor>
    /**
     * 是否开启默认的Log日志
     **/
    private final var isOpenDefaultLog: Bool
    
    private init(){
        self.domainNames = Dictionary<String, String>()
        self.headParam = Dictionary<String, Any>()
        self.interceptors = Array<Interceptor>()
        self.isOpenDefaultLog = false
    }
    
    private init(builder: Builder){
        self.domainNames = builder.domainNames
        self.headParam = builder.headParam
        self.interceptors = builder.interceptors
        self.isOpenDefaultLog = builder.isOpenDefaultLog
    }
    
    public func getDomainNames() ->Dictionary<String, String>{
        return self.domainNames
    }
    
    public func getHeadParam() -> Dictionary<String, Any>{
        return self.headParam
    }
    
    public func getInterceptors() -> Array<Interceptor>{
        return self.interceptors
    }
    
    public func isOpendefaultLog() -> Bool{
        return self.isOpenDefaultLog
    }
    
    public final class Builder{

        var domainNames: Dictionary<String, String>
        var headParam: Dictionary<String, Any>
        var interceptors: Array<Interceptor>
        var isOpenDefaultLog: Bool
        
        public init(){
            self.domainNames = Dictionary<String, String>()
            self.headParam = Dictionary<String, Any>()
            self.interceptors = Array<Interceptor>()
            self.isOpenDefaultLog = false
        }
        
        public func setIsOpenDefaultLog(isOpen: Bool) -> Builder{
            self.isOpenDefaultLog = isOpen
            return self
        }
        
        public func setDefaultDomainName(value: String) -> Builder{
            self.domainNames["default"] = value
            return self
        }
        
        public func addDomainNames(key: String, value: String) -> Builder{
            self.domainNames[key] = value
            return self
        }
        
        public func setDomainName(domainNames: Dictionary<String, String>) -> Builder{
            self.domainNames = AutoNetUtil.mergeDictionary(first: self.domainNames, second: domainNames) as! Dictionary<String, String>
            return self
        }
        
        public func addHeadParam(key: String, value: Any) -> Builder{
            self.headParam[key] = value
            return self
        }
        
        public func setHeadParams(headParams: Dictionary<String, Any>) -> Builder{
            self.headParam = AutoNetUtil.mergeDictionary(first: self.headParam, second: headParams)
            return self
        }
        
        public func addInterceptor1(interceptor: Interceptor) ->Builder{
            self.interceptors.append(interceptor)
            return self
        }

        public func setInterceptors(interceptors: Array<Interceptor>) -> Builder{
            for interceptor in interceptors{
                self.interceptors.append(interceptor)
            }
            return self
        }
        
        public func build() ->AutoNetConfig{
            return AutoNetConfig(builder: self)
        }
        
    }
    
}
