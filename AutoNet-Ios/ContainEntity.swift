//
//  ContainEntity.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/5.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation


class ContainEntity {
    
    private var first: String?
    private var second: String?
    
    public func setFirst(first: String?){
        self.first = first
    }
    
    public func setSecond(second: String?){
        self.second = second
    }
    
    public func getFirst() -> String?{
        return self.first
    }
    
    public func getSecond() -> String?{
        return self.second
    }
    
}
