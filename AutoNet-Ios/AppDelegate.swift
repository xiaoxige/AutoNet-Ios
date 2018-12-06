//
//  AppDelegate.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = AutoNetConfig.Builder()
            .setIsOpenDefaultLog(isOpen: true)
            .setDefaultDomainName(value: "https://www.baidu.com")
            .addDomainNames(key: "test", value: "http://192.168.1.125:8090")
            .addDomainNames(key: "upFile", value: "https://zimg.xxxx.com/")
            // 添加拦截器, 可以添加自己业务相关的拦截器
            .addInterceptor(interceptor: ParamsInterceptor())
            .build()
        AutoNet.getInstance().initAutoNet(config: config)
            .setEncryptionCallback(encryptionCallback: { (flag, encryptionContent) -> String in
                // 可通过key去加密参数
                return encryptionContent ?? ""
            })
            .setHeadsCallback { (flag, headers) in
                // 请求返回头部数据回调
            }.setBodyCallback { (flag, response, emmit) -> Bool in
                // 自己处理需要返回true
                return false
            }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
//        let config = AutoNetConfig.Builder()
//            .setIsOpenDefaultLog(isOpen: true)
//            .setDefaultDomainName(value: "http://xxx.xxx.com")
//            .build()
//        AutoNet.getInstance().initAutoNet(config: config)
//            .setBodyCallback { (flag, response, emitter) -> Bool in
//                // 全局， 所有请求都会经过这里
//                // 可以在这里根据统一的字段去判读code什么的是成功
//                // 如果不成功可以抛出异常，最后会在onError或者onEmpty中回调
//                // 可以根据用户自己业务逻辑处理
//                /**
//                 * eg: 伪代码(假设 code:0成功, 1000: 数据为空， 其他为错误)
//                 * let baseResponse = jsonToModel(response)
//                 * let code = baseResponse.getCode()
//                 * if(code != 0){
//                 *      if(code == 1000){
//                 *          emmit.onError(AutoNetError.Empty)
//                 *       } else {
//                 *          emmit.onError(AutoNetError.Custom(code, baseResponse.getMessage))
//                 *       }
//                 *      return true
//                 *  }
//                 **/
//                
//                return false
//        }
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

