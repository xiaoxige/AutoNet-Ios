//
//  HTTPMethod.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * AutoNet 所支持的网络请求方式.
 **/
public enum AutoNetPattern : String {
    
    // get 请求
    case get = "GET"
    // post 请求
    case post = "POST"
    // delete 请求
    case delete = "DELETE"
    // put 请求
    case put = "PUT"
    
}
