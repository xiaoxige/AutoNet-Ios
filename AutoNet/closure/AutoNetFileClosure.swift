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
final class AutoNetFileClosure{
    
    public static var FLAG_UNKNOWN = 0
    public static var FLAG_COMPLETE_PATH: Int = 1
    public static var FLAG_COMPLETE_RESULT: Int = 2

    /**
     * 文件进度回调
     * progress: 进度（0~100）
     **/
    public typealias onPregress = (_ progress: Float) -> Void
    
    /**
     * 文件完后回调
     * flag: 用来标识完成的类型
     *  - FLAG_UNKNOWN: 未知结果状态
     *  - FLAG_COMPLETE_PATH: 文件路径
     *  - FLAG_COMPLETE_RESULT: 返回结果数据
     * path: 文件路径
     **/
    public typealias onComplete = (_ flag: Int, _ path: String) -> Void
    
}
