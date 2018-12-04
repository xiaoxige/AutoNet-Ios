//
//  RealNetInterceptor.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/30.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 最后一个关卡, 进行网络访问的拦截器
 **/
final class RealNetInterceptor: BaseRealInterceptor {
    
    override func process(request: Request, method: AutoNetPattern, heads: Dictionary<AnyHashable, Any>?, finalUrl: URL, finalRequest: URLRequest, responseBack: @escaping AutoNetClosure.responseBack) {
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(self.writeOutTime)
        config.timeoutIntervalForResource = TimeInterval(self.readOutTime)
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = heads
        
        let session: URLSession = URLSession.init(configuration: config)
        session.dataTask(with: finalRequest) { (data, response, error) in
            if(self.headCallBack != nil){
                if(response is HTTPURLResponse){
                    let heads = (response as! HTTPURLResponse).allHeaderFields
                    self.headCallBack!(self.flag, Headers.Builder().addHeaders(headers: heads).build())
                }
            }
            if(error != nil){
                if(self.onError != nil){
                    self.onError!(error!)
                }
                return
            }
            let res = String.init(data: data!, encoding: .utf8)
            responseBack(res)
            }.resume()
    }
   
}
