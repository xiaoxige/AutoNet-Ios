//
//  InterceptorDelegate.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/21.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import Alamofire

protocol Interceptor{
    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure<Any>.responseBack) -> Void
}
