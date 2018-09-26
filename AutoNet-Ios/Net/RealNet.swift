//
//  RealNet.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/22.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON

final class RealNet<T: HandyJSON, Z>{
    
    private var mUrl: String
    private var mParams: Dictionary<String, Any>?
    private var mMethod: HTTPMethod

    private var mUrlSessionConfiguration:URLSessionConfiguration?
    private var mInterceptors: Array<Interceptor>
    
    var onBadyCallback: AutoNetClosure<Any>.bodyBack?
    var onHandlerBefore: AutoNetConvertClosure<T, Z>.handlerBefore?
    var onSuccess: AutoNetClosure<Z>.onSuccess?
    var onError: AutoNetClosure<Z>.onError?
    
    required init(url: String, params: Dictionary<String, Any>?, method: HTTPMethod, urlSessionConfiguration: URLSessionConfiguration?, interceptors: Array<Interceptor>?, onBadyCallback: AutoNetClosure<Any>.bodyBack?, handlerBefore: AutoNetConvertClosure<T, Z>.handlerBefore?, onSuccess: AutoNetClosure<Z>.onSuccess?, onError: AutoNetClosure<Z>.onError?){
        self.mUrl = url
        self.mParams = params
        self.mMethod = method
        self.mUrlSessionConfiguration = urlSessionConfiguration
        self.onBadyCallback = onBadyCallback
        self.onHandlerBefore = handlerBefore
        self.onSuccess = onSuccess
        self.onError = onError
        
        self.mInterceptors = Array<Interceptor>()
        self.mInterceptors = mergeInterceptors(interceptors: interceptors)
    }
    
    func start() -> Void {
        
        // checkNetWork
        checkNet { (isHaveNet) in
            if(!isHaveNet){
                self.onError!(AutoNetError.NetError(message: nil))
            }
        }
        
        let request = Request
            .Builder()
            .setUrl(url: self.mUrl)
            .setMethod(method: self.mMethod)
            .setHeaders(headers: Headers
                .Builder()
                .build())
            .setParams(params: RequestParams
                .Builder()
                .addParams(params: self.mParams)
                .build())
        .build()
        
        let chain = RealInterceptorChain(request: request, interceptors: self.mInterceptors, index: 0)
        chain.proceed(request: request) { (response) in
            // 最后处理结果
            if(self.onBadyCallback == nil || !self.onBadyCallback!(response, self.onError)){
                // Body不拦截，默认处理(可通过转换器进行转换，以后会抛出用户自定义的转换器，像拦截器一样，但暂时不处理，以后迭代)
                do{
                    let convert = DefaultJsonConver<T>()
                    let t:T = try convert.convert(response: response!)
                    self.callbackSuccess(response: t)
                }catch {
                    self.callbackError(error: error)
                }

            }
        }
    }
    
    private func callbackSuccess(response: T) ->Void{
        if(self.onSuccess != nil){
            if(self.onHandlerBefore == nil || T.self is Z.Type){
                self.onSuccess!(response as! Z)
                return
            }
            assert(self.onHandlerBefore != nil, "Please check your appoint switch type or add handlerBefore!!!")
            
            let z: Z? = self.onHandlerBefore!(response, self.onError)
            if(z != nil){
                self.onSuccess!(z!)
            }else{
                self.callbackError(error: AutoNetError.EmptyError)
            }
        }
    }
    
    private func callbackError(error: Error) -> Void{
        if(self.onError != nil){
            self.onError!(error)
        }
    }
    
    private func mergeInterceptors(interceptors: Array<Interceptor>?) -> Array<Interceptor>{

        var array = Array<Interceptor>()
        
        if(interceptors != nil){
            for interceptor in interceptors!{
                array.append(interceptor)
            }
        }
        array.append(RealNetInterceptor(urlSessionConfiguration: self.mUrlSessionConfiguration!))
        
        return array
    }
    
    func checkNet(callback: @escaping (Bool) -> Void) -> Void{
        let manager = NetworkReachabilityManager.init();
        manager?.listener = {  status in
            if(status == .notReachable){
                callback(false)
            }else{
                callback(true)
            }
        }
        manager?.startListening();
    }
    
}
