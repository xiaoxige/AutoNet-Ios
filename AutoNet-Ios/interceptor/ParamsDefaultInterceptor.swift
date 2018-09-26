//
//  ParamsDefaultInterceptor.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/9/26.
//  Copyright © 2018年 Wwc. All rights reserved.
//

import Foundation

class ParamsDefaultInterceptor: Interceptor{
    
    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure<Any>.responseBack) {
        var request = chain.request()
        
        // 头部数据
        var headers = request.getHeaders()
        headers = headers?.newBuilder(isFollow: true)
            .addHeader(key: "token", value: "A")
            .addHeader(key: "userId", value: "0")
            .build()
        
        // 请求参数
        var params = request.getParams()
        params = params?.newBuilder(isFollow: true)
            .addParam(key: "createor", value: "Xiaoxige")
            .build()
        
        request = request.newBuilder(isFollow: true)
            .setHeaders(headers: headers)
            .setParams(params: params)
            .build()
        
        chain.proceed(request: request) { (response) in
            responseBack(response)
        }
    }
}
