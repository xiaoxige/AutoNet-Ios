//
//  AutoNetQuqeustTypeUtil.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/3.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * AutoNet 请求类型的工具类
 **/
final class AutoNetQuqeustTypeUtil {
    
    private var STATE_NET: Int = 0
    private var STATE_LOCAL: Int = 1
    private var STATE_PUSH_FILE: Int = 2
    private var STATE_PULL_FILE: Int = 3
    
    private var flag: Int
    
    init(reqType: AutoNetType, resType: AutoNetType) {
        self.flag = self.STATE_NET
        self.initFlag(reqType: reqType, resType: resType)
    }
    
    public func isNet() ->Bool{
        return self.flag == STATE_NET
    }
    
    public func isLocal() ->Bool{
        return self.flag == STATE_LOCAL
    }
    
    public func isPushFile() ->Bool{
        return self.flag == STATE_PUSH_FILE
    }
    
    public func isPullFile() ->Bool{
        return self.flag == STATE_PULL_FILE
    }
    
    private func initFlag(reqType: AutoNetType, resType: AutoNetType) -> Void{
        if(AutoNetType.STREAM == reqType && AutoNetType.STREAM  != resType){
            self.flag = STATE_PUSH_FILE
        } else if(AutoNetType.STREAM != reqType && AutoNetType.STREAM  == resType){
            self.flag = STATE_PULL_FILE
        } else if(AutoNetType.STREAM == reqType && AutoNetType.STREAM  == resType){
            assert(false, "请求类型不合法，reqType/resType不能同时流操作")
        }else {
            self.flag = STATE_NET
        }
    }
}
