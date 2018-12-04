//
//  Chain.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/22.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 数据载体及回馈（主要用于拦截器）
 **/
public protocol Chain{
    
    /**
     * 获取当前请求体
     * @return: 参数
     **/
    func request() ->Request
    
    /**
     * 参数暴露, 结果反馈
     * request: 暴露的请求参数
     * responseBack: 抛出的上级处理结果
     **/
    func proceed(request: Request, responseBack: @escaping AutoNetClosure.responseBack) ->Void
    
}
