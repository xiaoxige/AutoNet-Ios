//
//  TestInterceptor.swift
//  Star_Pppig
//
//  Created by pppig on 2018/9/24.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation

class TestInterceptor: Interceptor{
    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure<Any>.responseBack) {
        print("测试拦截器...")
        chain.proceed(request: chain.request()) { (resoinse) in
            responseBack(resoinse)
        }
    }
}
