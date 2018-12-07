//
//  AutoNet.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift
import RxCocoa

/**
 * AutoNet
 **/
public final class AutoNet{
    
    private static var sAutoNet: AutoNet?
    private static var sConfig: AutoNetConfig?
    private static var sAutoNetExtraConfig: AutoNetExtraConfigDelegate?
    
    private init(){
    }
    
    public class func getInstance() -> AutoNet{
        if(AutoNet.sAutoNet == nil){
            AutoNet.sAutoNet = AutoNet()
        }
        return AutoNet.sAutoNet!
    }
    
    @discardableResult
    public func initAutoNet(config: AutoNetConfig) ->AutoNetExtraConfigDelegate{
        AutoNet.sConfig = config
        AutoNet.sAutoNetExtraConfig = AutoNetExtraConfig()
        return AutoNet.sAutoNetExtraConfig!
    }
    
    public class func updateOrInsertHead(key: String, value: Any) ->AutoNetExtraConfigDelegate{
        assert(AutoNet.sAutoNetExtraConfig != nil, "请确定是否初始化AutoNet")
        AutoNet.sAutoNetExtraConfig?.updateOrInsertHead(key: key, value: value)
        return AutoNet.sAutoNetExtraConfig!
    }
    
    public class func removeHead(key: String) ->AutoNetExtraConfigDelegate{
        assert(AutoNet.sAutoNetExtraConfig != nil, "请确定是否初始化AutoNet")
        AutoNet.sAutoNetExtraConfig?.removeHead(key: key)
        return AutoNet.sAutoNetExtraConfig!
    }
    
    public class func updateOrInsertDomainNames(key: String, value: String) -> AutoNetExtraConfigDelegate{
        assert(AutoNet.sAutoNetExtraConfig != nil, "请确定是否初始化AutoNet")
        AutoNet.sAutoNetExtraConfig?.updateOrInsertDomainNames(key: key, value: value)
        return AutoNet.sAutoNetExtraConfig!
    }
    
    public class func removeDomainName(key: String) -> AutoNetExtraConfigDelegate{
        assert(AutoNet.sAutoNetExtraConfig != nil, "请确定是否初始化AutoNet")
        AutoNet.sAutoNetExtraConfig?.removeDomainName(key: key)
        return AutoNet.sAutoNetExtraConfig!
    }
    
    public class func setExtraHeads(extraHeads: Dictionary<String, Any>) -> AutoNetExtraConfigDelegate{
        assert(AutoNet.sAutoNetExtraConfig != nil, "请确定是否初始化AutoNet")
        AutoNet.sAutoNetExtraConfig?.setExtraHeads(extraHeads: extraHeads)
        return AutoNet.sAutoNetExtraConfig!
    }
    
    public class func setExtraDomainNames(extraDomainNames: Dictionary<String, String>) -> AutoNetExtraConfigDelegate{
        assert(AutoNet.sAutoNetExtraConfig != nil, "请确定是否初始化AutoNet")
        AutoNet.sAutoNetExtraConfig?.setExtraDomainNames(extraDomainNames: extraDomainNames)
        return AutoNet.sAutoNetExtraConfig!
    }
    
    public func createNet() -> Net<AutoNetDefaultResponse, AutoNetDefaultResponse>{
        return createNet(AutoNetDefaultResponse(), AutoNetDefaultResponse())
    }
    
    public func createNet<Response: HandyJSON>(_ response:Response) -> Net<Response, Response>{
        return createNet(response, response)
    }
    
    public func createNet<Response: HandyJSON, ExpectResponse>(_ :Response, _ :ExpectResponse) -> Net<Response, ExpectResponse>{
        return Net<Response, ExpectResponse>()
    }
    
    public final class AutoNetExtraConfig : AutoNetExtraConfigDelegate{
        
        private var mExtraHeads: Dictionary<String, Any>
        private var mExtraDomainNames: Dictionary<String, String>
        private var mEncryptionCallback: AutoNetClosure.encryption?
        private var mHeadCallBack: AutoNetClosure.head?
        private var mBodyCallBack: AutoNetClosure.body?
        
        init(){
            mExtraHeads = Dictionary<String, Any>()
            mExtraDomainNames = Dictionary<String, String>()
        }
        
        public func setExtraHeads(extraHeads: Dictionary<String, Any>) -> AutoNetExtraConfigDelegate {
            self.mExtraHeads = AutoNetUtil.mergeDictionary(first: self.mExtraHeads, second: extraHeads)
            return self
        }
        
        public func setExtraDomainNames(extraDomainNames: Dictionary<String, String>) -> AutoNetExtraConfigDelegate {
            self.mExtraDomainNames = AutoNetUtil.mergeDictionary(first: self.mExtraDomainNames, second: extraDomainNames) as! Dictionary<String, String>
            return self
        }
        
        public func updateOrInsertHead(key: String, value: Any) -> AutoNetExtraConfigDelegate {
            self.mExtraHeads[key] = value
            return self
        }
        
        public func removeHead(key: String) -> AutoNetExtraConfigDelegate {
            self.mExtraHeads.removeValue(forKey: key)
            return self
        }
        
        public func updateOrInsertDomainNames(key: String, value: String) -> AutoNetExtraConfigDelegate {
            self.mExtraDomainNames[key] = value
            return self
        }
        
        public func removeDomainName(key: String) -> AutoNetExtraConfigDelegate {
            self.mExtraDomainNames.removeValue(forKey: key)
            return self
        }
        
        public func setEncryptionCallback(encryptionCallback: @escaping (Int, String?) -> String) -> AutoNetExtraConfigDelegate {
            self.mEncryptionCallback = encryptionCallback
            return self
        }
        
        public func setHeadsCallback(headsCallback: @escaping (Any?, Headers) -> Void) -> AutoNetExtraConfigDelegate {
            self.mHeadCallBack = headsCallback
            return self
        }
        
        public func setBodyCallback(bodyCallback: @escaping AutoNetClosure.body)-> AutoNetExtraConfigDelegate {
            self.mBodyCallBack = bodyCallback
            return self
        }
        
        func getExtraHeads() -> Dictionary<String, Any>{
            return self.mExtraHeads
        }
        
        func getExtraDomainNames() -> Dictionary<String, String>{
            return self.mExtraDomainNames
        }
        
        func getEncryptionCallback() -> AutoNetClosure.encryption?{
            return self.mEncryptionCallback
        }
        
        func getHeadCallBack() -> AutoNetClosure.head? {
            return self.mHeadCallBack
        }
        
        func getBodyCallBack() -> AutoNetClosure.body?{
            return self.mBodyCallBack
        }
        
    }
    
    public final class Net<Response: HandyJSON, ExpectResponse> : NetDelegate{
        
        public typealias ResponseType = Response
        public typealias ExpectResponseType = ExpectResponse
        public typealias ReturnSelfType = Net<Response, ExpectResponse>
        
        private var flag: Any?
        private var extraDynamicParam: String?
        private var domainNameKey: String
        private var baseUrl: String?
        private var suffixUrl: String?
        private var mediaType: String?
        private var writeOutTime: Int
        private var readOutTime: Int
        private var outTime: Int
        private var encryptionKey: Int
        private var isEncryption: Bool
        private var heads: Dictionary<String, Any>?
        private var netPattern: AutoNetPattern
        private var reqType: AutoNetType
        private var resType: AutoNetType
        private var netStrategy: AutoNetStrategy
        private var pushFileKey: String?
        private var filePath: String?
        private var fileName: String?
        private var params: Dictionary<String, Any>
        private var handlerBefore: AutoNetConvertClosure<ResponseType, ExpectResponseType>.handlerBefore?
        private var optLocalData: AutoNetDataClosure<ExpectResponseType>.optLocalData?
        private var onPregress: AutoNetFileClosure.onPregress?
        private var onComplete: AutoNetFileClosure.onComplete?
        private var onSuccess: AutoNetDataClosure<ExpectResponseType>.onSuccess?
        private var onError: AutoNetDataClosure<Any>.onError?
        private var onEmpty: AutoNetDataClosure<Any>.onEmpty?
        
        init() {
            self.domainNameKey = "default"
            self.writeOutTime = 5000
            self.readOutTime = 5000
            self.outTime = 5000
            self.encryptionKey = -1
            self.isEncryption = false
            self.netPattern = .get
            self.reqType = .JSON
            self.resType = .JSON
            self.netStrategy = .NET
            self.params = Dictionary<String, Any>()
        }
        
        public func setFlag(flag: Any) -> AutoNet.Net<Response, ExpectResponse> {
            self.flag = flag
            return self
        }
        
        public func setExtraDynamicParam(extraDynamicParam: String) -> AutoNet.Net<Response, ExpectResponse> {
            self.extraDynamicParam = extraDynamicParam
            return self
        }
        
        public func setDomainNameKey(domainNameKey: String) -> AutoNet.Net<Response, ExpectResponse> {
            self.domainNameKey = domainNameKey
            return self
        }
        
        public func setBaseUrl(baseUrl: String) -> AutoNet.Net<Response, ExpectResponse> {
            self.baseUrl = baseUrl
            return self
        }
        
        public func setSuffixUrl(suffixUrl: String) -> AutoNet.Net<Response, ExpectResponse> {
            self.suffixUrl = suffixUrl
            return self
        }
        
        public func setMediaType(mediaType: String) -> AutoNet.Net<Response, ExpectResponse> {
            self.mediaType = mediaType
            return self
        }
        
        public func setWriteOutTime(writeOutTime: Int) -> AutoNet.Net<Response, ExpectResponse> {
            self.writeOutTime = writeOutTime
            return self
        }
        
        public func setReadOutTime(readOutTime: Int) -> AutoNet.Net<Response, ExpectResponse> {
            self.readOutTime = readOutTime
            return self
        }
        
        public func setConnectOutTime(outTime: Int) -> AutoNet.Net<Response, ExpectResponse> {
            self.outTime = outTime
            return self
        }
        
        public func setEncryptionKey(encryptionKey: Int) -> AutoNet.Net<Response, ExpectResponse> {
            self.encryptionKey = encryptionKey
            return self
        }
        
        public func isEncryption(isEncryption: Bool) -> AutoNet.Net<Response, ExpectResponse> {
            self.isEncryption = isEncryption
            return self
        }
        
        public func setHeads(heads: Dictionary<String, Any>) -> AutoNet.Net<Response, ExpectResponse> {
            self.heads = heads
            return self
        }
        
        public func setNetPattern(netPattern: AutoNetPattern) -> AutoNet.Net<Response, ExpectResponse> {
            self.netPattern = netPattern
            return self
        }
        
        public func setReqType(reqType: AutoNetType) -> AutoNet.Net<Response, ExpectResponse> {
            self.reqType = reqType
            return self
        }
        
        public func setResType(resType: AutoNetType) -> AutoNet.Net<Response, ExpectResponse> {
            self.resType = resType
            return self
        }
        
        public func setNetStrategy(netStrategy: AutoNetStrategy) -> AutoNet.Net<Response, ExpectResponse> {
            self.netStrategy = netStrategy
            return self
        }
        
        public func setPushFileParams(pushFileKey: String, filePath: String) -> AutoNet.Net<Response, ExpectResponse> {
            self.pushFileKey = pushFileKey
            self.filePath = filePath
            return self
        }
        
        public func setPullFileParams(filePath: String, fileName: String) -> AutoNet.Net<Response, ExpectResponse> {
            self.filePath = filePath
            self.fileName = fileName
            return self
        }
        
        public func doGet() -> AutoNet.Net<Response, ExpectResponse> {
            self.netPattern = .get
            return self
        }
        
        public func doPost() -> AutoNet.Net<Response, ExpectResponse> {
            self.netPattern = .post
            return self
        }
        
        public func doDelete() -> AutoNet.Net<Response, ExpectResponse> {
            self.netPattern = .delete
            return self
        }
        
        public func doPut() -> AutoNet.Net<Response, ExpectResponse> {
            self.netPattern = .put
            return self
        }
        
        public func setParam(key: String, value: Any) -> AutoNet.Net<Response, ExpectResponse> {
            self.params[key] = value
            return self
        }
        
        public func setParams(params: Dictionary<String, Any>) -> AutoNet.Net<Response, ExpectResponse> {
            self.params = AutoNetUtil.mergeDictionary(first: self.params, second: params)
            return self
        }
        
        public func setHandlerBefore(handlerBefore: ((Response, AnyObserver<ExpectResponse>) -> Bool)?) -> AutoNet.Net<Response, ExpectResponse> {
            self.handlerBefore = handlerBefore
            return self
        }
        
        public func getObservable() -> Observable<ExpectResponse> {
            return self.createObservable()!
        }
        
        public func start(optLocalData: ((Dictionary<String, Any>?, AnyObserver<ExpectResponse>) -> Bool)?, onSuccess: ((ExpectResponse) -> Void)?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) {
            self.start(handlerBefore: nil, optLocalData: optLocalData, onPregress: nil, onComplete: nil, onSuccess: onSuccess, onError: onError, onEmpty: onEmpty)
        }
        
        public func start(handlerBefore: ((Response, AnyObserver<ExpectResponse>) -> Bool)?, onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, onSuccess: ((ExpectResponse) -> Void)?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) {
            self.start(handlerBefore: handlerBefore, optLocalData: nil, onPregress: onPregress, onComplete: onComplete, onSuccess: onSuccess, onError: onError, onEmpty: onEmpty)
        }
        
        public func start(onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, onSuccess: ((ExpectResponse) -> Void)?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) {
            self.start(handlerBefore: nil, optLocalData: nil, onPregress: onPregress, onComplete: onComplete, onSuccess: onSuccess
                , onError: onError, onEmpty: onEmpty)
        }
        
        public func start(handlerBefore: ((Response, AnyObserver<ExpectResponse>) -> Bool)?, onSuccess: ((ExpectResponse) -> Void)?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) {
            self.start(handlerBefore: handlerBefore, optLocalData: nil, onPregress: nil, onComplete: nil, onSuccess: onSuccess, onError: onError, onEmpty: onEmpty)
        }
        
        public func start(handlerBefore: AutoNetConvertClosure<Response, ExpectResponse>.handlerBefore? = nil, optLocalData: AutoNetDataClosure<ExpectResponseType>.optLocalData? = nil, onPregress: AutoNetFileClosure.onPregress? = nil, onComplete: AutoNetFileClosure.onComplete? = nil, onSuccess: ((ExpectResponse) -> Void)? = nil, onError: AutoNetDataClosure<Any>.onError? = nil, onEmpty: AutoNetDataClosure<Any>.onEmpty? = nil) {
                self.optLocalData = optLocalData
                self.handlerBefore = handlerBefore
                self.onPregress = onPregress
                self.onComplete = onComplete
                self.onSuccess = onSuccess
                self.onError = onError
                self.onEmpty = onEmpty
                self.realNet()
        }
        
        private func realNet() -> Void{
            assert(AutoNet.sConfig != nil && AutoNet.sAutoNetExtraConfig != nil, "AutoNet 未初始化...")
            if(!checkLegitimate(netPattern: self.netPattern, reqType: self.reqType, resType: self.resType, pushFileKey: self.pushFileKey, filePath: self.filePath, fileName: self.fileName)){
                return
            }
            
            let executor = getAutoNetExecutor()
            
            if(isPushFileOperation(reqType: self.reqType)){
                executor.pushFile(pushFileKey: self.pushFileKey!, filePath: self.filePath!, netPattern: self.netPattern)
            } else if(isPullFileOperation(resType: self.resType)){
                executor.pullFile(filePath: self.filePath!, fileName: self.fileName!, netPattern: self.netPattern)
            } else{
                if(AutoNetStrategy.NET == self.netStrategy){
                    executor.doNet(netPattern: self.netPattern)
                } else if(AutoNetStrategy.LOCAL == self.netStrategy){
                    executor.doLocal(netPattern: self.netPattern)
                } else if(AutoNetStrategy.LOCAL_NET == self.netStrategy){
                    executor.doLocalNet(netPattern: self.netPattern)
                } else if(AutoNetStrategy.NET_LOCAL == self.netStrategy){
                    executor.doNetLocal(netPattern: self.netPattern)
                } else {
                    assert(false, "网络请求策略未定义")
                }
            }
        }
        
        private func createObservable() -> Observable<ExpectResponse>?{
            assert(AutoNet.sConfig != nil && AutoNet.sAutoNetExtraConfig != nil, "AutoNet 未初始化...")
            if(!checkLegitimate(netPattern: self.netPattern, reqType: self.reqType, resType: self.resType, pushFileKey: self.pushFileKey, filePath: self.filePath, fileName: self.fileName)){
                return nil
            }
            if(!self.checkLegitimateByObservableWay(netPattern: netPattern, reqType: reqType, resType: resType, netStrategy: netStrategy)){
                return nil
            }
            
            let executor = getAutoNetExecutor()
            return executor.createObservable(isLocal: (AutoNetStrategy.LOCAL == self.netStrategy), netPattern: self.netPattern)
        }
        
        private func getAutoNetExecutor() ->AutoNetExecutor<Response, ExpectResponse>{
            
            let heads: Dictionary<String, Any> = integrationHeads(headParam: AutoNet.sConfig!.getHeadParam(), extraHeads: (AutoNet.sAutoNetExtraConfig as! AutoNetExtraConfig).getExtraHeads(), disposableHeads: self.heads)
            let url = getUrlByRequest(domainNameKey: self.domainNameKey, baseUrl: self.baseUrl, extraDynamicParam: self.extraDynamicParam, suffixUrl: self.suffixUrl,  domainNames: AutoNet.sConfig?.getDomainNames(), extraDomainNames: (AutoNet.sAutoNetExtraConfig as! AutoNetExtraConfig).getExtraDomainNames())
            self.mediaType = autoAdjustmentAdjustmentMediaType(mediaType: self.mediaType, reqType: reqType)
            
            let executor = AutoNetExecutor<Response, ExpectResponse>(flag: self.flag, url: url, mediaType: self.mediaType!, params: self.params, heads: heads, writeOutTime: self.writeOutTime, readOutTime: self.readOutTime, outTime: self.outTime, encryptionKey: self.encryptionKey, isEncryption: self.isEncryption, netPattern: self.netPattern, reqType: self.reqType, resType: self.resType,
                                                                     isOpendefaultLog: AutoNet.sConfig?.isOpendefaultLog() ?? false, 
                                                                     interceptors: AutoNet.sConfig!.getInterceptors(),
                                                                     encryptionCallback: (AutoNet.sAutoNetExtraConfig as! AutoNetExtraConfig).getEncryptionCallback(),
                                                                     headCallBack: (AutoNet.sAutoNetExtraConfig as! AutoNetExtraConfig).getHeadCallBack(),
                                                                     bodyCallBack: (AutoNet.sAutoNetExtraConfig as! AutoNetExtraConfig).getBodyCallBack(),
                                                                     handlerBefore: self.handlerBefore, optLocalData: self.optLocalData, onPregress: self.onPregress, onComplete: self.onComplete, onSuccess: self.onSuccess, onError: self.onError, onEmpty: self.onEmpty)
            return executor
        }
        
        private func checkLegitimate(netPattern: AutoNetPattern, reqType: AutoNetType, resType: AutoNetType,
                                     pushFileKey: String?, filePath: String?, fileName: String?) -> Bool{
            assert(reqType != AutoNetType.OTHER_TYPE && resType != AutoNetType.OTHER_TYPE, "AutoNet 暂不支持请求数据格式")
            if(isFileOperation(reqType: reqType, resType: resType)){
                if(self.isPushFileOperation(reqType: reqType)){
                    self.checkPushFileOperationLegitimate(netPattern: netPattern, reqType: reqType, pushFileKey: pushFileKey, filePath: filePath)
                } else if(self.isPullFileOperation(resType: resType)){
                    self.checkPullFileOperationLegitimate(resType: resType, filePath: filePath, fileName: fileName)
                }
            }
            return true
        }
        
        
        private func checkLegitimateByObservableWay(netPattern: AutoNetPattern, reqType: AutoNetType,
                                                    resType: AutoNetType, netStrategy: AutoNetStrategy) -> Bool{
            assert(((AutoNetType.OTHER_TYPE != reqType) && (AutoNetType.OTHER_TYPE != resType)), "AutoNet 上游模式暂不支持该数据请求格式")
            assert(((AutoNetStrategy.LOCAL_NET != netStrategy) && (AutoNetStrategy.NET_LOCAL != netStrategy)), "AutoNet 上游模式暂不支持该请求策略")
            assert((!(AutoNetType.STREAM == reqType || AutoNetType.STREAM == resType)), "AutoNet 上游模式暂不支持流模式")
            return true
        }
        
        private func isFileOperation(reqType: AutoNetType, resType: AutoNetType) -> Bool{
            return AutoNetType.STREAM == reqType || AutoNetType.STREAM == resType
        }
        
        private func isPushFileOperation(reqType: AutoNetType) -> Bool{
            return AutoNetType.STREAM == reqType
        }
        
        private func isPullFileOperation(resType: AutoNetType) -> Bool{
            return AutoNetType.STREAM == resType
        }
        
        @discardableResult
        private func checkPushFileOperationLegitimate(netPattern: AutoNetPattern, reqType: AutoNetType,
                                                      pushFileKey: String?, filePath: String?) -> Bool{
            assert(AutoNetType.STREAM == reqType, "上传文件不符合请求数据类型， 你可以尝试下 reqType = AutoNetType.STREAM")
            assert(((!TextUtil.isEmpty(str: pushFileKey)) && (!TextUtil.isEmpty(str: filePath))), "上传文件， pushFileKey And filePath 不能为空")
            assert(((AutoNetPattern.get != netPattern) && (AutoNetPattern.delete != netPattern)), "上传文件不支持 get 和 delete 请求")
            assert(FileManager.default.fileExists(atPath: filePath!), "上传文件不存在")
            return true
        }
        
        @discardableResult
        private func checkPullFileOperationLegitimate(resType: AutoNetType, filePath: String?, fileName: String?) -> Bool{
            assert(AutoNetType.STREAM == resType, "下载文件不符合请求数据类型， 你可以尝试下 resType = AutoNetType.STREAM")
            assert(((!TextUtil.isEmpty(str: filePath) && !TextUtil.isEmpty(str: fileName))), "下载文件， filePath And filePath 不能为空")
            return true
        }
        
        private func integrationHeads(headParam: Dictionary<String, Any>?, extraHeads: Dictionary<String, Any>?, disposableHeads: Dictionary<String, Any>?) -> Dictionary<String, Any>{
            var heads: Dictionary<String, Any> = Dictionary<String, Any>()
            heads = AutoNetUtil.mergeDictionary(first: heads, second: headParam)
            heads = AutoNetUtil.mergeDictionary(first: heads, second: extraHeads)
            heads = AutoNetUtil.mergeDictionary(first: heads, second: disposableHeads)
            return heads
        }
        
        private func getUrlByRequest(domainNameKey: String, baseUrl: String?, extraDynamicParam: String?,
                                     suffixUrl: String?, domainNames: Dictionary<String, String>?, extraDomainNames: Dictionary<String, String>?) -> String{
            if(!TextUtil.isEmpty(str: baseUrl)){
                return baseUrl!
            }
            
            var url: String?
            if(!TextUtil.isEmpty(dic: extraDomainNames)){
                url = extraDomainNames![domainNameKey] ?? ""
            }
            
            if(TextUtil.isEmpty(str: url) && !TextUtil.isEmpty(dic: domainNames)){
                url = domainNames![domainNameKey] ?? ""
            }
            
            assert(!TextUtil.isEmpty(str: url), "AutoNet 未发现合法域名")
            
            if(!TextUtil.isEmpty(str: suffixUrl)){
                url = AutoNetUrlUtil.autoSplicingUrlWithSlashSeparator(basicUrl: url!, needSplicingStr: suffixUrl)
            }
            
            if(!TextUtil.isEmpty(str: extraDynamicParam)){
                url = AutoNetUrlUtil.autoSplicingUrlWithSlashSeparator(basicUrl: url!, needSplicingStr: extraDynamicParam)
            }
            
            return url!
        }
        
        private func autoAdjustmentAdjustmentMediaType(mediaType: String?, reqType: AutoNetType) -> String{
            if(!TextUtil.isEmpty(str: mediaType)){
                return mediaType!
            }
            var autoMedisType: String = "application/json; charset=utf-8"
            if(AutoNetType.STREAM == reqType){
                autoMedisType = "application/octet-stream;charset=UTF-8"
            } else if(AutoNetType.FORM == reqType){
                autoMedisType = "application/x-www-form-urlencoded;charset=UTF-8"
            }
            
            return autoMedisType
        }
    }
}

/**
 * AutoNet的额外配置协议
 **/
public protocol  AutoNetExtraConfigDelegate {
    
    /**
     * 设置额外的头部
     **/
    @discardableResult
    func setExtraHeads(extraHeads: Dictionary<String, Any>) -> AutoNetExtraConfigDelegate
    
    /**
     * 设置额外的域名数据
     **/
    @discardableResult
    func setExtraDomainNames(extraDomainNames: Dictionary<String, String>) -> AutoNetExtraConfigDelegate
    
    /**
     * 更新或者新增额外头部数据
     **/
    @discardableResult
    func updateOrInsertHead(key: String, value: Any) -> AutoNetExtraConfigDelegate
    
    /**
     * 移除额外头部数据
     **/
    @discardableResult
    func removeHead(key: String) -> AutoNetExtraConfigDelegate
    
    /**
     * 更新或者新增额外域名数据
     **/
    @discardableResult
    func updateOrInsertDomainNames(key: String, value: String) -> AutoNetExtraConfigDelegate
    
    /**
     * 移除额外域名数据
     **/
    @discardableResult
    func removeDomainName(key: String) -> AutoNetExtraConfigDelegate
    
    /**
     * 设置对参数数据加密回调
     **/
    @discardableResult
    func setEncryptionCallback(encryptionCallback: @escaping AutoNetClosure.encryption) -> AutoNetExtraConfigDelegate
    
    /**
     * 设置网络头部回调
     **/
    @discardableResult
    func setHeadsCallback(headsCallback: @escaping AutoNetClosure.head) -> AutoNetExtraConfigDelegate
    
    /**
     * 设置网络返回数据回调
     **/
    @discardableResult
    func setBodyCallback(bodyCallback: @escaping AutoNetClosure.body) -> AutoNetExtraConfigDelegate
}

/**
 * 网络请求基础协议
 **/
public protocol NetDelegate {
    
    associatedtype ResponseType
    
    associatedtype ExpectResponseType
    
    associatedtype ReturnSelfType
    
    /**
     * 添加flag追踪
     **/
    @discardableResult
    func setFlag(flag: Any) -> ReturnSelfType
    
    /**
     * 添加额外参数（eg: https:xxxx.com/id=1, 中变化的id）
     **/
    @discardableResult
    func setExtraDynamicParam(extraDynamicParam: String) -> ReturnSelfType
    
    /**
     * 指定使用哪一个域名
     **/
    @discardableResult
    func setDomainNameKey(domainNameKey: String) -> ReturnSelfType
    
    /**
     * 设置域名（局域）
     **/
    @discardableResult
    func setBaseUrl(baseUrl: String) -> ReturnSelfType
    
    /**
     * 设置请求地址后缀（除去域名的主体部分）
     **/
    @discardableResult
    func setSuffixUrl(suffixUrl: String) -> ReturnSelfType
    
    /**
     * 设置mediaType
     **/
    @discardableResult
    func setMediaType(mediaType: String) -> ReturnSelfType
    
    /**
     * 写入超时时间
     **/
    @discardableResult
    func setWriteOutTime(writeOutTime: Int) -> ReturnSelfType
    
    /**
     * 读取超时时间
     **/
    @discardableResult
    func setReadOutTime(readOutTime: Int) -> ReturnSelfType
    
    /**
     * 连接超时时间
     **/
    @discardableResult
    func setConnectOutTime(outTime: Int) -> ReturnSelfType
    
    /**
     * 加密的标识
     **/
    @discardableResult
    func setEncryptionKey(encryptionKey: Int) -> ReturnSelfType
    
    /**
     * 是否开启加密
     **/
    @discardableResult
    func isEncryption(isEncryption: Bool) -> ReturnSelfType
    
    /**
     * 设置头部数据（局部）
     **/
    @discardableResult
    func setHeads(heads: Dictionary<String, Any>) -> ReturnSelfType
    
    /**
     * 设置请求方式
     **/
    @discardableResult
    func setNetPattern(netPattern: AutoNetPattern) -> ReturnSelfType
    
    /**
     * 设置请求数据类型
     **/
    @discardableResult
    func setReqType(reqType: AutoNetType) -> ReturnSelfType
    
    /**
     * 设置返回数据类型
     **/
    @discardableResult
    func setResType(resType: AutoNetType) -> ReturnSelfType
    
    /**
     * 设置网络策略
     **/
    @discardableResult
    func setNetStrategy(netStrategy: AutoNetStrategy) -> ReturnSelfType
    
    /**
     * 设置发送文件数据
     **/
    @discardableResult
    func setPushFileParams(pushFileKey: String, filePath: String) -> ReturnSelfType
    
    /**
     * 设置下载文件数据
     **/
    @discardableResult
    func setPullFileParams(filePath: String, fileName: String) -> ReturnSelfType
    
    /**
     * get请求
     **/
    @discardableResult
    func doGet() -> ReturnSelfType
    
    /**
     * post请求
     **/
    @discardableResult
    func doPost() -> ReturnSelfType
    
    /**
     * delete请求
     **/
    @discardableResult
    func doDelete() -> ReturnSelfType
    
    /**
     * put请求
     **/
    @discardableResult
    func doPut() -> ReturnSelfType
    
    /**
     * 设置参数
     **/
    @discardableResult
    func setParam(key: String, value: Any) -> ReturnSelfType
    
    /**
     * 批量设置参数
     **/
    @discardableResult
    func setParams(params: Dictionary<String, Any>) -> ReturnSelfType
    
    /**
     * 设置提前处理方法，使其可以在获得上游时也可以处理
     **/
    @discardableResult
    func setHandlerBefore(handlerBefore: AutoNetConvertClosure<ResponseType, ExpectResponseType>.handlerBefore?) ->ReturnSelfType
    
    /**
     * 得到数据上游
     **/
    func getObservable() -> Observable<ExpectResponseType>
    
    /**
     * 发起请求
     **/
    func start(handlerBefore: AutoNetConvertClosure<ResponseType, ExpectResponseType>.handlerBefore?, onSuccess: AutoNetDataClosure<ExpectResponseType>.onSuccess?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) -> Void
    
    /**
     * 发起请求
     **/
    func start(optLocalData: AutoNetDataClosure<ExpectResponseType>.optLocalData?, onSuccess: AutoNetDataClosure<ExpectResponseType>.onSuccess?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) -> Void
    
    /**
     * 发起请求
     **/
    func start(handlerBefore: AutoNetConvertClosure<ResponseType, ExpectResponseType>.handlerBefore?, onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, onSuccess: AutoNetDataClosure<ExpectResponseType>.onSuccess?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) -> Void
    
    /**
     * 发起请求
     **/
    func start(onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, onSuccess: AutoNetDataClosure<ExpectResponseType>.onSuccess?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) -> Void
    
    /**
     * 发起请求
     **/
    func start(handlerBefore: AutoNetConvertClosure<ResponseType, ExpectResponseType>.handlerBefore?, optLocalData: AutoNetDataClosure<ExpectResponseType>.optLocalData?, onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, onSuccess: AutoNetDataClosure<ExpectResponseType>.onSuccess?, onError: AutoNetDataClosure<Any>.onError?, onEmpty: AutoNetDataClosure<Any>.onEmpty?) -> Void
}
