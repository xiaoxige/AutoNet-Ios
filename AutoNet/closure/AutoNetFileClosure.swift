//
//  AutoNetFileClosure.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/12/3.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * 文件相关的闭包
 **/
public final class AutoNetFileClosure{

    /**
     * 文件进度回调
     * progress: 进度（0~100）
     **/
    public typealias onPregress = (_ progress: Float) -> Void
    
    /**
     * 文件完后回调
     * path: 文件路径
     **/
    public typealias onComplete = (_ path: String) -> Void
    
}
