//
//  RealPullFileInterceptor.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/4.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 拉取文件的拦截器
 **/
final class RealPullFileInterceptor : BaseRealInterceptor{
    
    private var filePath: String?
    private var fileName: String?
    
    public func initFile(filePath: String, fileName: String) -> Void{
        self.filePath = filePath
        self.fileName = fileName
    }
    
    override func process(request: Request, method: AutoNetPattern, heads: Dictionary<AnyHashable, Any>?, finalUrl: URL, finalRequest: URLRequest, responseBack: @escaping AutoNetClosure.responseBack) {
        assert((!TextUtil.isEmpty(str: filePath) && !TextUtil.isEmpty(str: fileName)), "文件相关信息未获取...")
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(self.writeOutTime)
        config.timeoutIntervalForResource = TimeInterval(self.readOutTime)
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = heads
        
        let realFilePath: String = AutoNetUrlUtil.autoSplicingFileUrlWithSlashSeparator(basicFilePath: self.filePath!, needSplicingStrPath: self.fileName)
        
        if(!self.autoCreatePathAndcheckFile(realFilePath: realFilePath, filePath: self.filePath!)){
            if(self.onError != nil){
                self.onError!(AutoNetError.CustomError(code: -1, message: "文件夹创建失败|文件被占用, 下载失败..."))
            }
            return
        }
        
        let session: URLSession = URLSession.init(configuration: config, delegate: DownLoadTaskDelegate(
            flag: super.flag, headCallBack: super.headCallBack, onPregress: super.onPregress, onComplete: super.onComplete, onError: super.onError, path: realFilePath, responseBack: responseBack), delegateQueue: nil)
        
        session.downloadTask(with: finalRequest).resume()
    }
    
    private func autoCreatePathAndcheckFile(realFilePath: String, filePath: String) -> Bool{
        let manager = FileManager.default
        
        do{
            if(!manager.fileExists(atPath: filePath)){
                try manager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            }
            
            if(manager.fileExists(atPath: realFilePath)){
                try manager.removeItem(atPath: realFilePath)
            }
        } catch {
            return false
        }

        return true
    }

    class DownLoadTaskDelegate : NSObject, URLSessionDownloadDelegate {
        
        private var flag: Any?
        private var headCallBack: AutoNetClosure.head?
        private var onPregress: AutoNetFileClosure.onPregress?
        private var onComplete: AutoNetFileClosure.onComplete?
        private var onError: AutoNetDataClosure<Any>.onError?
        private var responseBack: AutoNetClosure.responseBack
        private var path: String
        private var preProgress: Float
        
        public init(flag: Any?, headCallBack: AutoNetClosure.head?, onPregress: AutoNetFileClosure.onPregress?, onComplete: AutoNetFileClosure.onComplete?, onError: AutoNetDataClosure<Any>.onError?, path: String, responseBack: @escaping AutoNetClosure.responseBack) {
            self.flag = flag
            self.headCallBack = headCallBack
            self.onPregress = onPregress
            self.onComplete = onComplete
            self.onError = onError
            self.path = path
            self.preProgress = 0
            self.responseBack = responseBack
        }
        
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            
            let response = downloadTask.response
            let error = downloadTask.error
            
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
            
            let fileFrom: String = location.path
            do{
                try FileManager.default.moveItem(atPath: fileFrom, toPath: self.path)
            }catch{
                if(self.onError != nil) {
                    self.onError!(error)
                }
                return
            }
           
            if(self.onComplete != nil){
                self.onComplete!(self.path)
            }
            
            responseBack("")
        }
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            let progress: Float = Float(totalBytesWritten * 100 / totalBytesExpectedToWrite)
            if(self.onPregress != nil && (progress == 0.0 || progress != self.preProgress)){
                self.onPregress!(progress)
            }
            self.preProgress = progress
        }
        
    }
    
}
