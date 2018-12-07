//
//  AutoNetDefaultResponse.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/23.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation
import HandyJSON

/***
 * AutoNet的默认返回实体类（当用户未指定返回值时， AutoNet会自动使用该实体类）
 **/
public final class AutoNetDefaultResponse: HandyJSON{
    private var response: String?
    
    public required init(){
    }
    
    public func getResponse() -> String?{
        return self.response
    }
    
    public func setResponse(response: String?) -> Void{
        self.response = response
    }
}
