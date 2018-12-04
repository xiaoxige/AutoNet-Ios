//
//  Headers.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 头部参数器
 **/
public final class Headers {
    
    private final var headers: Dictionary<AnyHashable, Any>?
    
    private init(){
    }
    
    private init(builder: Builder){
        self.headers = builder.namesAndValues
    }
    
    public func newBuilder(isFollow: Bool = true)-> Builder{
        let builder = Builder()
        if(isFollow){
            builder.addHeaders(headers: self.headers)
        }
        return builder
    }
    
    public func getHeaders() ->Dictionary<AnyHashable, Any>?{
        return self.headers
    }
    
    public final class Builder{
        
        final var namesAndValues: Dictionary<AnyHashable, Any>
        
        public init(){
            namesAndValues = Dictionary<AnyHashable, Any>()
        }
        
        @discardableResult
        public func addHeader(key: AnyHashable, value: Any)->Builder{
            namesAndValues[key] = value
            return self
        }
        
        @discardableResult
        public func addHeaders(headers: Dictionary<AnyHashable, Any>?) -> Builder{
            self.namesAndValues = AutoNetUtil.mergeDictionaryPlus(first: self.namesAndValues, second: headers)
            return self
        }
        
        @discardableResult
        public func removeHeader(key: AnyHashable) -> Builder{
            namesAndValues.removeValue(forKey: key)
            return self
        }
        
        @discardableResult
        public func removeAll() -> Builder{
            namesAndValues.removeAll()
            return self
        }
        
        @discardableResult
        public func build() -> Headers{
            return Headers(builder: self);
        }
        
    }

}
