//
//  AutoNetDataClosure.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/22.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/**
 * 数据相关回调
 **/
public final class AutoNetDataClosure<T> {
    /**
     * 成功回调
     * t: 要返回的实体类对象
     **/
    public typealias onSuccess = (_ t: T) ->Void
    
    /**
     * 失败回调
     * err: 错误
     **/
    public typealias onError = (_ err: Error) ->Void
    
    /**
     * 数据空回调
     **/
    public typealias onEmpty = () -> Void
    
    /**
     * 本地处理回调
     * params: 请求参数
     * emitter: 数据上游发射器
     * @return true: 拦截AutoNet处理， false: 结果交给AutoNet继续处理
     **/
    public typealias optLocalData = (_ params: Dictionary<String, Any>?, _ emitter: RxSwift.AnyObserver<T>) -> Bool
}
