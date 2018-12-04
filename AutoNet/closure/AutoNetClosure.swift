//
//  AutoNetClosure.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/22.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/**
 * 用户网络异步数据回调
 **/
public final class AutoNetClosure {
    
    /**
     * 网络数据回调
     * response： 网络返回的数据内容
     **/
   public typealias responseBack = (_ resposne: String?) -> Void
    
    /**
     * 网络数据body回调（全局）
     * flag: 请求标识， 可追踪指定请求
     * body: 请求返回body内容
     * emitter: 上游发射器（可自定义返回或者个性化处理）
     * @return: true=> 拦截AutoNet处理， 交给自己处理， false=> 交于AutoNet自行处理
     **/
    public typealias body = (_ flag: Any?, _ body: String, _ emitter: AutoNetSimpleAnyObserver) -> Bool
 
    /**
     * 网络头部数据的返回回调（全局）
     * flag: 请求标识， 可追踪指定请求
     * headers: 请求返回的头部数据
     **/
    public typealias head = (_ flag: Any?, _ headers: Headers) -> Void
    
    /**
     * 参数解密回调
     * key: 加密标识， 可根据不同的标识进行多个加密方式
     * encryptionContent: 需要加密的数据
     * @return: 加密后的数据
     **/
    public typealias encryption = (_ key: Int, _ encryptionContent: String?) -> String
    
}
