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
        assert((!TextUtil.isEmpty(str: filePath) && !TextUtil.isEmpty(str: pushFileKey)), "文件相关信息未获取...")
        
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(self.writeOutTime)
        config.timeoutIntervalForResource = TimeInterval(self.readOutTime)
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = heads

        let session: URLSession = URLSession.init(configuration: config, delegate: nil, delegateQueue: nil)
        session.uploadTask(with: finalRequest, from: try? Data(contentsOf: URL(fileURLWithPath: filePath!))) { (data, response, error) in
            
        }.resume()
    }
}
