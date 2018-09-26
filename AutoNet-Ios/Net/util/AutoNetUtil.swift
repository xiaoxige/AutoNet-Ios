//
//  AutoNetUtil.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/22.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import HandyJSON

final class AutoNetUtil{
    
    class func mergeDictionary(first: Dictionary<String, Any>?, second: Dictionary<String, Any>?) -> Dictionary<String, Any>{
        var result = Dictionary<String, Any>()
        if(first != nil){
            for key in first!.keys{
                result[key] = first![key]
            }
        }
        if(second != nil){
            for key in second!.keys{
                result[key] = second![key]
            }
        }
        return result
    }
    
    class func jsonToModelConvert<T: HandyJSON>(jsonData: Data?, t: T) throws -> T?{
        if(jsonData == nil){
            return nil;
        }
        let jsonUtf8 = String.init(data: jsonData!, encoding: String.Encoding.utf8);
        let jsonObject: T? = JSONDeserializer<T>.deserializeFrom(json: jsonUtf8, designatedPath: nil)!
        return jsonObject
    }
    
}
