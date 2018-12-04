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
            .addHeadParam(key: "token", value: 0)
            .addHeadParam(key: "userId", value: "A")
            .build()
        AutoNet.getInstance().initAutoNet(config: config).setHeadsCallback { (flag, headers) in
            
            }
            .setBodyCallback { (flag, response, emmit) -> Bool in
                print("在body中拦截: response = \(response)")
//                emmit.onError(AutoNetError.EmptyError)
                return false
        }

        AutoNet.getInstance().createNet(BaseResponse<String>(), String()).doGet()
        .setDomainNameKey(domainNameKey: "test")
        .setSuffixUrl(suffixUrl: "/user/test")
            .start(handlerBefore: { (response, emmit) -> Bool in
                let data = response.getData()
                if(TextUtil.isEmpty(str: data)){
                    emmit.onError(AutoNetError.EmptyError)
                    return true
                }
                emmit.onNext(data!)
                return true
            }, onSuccess: { (response) in
                print("成功： \(response)")
            }, onError: { (error) in
                print("错误")
            }) {
                print("为空")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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

