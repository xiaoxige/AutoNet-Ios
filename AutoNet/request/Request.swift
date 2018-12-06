//
//  Request.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/22.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 请求合并体（主要用于拦截器传递使用）
 **/
public final class Request{
    
    private final var url: String
    private final var method: AutoNetPattern
    private final var header: Headers?
    private final var param: RequestParam?
    
    private init() {
        self.url = ""
        self.method = AutoNetPattern.get
    }
    
    private init(build: Builder){
        self.url = build.url
        self.method = build.method
        self.header = build.header
        self.param = build.param
    }
    
    public func getUrl() ->String{
        return self.url
    }
    
    public func getMethod() -> AutoNetPattern{
        return self.method
    }
    
    public func getHeader() -> Headers?{
        return self.header
    }
    
    public func getParam() ->RequestParam?{
        return self.param
    }
    
    public func newBuilder() -> Builder{
        return Builder()
        .setUrl(url: self.url)
        .setMethod(method: self.method)
        .setHeaders(header: self.header)
        .setParam(param: self.param)
    }
    
    public final class Builder{
        
        final var url: String
        final var method: AutoNetPattern
        final var header: Headers?
        final var param: RequestParam?
        
        init() {
            self.url = ""
            self.method = AutoNetPattern.get
        }
        
        @discardableResult
        func setUrl(url: String) -> Builder{
            self.url = url
            return self
        }
        
        func setMethod(method: AutoNetPattern) -> Builder {
            self.method = method
            return self
        }
        
        func setHeaders(header: Headers?) -> Builder{
            self.header = header
            return self
        }
        
        func setParam(param: RequestParam?) -> Builder{
            self.param = param
            return self
        }
        
        @discardableResult
        func build() -> Request {
            return Request(build: self)
        }
        
    }
    
}
