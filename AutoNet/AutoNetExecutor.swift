//
//  AutoNetExecutor.swift
//  AutoNet-Ios
//
//  Created by 小稀革 on 2018/11/25.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift
import RxCocoa

/**
 * AutoNet 真正的逻辑执行者
 **/
final class AutoNetExecutor<Response: HandyJSON, ExpectResponse> {
    
    /**
     * 插入操作
     **/
    private typealias opt = () -> Void
    /**
     * 是否传递错误信息
     **/
    private typealias transmitError = () -> Bool
   
    private var flag: Any?
    private var url: String
    private var mediaType: String
    private var params: Dictionary<String, Any>?
    private var heads: Dictionary<String, Any>?
    private var interceptors: Array<Interceptor>
    
    
    private var bodyCallBack: AutoNetClosure.body?
    private var handlerBefore: AutoNetConvertClosure<Response, ExpectResponse>.handlerBefore?
    private var optLocalData: AutoNetDataClosure<ExpectResponse>.optLocalData?
    private var onPregress: AutoNetFileClosure.onPregress?
    private var onComplete: AutoNetFileClosure.onComplete?
    private var onSuccess: AutoNetDataClosure<ExpectResponse>.onSuccess?
    private var onError: AutoNetDataClosure<Any>.onError?
    private var onEmpty: AutoNetDataClosure<Any>.onEmpty?
    
    var realInterceptor: BaseRealInterceptor?
    let autoNetQuqestType: AutoNetQuqeustTypeUtil
    let bag = DisposeBag()
    
    public init(flag: Any?, url: String, mediaType: String, params: Dictionary<String, Any>?, heads: Dictionary<String, Any>?, writeOutTime: Int, readOutTime: Int, outTime: Int, encryptionKey: Int, isEncryption: Bool, netPattern: AutoNetPattern, reqType: AutoNetType, resType: AutoNetType, isOpendefaultLog: Bool, interceptors: Array<Interceptor>, encryptionCallback: AutoNetClosure.encryption?, headCallBack: AutoNetClosure.head?, bodyCallBack: AutoNetClosure.body?, handlerBefore: AutoNetConvertClosure<Response, ExpectResponse>.handlerBefore?, optLocalData: AutoNetDataClosure<ExpectResponse>.optLocalData?, onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, onSuccess: AutoNetDataClosure<ExpectResponse>.onSuccess?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) {
        
        self.flag = flag
        self.url = url
        self.mediaType = mediaType
        self.params = params
        self.heads = heads
        self.interceptors = interceptors
        
        self.bodyCallBack = bodyCallBack
        self.handlerBefore = handlerBefore
        self.optLocalData = optLocalData
        self.onPregress = onPregress
        self.onComplete = onComplete
        self.onSuccess = onSuccess
        self.onError = onError
        self.onEmpty = onEmpty
        
        /**
         * 用来区分请求类型(x: 至此的逻辑未支持到， 当初设计原因， 以后重构完善)
         *  - net
         *  - local(x)
         *  - pullfile
         *  - pushfile
         **/
        autoNetQuqestType = AutoNetQuqeustTypeUtil(reqType: resType, resType: resType)
        self.automaticAdaptation(flag: flag, isOpendefaultLog: isOpendefaultLog, reqType: reqType, writeOutTime: writeOutTime, readOutTime: readOutTime, outTime: outTime, encryptionKey: encryptionKey, isEncryption: isEncryption, encryptionCallback: encryptionCallback, headCallBack: headCallBack, onPregress: onPregress, onComplete: onComplete, onError: onError)
    }
    
    private func automaticAdaptation(flag: Any?, isOpendefaultLog: Bool, reqType: AutoNetType, writeOutTime: Int, readOutTime: Int, outTime: Int, encryptionKey: Int, isEncryption: Bool, encryptionCallback: AutoNetClosure.encryption?, headCallBack: AutoNetClosure.head?, onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, onError: AutoNetDataClosure<Any>.onError?) -> Void{
        /**
         * 合并整理选择拦截器
         **/
        if(autoNetQuqestType.isNet()){
            realInterceptor = RealNetInterceptor(flag: flag, reqType: reqType, writeOutTime: writeOutTime, readOutTime: readOutTime, outTime: outTime, encryptionKey: encryptionKey, isEncryption: isEncryption, encryptionCallback: encryptionCallback, headCallBack: headCallBack, onPregress: onPregress, onComplete: onComplete, onError: onError)
        } else if(autoNetQuqestType.isPushFile()){
            realInterceptor = RealPushFileInterceptor(flag: flag, reqType: reqType, writeOutTime: writeOutTime, readOutTime: readOutTime, outTime: outTime, encryptionKey: encryptionKey, isEncryption: isEncryption, encryptionCallback: encryptionCallback, headCallBack: headCallBack, onPregress: onPregress, onComplete: onComplete, onError: onError)
        } else if(autoNetQuqestType.isPullFile()){
            realInterceptor = RealPullFileInterceptor(flag: flag, reqType: reqType, writeOutTime: writeOutTime, readOutTime: readOutTime, outTime: outTime, encryptionKey: encryptionKey, isEncryption: isEncryption, encryptionCallback: encryptionCallback, headCallBack: headCallBack, onPregress: onPregress, onComplete: onComplete, onError: onError)
        } else{
            // non , This is an impossible event.（At least for now）
        }
        self.interceptors = mergeInterceptors(isOpendefaultLog: isOpendefaultLog, interceptors: interceptors, realInterceptor: realInterceptor!)
    }
    
    public func pushFile(pushFileKey: String, filePath: String, netPattern: AutoNetPattern) -> Void{
        assert(false, "当前版本暂不支持, 敬请期待")
        self.pushNetFile(pushFileKey: pushFileKey, filePath: filePath, netPattern: netPattern)
    }
    
    public func pullFile(filePath: String, fileName: String, netPattern: AutoNetPattern) -> Void{
        assert(false, "当前版本暂不支持, 敬请期待")
        self.pullNetFile(filePath: filePath, fileName: fileName, netPattern: netPattern)
    }
    
    public func doNet(netPattern: AutoNetPattern) -> Void{
        self.doNet(netPattern: netPattern, transmitError: nil, opt: nil)
    }
    
    private func doNet(netPattern: AutoNetPattern,  transmitError: transmitError?, opt: opt?) -> Void{
        self.net(netPattern: netPattern, transmitError: (transmitError == nil ? { () -> Bool in
            return true
            } : transmitError!), opt: (opt == nil ? {
                } : opt!))
    }
    
    public func doLocal(netPattern: AutoNetPattern) -> Void{
        self.doLocal(netPattern: netPattern, transmitError: nil, opt: nil)
    }
    
    private func doLocal(netPattern: AutoNetPattern, transmitError: transmitError?, opt: opt?) -> Void{
        self.net(isLocal: true, netPattern: netPattern, transmitError: (transmitError == nil ? { () -> Bool in
                return true
            } : transmitError!), opt: (opt == nil ? {
                } : opt!))
    }
    
    public func doLocalNet(netPattern: AutoNetPattern) -> Void{
        self.doLocal(netPattern: netPattern, transmitError: { () -> Bool in
            return false
        }) {
            self.doNet(netPattern: netPattern)
        }
    }
    
    public func doNetLocal(netPattern: AutoNetPattern) -> Void{
        self.doNet(netPattern: netPattern, transmitError: { () -> Bool in
            return false
        }) {
            self.doLocal(netPattern: netPattern)
        }
    }
    
    private func pushNetFile(pushFileKey: String, filePath: String, netPattern: AutoNetPattern) -> Void{
        (self.realInterceptor as! RealPushFileInterceptor).initFile(pushFileKey: pushFileKey, filePath: filePath)
        self.net(isLocal: false, pushFileKey: pushFileKey, filePath: filePath, fileName: nil, netPattern: netPattern, transmitError: { () -> Bool in
            return true
        }) {
        }
    }

    private func pullNetFile(filePath: String, fileName: String, netPattern: AutoNetPattern) -> Void{
        (self.realInterceptor as! RealPullFileInterceptor).initFile(filePath: filePath, fileName: fileName)
        self.net(isLocal: false, pushFileKey: nil, filePath: filePath, fileName: fileName, netPattern: netPattern, transmitError: { () -> Bool in
            return true
        }) {
        }
    }
    
    private func net(isLocal: Bool = false, pushFileKey: String? = nil, filePath: String? = nil, fileName: String? = nil, netPattern: AutoNetPattern, transmitError: @escaping transmitError, opt: @escaping opt) -> Void{
        
        let observable = createObservable(isLocal: isLocal, pushFileKey: pushFileKey, filePath: filePath, fileName: fileName, netPattern: netPattern)

        observable.subscribe(onNext: { (response) in
            self.asSuccess(data: response)
            opt()
        }, onError: { (error) in
            if(transmitError()){
                switch error {
                case AutoNetError.EmptyError:
                    self.asEmpty()
                    break
                default:
                    self.asError(error: error)
                    break
                }
            }
            opt()
        }).disposed(by: self.bag)
    }
    
    public func createObservable(isLocal: Bool, pushFileKey: String? = nil, filePath: String? = nil, fileName: String? = nil, netPattern: AutoNetPattern) -> Observable<ExpectResponse>{
        
        if(isLocal){
            return self.handlerLocal()
        }
        return self.handlerNet(netPattern: netPattern)
    }
    
    private func mergeInterceptors(isOpendefaultLog: Bool, interceptors: Array<Interceptor>?, realInterceptor: Interceptor) -> Array<Interceptor>{
        var array = Array<Interceptor>()
        if(interceptors != nil){
            for interceptor in interceptors!{
                array.append(interceptor)
            }
        }
        if(isOpendefaultLog){
            array.append(DefaultLogInterceptor())
        }
        array.append(realInterceptor)
        return array
    }
    
    /**
     * 处理本地
     **/
    private func handlerLocal() ->Observable<ExpectResponse> {
        return Observable<ExpectResponse>.create { (emitter) -> Disposable in
            if(self.optLocalData == nil){
                emitter.onError(AutoNetError.EmptyError)
            } else {
                if(!self.optLocalData!(self.params, emitter)){
                    // 本地数据如果不自己处理的话， AutoNet会自动已空数据逻辑处理
                    emitter.onError(AutoNetError.EmptyError)
                }
            }
            emitter.onCompleted()
            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default)).observeOn(MainScheduler.init())
    }
    
    /**
     * 处理网络
     **/
    private func handlerNet(netPattern: AutoNetPattern) ->Observable<ExpectResponse>{
        return Observable<ExpectResponse>.create { (emitter) -> Disposable in
            let request: Request = Request.Builder()
                .setUrl(url: self.url)
                .setMethod(method: netPattern)
                .setParam(param: RequestParam.Builder().addParams(params: self.params).build())
                .setHeaders(header: Headers.Builder().addHeaders(headers: self.heads).build())
                .build()
            
            let chain: RealInterceptorChain = RealInterceptorChain(request: request, interceptors: self.interceptors, index: 0)
            chain.proceed(request: request, responseBack: { (response) in
                self.autoNetDataProcessing(response: response, emitter: emitter)
            })

            return Disposables.create()
        }.subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default)).observeOn(MainScheduler.init())
    }
    
    private func autoNetDataProcessing(response: String?, emitter: RxSwift.AnyObserver<ExpectResponse>) -> Void{
        // 返回体为空, 没有商量的余地, 空错误
        if(TextUtil.isEmpty(str: response)){
            emitter.onError(AutoNetError.EmptyError)
            emitter.onCompleted()
            return
        }
        // 回调body
        let simpleAny: AutoNetSimpleAny = AutoNetSimpleAny(emitter: emitter)
        if(self.bodyCallBack != nil){
            if(self.bodyCallBack!(self.flag, response!, simpleAny)){
                return
            }
        }
        
        let res: Response?
        // json 根据具体情况转实体类
        // 1. AutoNetDefaultResponse
        if(Response.self is AutoNetDefaultResponse.Type){
            res = AutoNetDefaultResponse() as? Response
            (res as! AutoNetDefaultResponse).setResponse(response: response)
        }else {
            // 2. 其他情况先转成指定的实体类
            res = JSONDeserializer<Response>.deserializeFrom(json: response, designatedPath: nil)
        }
        
        // 提前处理handlerBefore
        if(self.handlerBefore != nil){
            if(self.handlerBefore!(res!, emitter)){
                return
            }
        }
        
        // 走到这里，可以直接ExpectResponse 强转成Response, 如果出错， 可能没有复写handlerBefore方法
        assert(ExpectResponse.self is Response.Type, "返回数据不一致, 如果确定返回最终类型, 请复写handlerBefore")
        emitter.onNext(res! as! ExpectResponse)
        emitter.onCompleted()
    }
    
    private func asError(error: Error) -> Void{
        if(self.onError == nil){
            return
        }
        self.onError!(error)
    }
    
    private func asEmpty() -> Void{
        if(self.onEmpty == nil){
            return
        }
        self.onEmpty!()
    }
    
    private func asSuccess(data: ExpectResponse) -> Void{
        if(self.onSuccess == nil){
            return
        }
        self.onSuccess!(data)
    }
    
    private class AutoNetSimpleAny : AutoNetSimpleAnyObserver{

        private var emitter: RxSwift.AnyObserver<ExpectResponse>
        
        init(emitter: RxSwift.AnyObserver<ExpectResponse>) {
            self.emitter = emitter
        }
        
        func onNext(obc: Any) {
            if(obc is ExpectResponse){
                self.emitter.onNext(obc as! ExpectResponse)
            }
        }
        
        func onError(_ error: Error) {
            self.emitter.onError(error)
        }
        
        func onCompleted() {
            self.emitter.onCompleted()
        }
    }

}
