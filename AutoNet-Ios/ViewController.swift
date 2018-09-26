//
//  ViewController.swift
//  AutoNet-Ios
//
//  Created by Sir on 2018/9/26.
//  Copyright © 2018年 Wwc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AutoNet.getInstance().createNet(BaseResponse<IndexBody>(), Array<IndexEntity>())
            .setUrl(url: "/index/test")
            .doPost()
            .addParam(key: "pagerNo", value: 0)
            .addParam(key: "pagerCount", value: 10)
            .start(handlerBefore: { (response, onError) -> [IndexEntity]? in
                return response.data?.indexEntitys
            }, onSuccess: { (entitys) in
                print(entitys)
            }) { (error) in
                print(error)
        }
    }


}

