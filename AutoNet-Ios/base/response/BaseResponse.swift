//
//  BaseResponse.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/9/26.
//  Copyright © 2018年 Wwc. All rights reserved.
//

import Foundation
import HandyJSON

final class BaseResponse<T>: HandyJSON{
    var code: Int = 0
    var message: String? = nil
    var data: T? = nil
    
    required init(){
    }
    
    public func isSuccess() -> Bool{
        return self.code == 0
    }
    
    public func getCode() ->Int{
        return self.code
    }
    
    public func getMessage() ->String?{
        return self.message
    }
    
}
