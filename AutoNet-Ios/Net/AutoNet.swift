//
//  AutoNet.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/22.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON

final class AutoNet{
    
    private static var sAutoNet: AutoNet?;
    private var mInitAutoNet: AutoNetInit?;
    
    private init(){
    }
    
    class func getInstance() -> AutoNet{
        if(sAutoNet == nil){
            sAutoNet = AutoNet()
        }
        return sAutoNet!
    }
    
    @discardableResult
    func initAutoNet(config: NetConfing) -> AutoNetInitDelegate {
        self.mInitAutoNet = AutoNetInit(config: config)
        return self.mInitAutoNet!
    }
    
    @discardableResult
    public func createNet() -> Net<AutoNetDefaultRespose, AutoNetDefaultRespose>{
        return createNet(AutoNetDefaultRespose(), AutoNetDefaultRespose())
    }
    
    @discardableResult
    public func createNet<T: HandyJSON>(_ t: T) -> Net<T, T>{
        return createNet(t, t)
    }
    
    @discardableResult
    public func createNet<T: HandyJSON, Z>(_ : T, _ : Z) -> Net<T, Z>{
        assert(mInitAutoNet != nil, "Please init AutoNet first!!!")
        return Net<T, Z>(initAutoNet: mInitAutoNet!)
    }
    
    final class AutoNetInit : AutoNetInitDelegate{

        var mConfig: NetConfing;
        var mBodyCallback: AutoNetClosure<Any>.bodyBack?;
        
        required init(config: NetConfing){
            self.mConfig = config
        }
    
        @discardableResult
        func setBodyCallback(bodyCallback: AutoNetClosure<Any>.bodyBack?) -> AutoNetInitDelegate {
            mBodyCallback = bodyCallback
            return self
        }
        
        func getNetConfig() -> NetConfing{
            return mConfig
        }
        
        func getBodyCallback() -> AutoNetClosure<Any>.bodyBack?{
            return mBodyCallback
        }
    }
    
    final class Net<T: HandyJSON, Z> : NetDelegate{
        
        typealias TType = Z
        typealias ZType = Net<T, Z>
        typealias ResponseType = T
        
        var mInitAutoNet: AutoNetInit
        var mBaseKey: String
        var mUrl: String?
        var mParams = Dictionary<String, Any>();
        var method: HTTPMethod = .get;
        
        var onHandlerBefore: AutoNetConvertClosure<T, Z>.handlerBefore?
        var onSuccess: AutoNetClosure<Z>.onSuccess?;
        var onError: AutoNetClosure<Z>.onError?;
        
        init(initAutoNet: AutoNetInitDelegate) {
            self.mInitAutoNet = initAutoNet as! AutoNet.AutoNetInit
            self.mBaseKey = "default"
        }
        
        func setBaseKey(baseKey: String) -> AutoNet.Net<T, Z> {
            self.mBaseKey = baseKey
            return self
        }
        
        func setUrl(url: String?) -> AutoNet.Net<T, Z> {
            self.mUrl = url
            return self
        }
        
        func doGet() -> AutoNet.Net<T, Z> {
            return self.doGet(params: nil, isApped: true)
        }
        
        func doGet(params: Dictionary<String, Any>?, isApped: Bool) -> AutoNet.Net<T, Z> {
            method = .get
            handlerParams(params: params, isApped: isApped)
            return self
        }
        
        func doPost() -> AutoNet.Net<T, Z> {
            return self.doPost(params: nil, isApped: true)
        }
        
        func doPost(params: Dictionary<String, Any>?, isApped: Bool) -> AutoNet.Net<T, Z> {
            method = .post
            handlerParams(params: params, isApped: isApped)
            return self
        }
        
        func addParam(key: String, value: Any) -> AutoNet.Net<T, Z> {
            self.mParams[key] = value
            return self
        }
        
        func addParams(params: Dictionary<String, Any>) -> AutoNet.Net<T, Z> {
            handlerParams(params: params, isApped: true)
            return self
        }
        
        func start() {
            self.start(onSuccess: nil, onError: nil)
        }
        
        func start(onSuccess: ((Z) -> Void)?) {
            self.start(onSuccess: onSuccess, onError: nil)
        }
        
//        func start(onError: AutoNetClosure<TType>.onError?) {
//            self.start(onSuccess: nil, onError: onError)
//        }
        
        func start(onSuccess: ((Z) -> Void)?, onError: AutoNetClosure<TType>.onError?) {
            start(handlerBefore: nil, onSuccess: onSuccess, onError: onError)
        }
        
        func start(handlerBefore: ((T, AutoNetClosure<Any>.onError?) -> Z?)?, onSuccess: ((Z) -> Void)?) {
            start(handlerBefore: handlerBefore, onSuccess: onSuccess, onError: nil)
        }
        
        func start(handlerBefore: AutoNetConvertClosure<T, Z>.handlerBefore?, onSuccess: ((Z) -> Void)?, onError: AutoNetClosure<TType>.onError?) {
            self.onHandlerBefore = handlerBefore
            self.onSuccess = onSuccess as AutoNetClosure<Z>.onSuccess?
            self.onError = onError
            realCallNet()
        }
        
        private func handlerParams(params: Dictionary<String, Any>? = nil, isApped: Bool) ->Void{
            if(!isApped){
                self.mParams.removeAll()
            }
            
            self.mParams = AutoNetUtil.mergeDictionary(first: self.mParams, second: params)
        }
        
        private func realCallNet() -> Void{
            let config: NetConfing = mInitAutoNet.getNetConfig()
            let baseUrls = config.getBaseUrls();
            let baseUrl = baseUrls[self.mBaseKey]
            assert(baseUrl != nil && !baseUrl!.isEmpty, "Are you sure set BaseUrl???")
            let resultUrl: String = baseUrl! + (self.mUrl ?? "")
            
            RealNet<T, Z>(url: resultUrl, params: self.mParams, method: self.method, urlSessionConfiguration: config.getUrlSessionConfiguration(), interceptors: config.getIntercepors(), onBadyCallback:mInitAutoNet.getBodyCallback(), handlerBefore: self.onHandlerBefore, onSuccess: self.onSuccess, onError: self.onError).start()
        }
        
    }
}

protocol AutoNetInitDelegate {
    @discardableResult
    func setBodyCallback(bodyCallback: AutoNetClosure<Any>.bodyBack?) -> AutoNetInitDelegate
}

protocol  NetDelegate {
    
    associatedtype TType
    
    associatedtype ZType
    
    associatedtype ResponseType
    
    @discardableResult
    func setBaseKey(baseKey: String) -> ZType
    
    @discardableResult
    func setUrl(url: String?) -> ZType
    
    @discardableResult
    func doGet() -> ZType
    
    @discardableResult
    func doGet(params: Dictionary<String, Any>?, isApped: Bool) -> ZType
    
    @discardableResult
    func doPost() -> ZType
    
    @discardableResult
    func doPost(params: Dictionary<String, Any>?, isApped: Bool) -> ZType
    
    @discardableResult
    func addParam(key: String, value: Any) -> ZType
    
    @discardableResult
    func addParams(params: Dictionary<String, Any>) -> ZType
    
    func start() ->Void
    
    func start(onSuccess: AutoNetClosure<TType>.onSuccess?) ->Void
    
//    func start(onError: AutoNetClosure<TType>.onError?) ->Void
    
    func start(onSuccess: AutoNetClosure<TType>.onSuccess?, onError: AutoNetClosure<TType>.onError?) -> Void
    
    func start(handlerBefore:AutoNetConvertClosure<ResponseType, TType>.handlerBefore?,onSuccess: AutoNetClosure<TType>.onSuccess?) ->Void

    func start(handlerBefore:AutoNetConvertClosure<ResponseType, TType>.handlerBefore?, onSuccess: AutoNetClosure<TType>.onSuccess?, onError: AutoNetClosure<TType>.onError?) -> Void
    
}
