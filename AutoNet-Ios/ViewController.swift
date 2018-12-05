//
//  ViewController.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

       var photoPicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 下载文件
        
        let path: String = NSHomeDirectory()
        
        AutoNet.getInstance().createNet().doPost()
        .setResType(resType: AutoNetType.STREAM)
            .setBaseUrl(baseUrl: "https://www.pangpangpig.com/apk/downLoad/android_4.4.1.apk")
        .setPullFileParams(filePath: path, fileName: "aaa.apk")
            .start(handlerBefore: nil, optLocalData: nil, onPregress: { (progress) in
                print("下载进度: \(progress)%")
            }, onComplete: { (res) in
                print("下载完成: \(res)")
            }, onSuccess: { (response) in
                print("下载数据返回: \(response)")
            }, onError: { (error) in
                print("下载出错:\(error)")
            }) {
                print("下载错误为空")
        }
        
//        self.select_a_picture()
    }
    
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    //MARK: - Done image capture here
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        self.dismiss(animated: true, completion: nil)
//        let img = info[UIImagePickerControllerOriginalImage] as? UIImage;
//        print("info = \(info)")
        
//        self.(imageData:UIImageJPEGRepresentation(img!, 0.5)! )

//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil);
        let url:NSURL = (info[UIImagePickerController.InfoKey.imageURL])! as! NSURL
        let urlString: String = url.path!
        
        AutoNet.getInstance().createNet()
        .doPost()
        .setDomainNameKey(domainNameKey: "upFile")
            .setReqType(reqType: AutoNetType.STREAM)
            .setMediaType(mediaType: "jpeg")
            .setPushFileParams(pushFileKey: "upload", filePath: urlString)
            .start(handlerBefore: nil, optLocalData: nil, onPregress: { (progress) in
                print("上传进度: \(progress)%")
            }, onComplete: { (path) in
                print("上传完成(文件路径):\(path)")
            }, onSuccess: { (response) in
                print("上传完成(后台返回数据):\(String(describing: response.getResponse()))")
            }, onError: { (error) in
                print("上传出错 error:\(error)")
            }) {
                print("返回结果为空（但不一定下载失败...eg: 下载成功了， 但是后台返回数据为空了）")
        }
        
    }
    

    func select_a_picture(){
        let alertVC = UIAlertController(title: "请选取上传照片的来源", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            (action: UIAlertAction) -> Void in
            /**
             写取消后操作
             */
        })

        let action2 = UIAlertAction(title: "从相册选取照片", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            
            self.photoPicker =  UIImagePickerController()
            self.photoPicker.delegate = self
            self.photoPicker.sourceType = .photoLibrary
            //在需要的地方present出来
            self.present(self.photoPicker, animated: true, completion: nil)
            
        })
        alertVC.addAction(cancelAction)
        
        alertVC.addAction(action2)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
}

