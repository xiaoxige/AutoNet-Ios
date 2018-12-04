//
//  AutoNetError.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * AutoNet 错误分类
 **/
enum AutoNetError : Error{

    /**
     * 空数据错误
     */
    case EmptyError
    
    /**
     * 网络错误
     */
    case NetError
    
    /**
     * 自定义错误
     */
    case CustomError(code: Int, message: String?)

}
