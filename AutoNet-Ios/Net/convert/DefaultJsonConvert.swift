//
//  DefaultJsonConvert.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/24.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON

class DefaultJsonConver<T: HandyJSON>: AutoNetConvertDelegate{
    
    func convert<Z: HandyJSON>(response: DefaultDataResponse) throws -> Z {
        
//        let responseData = response.data
//        assert(responseData != nil, "this's data is nil...")
        
        let responseString = String.init(data: (response.data)!, encoding: String.Encoding.utf8)!;
        
        if(T.self is AutoNetDefaultRespose.Type){
            let defaultResponse = AutoNetDefaultRespose()
            defaultResponse.response = responseString
            return defaultResponse as! Z
        }
        
        if(responseString.count <= 0){
            throw AutoNetError.EmptyError
        }
        
        let jsonObject: Z = JSONDeserializer<Z>.deserializeFrom(json: responseString, designatedPath: nil)!
        
        return jsonObject
    }
}
