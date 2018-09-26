//
//  AutoNetConvertDelegate.swift
//  Xiaoxige
//
//  Created by Xiaoxige on 2018/9/24.
//  Copyright © 2018年 Sir. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON

protocol AutoNetConvertDelegate{
    
    func convert<Z: HandyJSON>(response: DefaultDataResponse) throws -> Z
}
