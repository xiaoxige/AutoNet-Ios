//
//  Chain.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/22.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import Alamofire

protocol Chain {
    
    func request() -> Request
    
    func proceed(request: Request, responseBack: @escaping AutoNetClosure<Any>.responseBack) -> Void
}
