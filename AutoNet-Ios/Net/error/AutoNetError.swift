//
//  AutoNetError.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/25.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation

enum AutoNetError: Error{
    
    /**
        空数据错误
     */
    case EmptyError
    
    /**
        自定义错误
     */
    case CustomError(code: Int, message: String?)
    
    /**
        网络错误
     */
    case NetError(message: String?)
    
}
