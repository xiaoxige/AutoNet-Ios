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
        
        AutoNet.getInstance().createNet()
        .doGet()
            .start { (response) in
                print(response.response)
        }
    }


}

