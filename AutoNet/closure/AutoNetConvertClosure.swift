//
//  AutoNetConvertClosure.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/22.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/**
 * 数据转换相关回调
 **/
public final class AutoNetConvertClosure<T, Z>{
    
    /**
     * 数据提前处理转换
     * t: 需要转换的前提类对象
     * emitter: RxSwitf 上游发射器
     * @return true: 拦截AutoNet处理， false: 结果交给AutoNet继续处理
     **/
    public typealias handlerBefore = (_ t: T, _ emitter: RxSwift.AnyObserver<Z>) -> Bool
    
}
