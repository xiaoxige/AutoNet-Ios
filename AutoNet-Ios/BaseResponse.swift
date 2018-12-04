//
//  BaseResponse.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/3.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation
import HandyJSON

class BaseResponse<T> : HandyJSON{
    private var code: Int
    private var message: String?
    private var data: T?
    
    required init() {
        self.code = 0
    }
    
    public func getCode() -> Int{
        return self.code
    }
    
    public func getMessage() -> String?{
        return self.message
    }
    
    public func getData() -> T?{
        return self.data
    }
}
