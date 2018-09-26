//
//  DefaultDataResponse.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/23.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import Alamofire

final class RealInterceptorChain: Chain{

    private let mRequest: Request
    private let mInterceptors: Array<Interceptor>
    private let mIndex: Int
    
    init(request: Request, interceptors: Array<Interceptor>, index: Int){
        self.mRequest = request
        self.mInterceptors = interceptors
        self.mIndex = index
    }
    
    func request() -> Request {
        return mRequest;
    }
    
    func proceed(request: Request, responseBack: @escaping (DefaultDataResponse?) -> Void) {
        assert(mIndex < self.mInterceptors.count, "It.s a Interceptor's Error...")
        
        let next = RealInterceptorChain(request: request, interceptors: self.mInterceptors, index: self.mIndex + 1)
        self.mInterceptors[mIndex].intercept(chain: next) { (response) in
            responseBack(response)
        }
    }
}
