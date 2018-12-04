//
//  AutoNetSimple.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/3.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 简易的上游发射器. 为了兼容body回调所产生
 * 不能让body全局生命周期成为每次请求的周期
 **/
public protocol AutoNetSimpleAnyObserver{
    
    /**
     * obc: 成功后返回的值， 全局body， 不限定具体类型
     **/
    func onNext(obc: Any)
    
    func onError(_ error: Error)
    
    func onCompleted()
}
