//
//  ParamsInterceptor.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/6.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

final class ParamsInterceptor: Interceptor{
    
    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure.responseBack) {
        
        var request = chain.request()
        
        let header = request.getHeader()
        // 构造新的头部数据
        let newHeader = header?.newBuilder(isFollow: true)
        .addHeader(key: "token", value: "a")
        .addHeader(key: "userId", value: "0")
        .build()
        
        let param = request.getParam()
        // 构造新的参数数据
        let newParam = param?.newBuilder(isFollow: true)
        .addParam(key: "params1", value: "value1")
        .addParam(key: "params2", value: "value2")
        .build()
        
        request = request.newBuilder()
            .setHeaders(header: newHeader)
            .setParam(param: newParam).build()
        
        chain.proceed(request: request) { (response) in
            responseBack(response)
        }
    }
    
    
}
