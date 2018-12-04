//
//  RealInterceptorChain.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/22.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 用于构建拦截器
 **/
final class RealInterceptorChain: Chain{
    
    private var mRequest: Request
    private var mInterceptors: Array<Interceptor>
    private var mIndex: Int
    
    public init(request: Request, interceptors: Array<Interceptor>, index: Int){
        self.mRequest = request
        self.mInterceptors = interceptors
        self.mIndex = index
    }
    
    func request() -> Request {
        return self.mRequest
    }
    
    func proceed(request: Request, responseBack: @escaping AutoNetClosure.responseBack) {
        assert(mIndex < self.mInterceptors.count, "It.s a Interceptor's Error...")
        
        let next = RealInterceptorChain(request: request, interceptors: self.mInterceptors, index: self.mIndex + 1)
        self.mInterceptors[mIndex].intercept(chain: next) { (response) in
            responseBack(response)
        }
    }
    
}
