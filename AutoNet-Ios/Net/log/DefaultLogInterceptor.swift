//
//  DefaultLogInterceptor.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/24.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation

class DefaultLogInterceptor: Interceptor{
    
    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure<Any>.responseBack) {
        let request = chain.request()
        let params = request.getParams()?.getParams()
        let headers = request.getHeaders()?.getHeaders()
        print("-------------------------------------------------------")
        print("---------------------网络请求日志------------------------")
        print("-\t请求地址： \(request.getUrl())")
        print("-\t请求方式： \(request.getMethod())")
        print("-\t请求头部参数：")
        if(headers == nil || headers!.count <= 0){
            print("\t\t\t无")
        }else{
            for key in headers!.keys{
                print("\t\t\t\(key): \(String(describing: headers![key]))")
            }
        }
        print("-\t请求参数：")
        if(params == nil || params!.count <= 0){
            print("\t\t\t无")
        }else{
            for key in params!.keys{
                print("\t\t\t\(key): \(String(describing: params![key]))")
            }
        }
        
        let bgnTime = Date().timeIntervalSince1970
        chain.proceed(request: request) { (response) in
            print("-\t数据返回：")
            print("\t\t\t\(String(describing: response))")
            
            let endTime = Date().timeIntervalSince1970
            print("-------------耗时：\(endTime - bgnTime)ms----------------")
            print("-------------------------------------------------------")
            responseBack(response)
        }
    }
    
    
}
