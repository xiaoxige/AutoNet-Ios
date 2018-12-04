//
//  AutoNetStrategy.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/23.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 网路策略
 **/
public enum AutoNetStrategy : Int{
    /**
     * 本地
     **/
    case LOCAL
    /**
     * 网络
     **/
    case NET
    /**
     * 先本地后网络
     **/
    case LOCAL_NET
    /**
     * 先网络后本地
     **/
    case NET_LOCAL
}
