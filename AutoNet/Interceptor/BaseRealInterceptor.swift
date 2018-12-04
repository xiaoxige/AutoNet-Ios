//
//  BaseRealInterceptor.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/4.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation
/**
 * 网络拦截器的一个抽象工厂
 * 用于生产Net/PushFile/PullFile拦截器
 **/
class BaseRealInterceptor : Interceptor{
    
    var flag: Any?
    var reqType: AutoNetType
    var writeOutTime: Int
    var readOutTime: Int
    var outTime: Int
    var encryptionKey: Int
    var isEncryption: Bool
    var encryptionCallback: AutoNetClosure.encryption?
    var headCallBack: AutoNetClosure.head?
    var onPregress: AutoNetFileClosure.onPregress?
    var onComplete: AutoNetFileClosure.onComplete?
    var onError: AutoNetDataClosure<Any>.onError?
    
    public init(flag: Any?, reqType: AutoNetType, writeOutTime: Int, readOutTime: Int, outTime: Int, encryptionKey: Int, isEncryption: Bool, encryptionCallback: AutoNetClosure.encryption?, headCallBack: AutoNetClosure.head?, onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, onError: AutoNetDataClosure<Any>.onError?){
        self.flag = flag
        self.reqType = reqType
        self.writeOutTime = writeOutTime
        self.readOutTime = readOutTime
        self.outTime = outTime
        self.encryptionKey = encryptionKey
        self.isEncryption = isEncryption
        self.encryptionCallback = encryptionCallback
        self.headCallBack = headCallBack
        self.onPregress = onPregress
        self.onComplete = onComplete
        self.onError = onError
    }
    
    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure.responseBack) {
        let request = chain.request()
        let method = request.getMethod()
        var params: String = self.autoAdaptParams(request: request)
        // 进行参数加密处理
        if(self.isEncryption){
            if(self.encryptionCallback != nil){
                params = self.encryptionCallback!(self.encryptionKey, params)
            }
        }
        let heads = request.getHeader()?.getHeaders()
        let url = getFinalUrl(originalUrl: request.getUrl(), params: params, method: method)
        
        let finalUrl: URL = URL.init(string: url)!
        var finalRequest: URLRequest = URLRequest.init(url: finalUrl, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: TimeInterval(outTime))
        finalRequest.httpMethod = analysisTransformationRequestMethod(method: method)
        if(AutoNetPattern.post == method || AutoNetPattern.put == method){
            finalRequest.httpBody = params.data(using: String.Encoding.utf8)
        }
        
        self.process(request: request, method: method, heads: heads, finalUrl: finalUrl, finalRequest: finalRequest, responseBack: responseBack)
        
    }
    
    public func process(request: Request, method: AutoNetPattern, heads: Dictionary<AnyHashable, Any>?,
                        finalUrl: URL, finalRequest: URLRequest, responseBack: @escaping AutoNetClosure.responseBack) -> Void{
        assert(false, "请自行处理process")
    }
    
    /**
     * 自动转换适配参数
     * get/delete/post、put form ----> a=1&b=2
     * post、put json ----> {"a": 1, "b": 2}
     * 退而说： from ----> a=1&b=2
     *         json ----> {"a": 1, "b": 2}
     **/
    private func autoAdaptParams(request: Request) -> String{
        var autoAdaptParam: String = ""
        let method = request.getMethod()
        let params = request.getParam()?.getParams()
        if(AutoNetPattern.get == method || AutoNetPattern.delete == method
            || (AutoNetPattern.post == method && AutoNetType.FORM == self.reqType)
            || (AutoNetPattern.put == method && AutoNetType.FORM == self.reqType)){
            autoAdaptParam = adaptFromParams(params: params)
        } else if((AutoNetPattern.post == method && AutoNetType.JSON == self.reqType)
            || (AutoNetPattern.put == method && AutoNetType.JSON == self.reqType)){
            autoAdaptParam = adaptJsonParams(params: params)
        } else if(AutoNetType.FORM == self.reqType){
            autoAdaptParam = adaptFromParams(params: params)
        } else if(AutoNetType.JSON == self.reqType){
            autoAdaptParam = adaptJsonParams(params: params)
        }else {
            assert(false, "未找到合适方式的参数转换...")
        }
        return autoAdaptParam
    }
    
    /**
     * 自适应from
     **/
    private func adaptFromParams(params: Dictionary<String, Any>?) -> String{
        if(params == nil){
            return ""
        }
        var adaptParams: String = ""
        for key in params!.keys{
            let value = params![key]
            adaptParams.append("\(key)=\(value ?? "")&")
        }
        
        if(adaptParams.hasSuffix("&")){
            adaptParams = String(adaptParams.removeLast())
        }
        
        return adaptParams
    }
    
    private func adaptJsonParams(params: Dictionary<String, Any>?) -> String{
        if(params == nil){
            return "{}"
        }
        return AutoNetUtil.getJSONStringFromDictionary(dictionary: params)
    }
    
    private func getFinalUrl(originalUrl: String, params:String, method: AutoNetPattern) -> String{
        var url = originalUrl
        if(AutoNetPattern.get == method || AutoNetPattern.delete == method){
            if(url.hasSuffix("/")){
                url = String(url.removeLast())
            }
            if(url.hasSuffix("?")){
                url = String(url.removeLast())
            }
            url.append("?")
            url.append(params)
        }
        return url
    }
    
    private func analysisTransformationRequestMethod(method: AutoNetPattern) -> String{
        if(AutoNetPattern.get == method){
            return "GET"
        } else if(AutoNetPattern.post == method){
            return "POST"
        } else if(AutoNetPattern.delete == method){
            return "DELETE"
        } else if(AutoNetPattern.put == method){
            return "PUT"
        }
        assert(false, "分析网络请求类型失败...")
    }
    
}
