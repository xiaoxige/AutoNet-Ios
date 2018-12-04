//
//  DefaultLogInterceptor.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/3.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

class DefaultLogInterceptor: Interceptor{
    
    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure.responseBack) {
        let request = chain.request()
        let url = request.getUrl()
        let method = request.getMethod()
        let params = request.getParam()?.getParams()
        let headers = request.getHeader()?.getHeaders()
        print("-------------------------------------------------------")
        print("---------------------网络请求日志------------------------")
        print("-\t请求地址： \(url)")
        print("-\t请求方式： \(method)")
        print("-\t请求头部参数：")
        if(headers == nil || headers!.count <= 0){
            print("\t\t\t无")
        }else{
            for key in headers!.keys{
                print("\t\t\t\(key): \(headers![key] ?? "")")
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
            print("\t\t\t\(response ?? "空")")

            let endTime = Date().timeIntervalSince1970
            print("-------------耗时：\(endTime - bgnTime)ms----------------")
            print("-------------------------------------------------------")
            responseBack(response)
        }
    }
}
