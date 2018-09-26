//
//  RealNetInterceptor.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/23.
//  Copyright © 2018年 Sir. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

final class RealNetInterceptor : Interceptor{
    
    private static var mMaster:SessionManager?;
    
    required init(urlSessionConfiguration:URLSessionConfiguration){
        RealNetInterceptor.mMaster = SessionManager.init(configuration: urlSessionConfiguration, delegate: SessionDelegate(), serverTrustPolicyManager: nil)
    }
    
    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure<Any>.responseBack) {
        let request: Request = chain.request();
        
        var httpHeaders: HTTPHeaders = [:]
        let headers = request.getHeaders()?.getHeaders()
        if(headers != nil){
            for key in headers!.keys{
                httpHeaders[key] = (headers?[key])
            }
        }
        
        var httpParams: Parameters = [:]
        let params = request.getParams()?.getParams()
        if(params != nil){
            for key in params!.keys{
                httpParams[key] = params?[key]
            }
        }
        
        RealNetInterceptor.mMaster?.request(request.getUrl(), method: request.getMethod(), parameters: httpParams, encoding: JSONEncoding.default, headers: httpHeaders)
            .response { (response) in
                responseBack(response)
        }
        
    }
}
