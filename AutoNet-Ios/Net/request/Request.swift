//
//  Request.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/21.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import Alamofire

final class Request{
    
    private final var url: String
    private final var method: HTTPMethod
    private final var headers: Headers?
    private final var params: RequestParams?
    
    private init(){
        self.url = ""
        self.method = .get
    }
    
    private init(builder: Builder){
        self.url = builder.url
        self.method = builder.method
        self.headers = builder.headers
        self.params = builder.params
    }
    
    public func newBuilder(isFollow: Bool = true) -> Builder{
        let builder = Builder()
        if(isFollow){
            builder.setUrl(url: self.url)
            builder.setMethod(method: self.method)
            builder.setParams(params: self.params)
            builder.setHeaders(headers: self.headers)
        }
        return builder
    }
    
    public func getUrl() ->String{
        return self.url
    }
    
    public func getMethod() ->HTTPMethod{
        return self.method
    }
    
    public func getParams() ->RequestParams?{
        return self.params
    }
    
    public func getHeaders() -> Headers?{
        return self.headers
    }
    
    public final class Builder{
        
        final var url: String
        final var method: HTTPMethod
        final var headers: Headers?
        final var params: RequestParams?
        
        init() {
            self.url = ""
            self.method = .get
        }
        
        @discardableResult
        func setUrl(url: String) ->Builder{
            self.url = url
            return self
        }
        
        @discardableResult
        func setMethod(method: HTTPMethod) ->Builder{
            self.method = method
            return self
        }
        
        @discardableResult
        func setHeaders(headers: Headers?) -> Builder {
            self.headers = headers
            return self
        }
        
        @discardableResult
        func setParams(params: RequestParams?) -> Builder{
            self.params = params
            return self
        }
        
        @discardableResult
        func build() -> Request {
            return Request(builder: self)
        }
        
    }
    
}
