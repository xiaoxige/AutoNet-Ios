//
//  RequestParams.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 请求参数器
 **/
public final class RequestParam {
    
    private final var params: Dictionary<String, Any>?
    
    private init(){
    }
    
    public init(builder: Builder){
        params = builder.namesAndValues
    }
    
    public func newBuilder(isFollow: Bool = true)-> Builder{
        let builder = Builder()
        if(isFollow){
            builder.addParams(params: self.params)
        }
        return builder
    }
    
    public func getParams() -> Dictionary<String, Any>?{
        return self.params
    }
    
    public final class Builder{
        
        final var namesAndValues: Dictionary<String, Any>
        
        public init(){
            namesAndValues = Dictionary<String, Any>()
        }
        
        @discardableResult
        public func addParam(key: String, value: Any)->Builder{
            namesAndValues[key] = value
            return self
        }
        
        @discardableResult
        public func addParams(params: Dictionary<String, Any>?) -> Builder{
            self.namesAndValues = AutoNetUtil.mergeDictionary(first: self.namesAndValues, second: params)
            return self
        }
        
        @discardableResult
        public func removeParams(key: String) -> Builder{
            namesAndValues.removeValue(forKey: key)
            return self
        }
        
        @discardableResult
        public func removeAll() -> Builder{
            namesAndValues.removeAll()
            return self
        }
        
        @discardableResult
        public func build() -> RequestParam{
            return RequestParam(builder: self)
        }
        
    }
}
