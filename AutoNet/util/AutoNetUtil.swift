//
//  AutoNetUtil.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation
import HandyJSON

/**
 * AutoNet 工具类
 */
final class AutoNetUtil {
    
    /**
     * 合并两个字典
     **/
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
    
    class func mergeDictionaryPlus(first: Dictionary<AnyHashable, Any>?, second: Dictionary<AnyHashable, Any>?) -> Dictionary<AnyHashable, Any>{
        var result = Dictionary<AnyHashable, Any>()
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
    
    /**
     * json 转成实体类（实体类必须继承HandyJson）
     **/
    class func jsonToModelConvert<T: HandyJSON>(jsonData: Data?, t: T) throws -> T?{
        if(jsonData == nil){
            return nil
        }
        let jsonUtf8 = String.init(data: jsonData!, encoding: String.Encoding.utf8)
        let jsonObject: T? = JSONDeserializer<T>.deserializeFrom(json: jsonUtf8, designatedPath: nil)!
        return jsonObject
    }
    
    /**
      *字典转换为JSONString
      * - parameter dictionary: 字典参数
      * - returns: JSONString
     */
    class func getJSONStringFromDictionary(dictionary: Dictionary<String, Any>?) -> String {
        if(dictionary == nil){
            return "{}"
        }
        if (!JSONSerialization.isValidJSONObject(dictionary!)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary!, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
}
