//
//  AutoNetTyp.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/23.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * AutoNet 网络数据请求类型
 **/
public enum AutoNetType :Int{
    
    /**
     * json格式
     **/
    case JSON
    /**
     * form表单格式
     **/
    case FORM
    /**
     * 数据流格式
     **/
    case STREAM
    /**
     * 其他格式
     **/
    case OTHER_TYPE
    
}
