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
        
        let _: URLSession = URLSession.init(configuration: config, delegate: nil, delegateQueue: nil)
        
    }

    
}
