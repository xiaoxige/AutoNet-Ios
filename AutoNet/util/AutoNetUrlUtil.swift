//
//  AutoNetUrlUtil.swift
//  AutoNet-Ios
//
//  Created by 小稀革 on 2018/11/25.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import Foundation

/**
 * url拼接工具类
 **/
public final class AutoNetUrlUtil{
    
    public class func autoSplicingFileUrlWithSlashSeparator(basicFilePath: String, needSplicingStrPath: String?) -> String{
        return AutoNetUrlUtil.autoSplicingUrlWithSlashSeparator(basicUrl: basicFilePath, needSplicingStr: needSplicingStrPath)
    }
    
    public class func autoSplicingUrlWithSlashSeparator(basicUrl: String, needSplicingStr: String?) -> String{
        var url: String = basicUrl
        if(!TextUtil.isEmpty(str: needSplicingStr)){
            let isBasicUrlEndWithSlashSeparator: Bool = url.hasSuffix("/")
            let isNeedSplicingStrStartWithSlashSparator: Bool = needSplicingStr!.hasPrefix("/")
            if(isBasicUrlEndWithSlashSeparator || isNeedSplicingStrStartWithSlashSparator){
                url = url + needSplicingStr!
            }else{
                url = url + "/" + needSplicingStr!
            }
        }
        return url
    }
    
}
