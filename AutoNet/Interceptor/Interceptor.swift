//
//  Interceptor.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 拦截器协议
 **/
public protocol Interceptor {
    
    /**
     * 拦截器
     * chain: 数据载体及回馈
     * responseBack: 用于上层向下层反馈数据
     **/
    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure.responseBack) ->Void
    
}
