//
//  TextUtil.swift
//  AutoNet-Ios
//
//  Created by 小稀革 on 2018/11/25.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 判空工具类
 **/
final class TextUtil{
    
    public class func isEmpty(str: String?) -> Bool{
        return str == nil || str!.count <= 0
    }
    
    public class func isEmpty(arr: Array<Any>?) -> Bool{
        return arr == nil || arr!.count <= 0
    }
    
    public class func isEmpty(dic: Dictionary<String, Any>?) -> Bool{
        return dic == nil || dic!.count <= 0
    }
}
