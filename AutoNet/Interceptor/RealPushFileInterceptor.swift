//
//  RealPushFileInterceptor.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/4.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 推送文件的拦截器
 **/
final class RealPushFileInterceptor : BaseRealInterceptor{
    
    private var pushFileKey: String?
    private var filePath: String?
    
    public func initFile(pushFileKey: String, filePath: String) -> Void{
        self.pushFileKey = pushFileKey
        self.filePath = filePath
    }
    
    override func process(request: Request, method: AutoNetPattern, heads: Dictionary<AnyHashable, Any>?, finalUrl: URL, finalRequest: URLRequest, responseBack: @escaping AutoNetClosure.responseBack) {
        assert((!TextUtil.isEmpty(str: self.filePath) && !TextUtil.isEmpty(str: self.pushFileKey)), "文件相关信息未获取...")
        var changeedRequest = finalRequest
        changeedRequest.addValue(self.filePath!, forHTTPHeaderField: self.pushFileKey!)
        changeedRequest.addValue("image/jpeg", forHTTPHeaderField: "MediaType")
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(self.writeOutTime)
        config.timeoutIntervalForResource = TimeInterval(self.readOutTime)
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = heads

        let session: URLSession = URLSession.init(configuration: config, delegate: UploadTaskDelegate(onPregress: super.onPregress, onComplete: super.onComplete, path: self.filePath!), delegateQueue: nil)
        session.uploadTask(with: changeedRequest, from: try? Data(contentsOf: URL(fileURLWithPath: filePath!))) { (data, response, error) in
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
    
    class UploadTaskDelegate: NSObject, URLSessionTaskDelegate {
        
        private var onPregress: AutoNetFileClosure.onPregress?
        private var onComplete: AutoNetFileClosure.onComplete?
        private var path: String
        private var preProgress: Float
        
        public init(onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, path: String) {
            self.onPregress = onPregress
            self.onComplete = onComplete
            self.path = path
            self.preProgress = 0
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            let progress: Float = Float(totalBytesSent * 100 / totalBytesExpectedToSend)
            if(self.onPregress != nil && (progress == 0.0 || progress != self.preProgress)){
                self.onPregress!(progress)
            }
            self.preProgress = progress
            if(self.onComplete != nil && progress >= 100){
                self.onComplete!(self.path)
            }
        }
        
    }
    
}
