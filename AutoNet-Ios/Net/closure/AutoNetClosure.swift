//
//  AutoNetClosure.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/22.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import Alamofire

final class AutoNetClosure<T>{
    
    typealias onSuccess = (_ t: T) ->Void

    typealias onError = (_ err: Error) ->Void
    
    /**
        return: 是否拦截
     */
    typealias bodyBack = (_ body: DefaultDataResponse?, _ onError: onError?) -> Bool
    
    /**
        用于Alamofire异步数据回调
     */
    typealias responseBack = (_ response: DefaultDataResponse?) -> Void
}

final class AutoNetConvertClosure<T, Z>{
    
    /**
        用于提前处理数据（可以定义返回结果）
        注意：
     返回结果如果为空， 则说明自己处理的（错误）。 eg: response里包含了一个List!, 如果该List为空， 则需要用户自己抛出错误， 即：onError(AutoNetError.EmptyError)
     */
    typealias handlerBefore = (_ t: T, _ onError: AutoNetClosure<Any>.onError?) -> Z?
    
}
