//
//  Headers.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/21.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation

final class Headers{
    
    private final var headers: Dictionary<String, String>?
    
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
    
    public func getHeaders() ->Dictionary<String, String>?{
        return self.headers
    }
    
    public final class Builder{
        
        final var namesAndValues: Dictionary<String, String>
        
        public init(){
            namesAndValues = Dictionary<String, String>()
        }
        
        @discardableResult
        public func addHeader(key: String, value: String)->Builder{
            namesAndValues[key] = value
            return self
        }
        
        @discardableResult
        public func addHeaders(headers: Dictionary<String, String>?) -> Builder{
            self.namesAndValues = AutoNetUtil.mergeDictionary(first: self.namesAndValues, second: headers) as! Dictionary<String, String>
            return self
        }
        
        @discardableResult
        public func removeHeader(key: String) -> Builder{
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
