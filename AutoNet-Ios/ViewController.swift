//
//  ViewController.swift
//  AutoNet-Ios
//
//  Created by pppig on 2018/11/21.
//  Copyright © 2018 xiaoxige. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var scrollView: UIScrollView!
    
    
       var photoPicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.scrollView.backgroundColor = UIColor.white
        self.scrollView.contentSize = CGSize.init(width:0 , height:  self.scrollView.frame.height * 2)
        self.scrollView.alwaysBounceVertical = true
        
    }
    
    
    
    @IBAction func senterNet(_ sender: Any) {
        self.net()
    }
    
    @IBAction func senterLocalNet(_ sender: Any) {
        self.localNet()
    }
    
    
    @IBAction func senterNetLocal(_ sender: Any) {
        self.netLocal()
    }
    
    @IBAction func senterPushFile(_ sender: Any) {
        self.select_a_picture()
    }
    
    @IBAction func senterPullFile(_ sender: Any) {
        self.downFile()
    }
    
    
    @IBAction func senterNetZip2(_ sender: Any) {
        self.netZip()
    }
    
    func netZip() -> Void{
        // json 数据
        let first: Observable =  AutoNet.getInstance().createNet(BaseResponse<String>())
            .doGet()
            .setDomainNameKey(domainNameKey: "test")
            .setFlag(flag: "xiaoxige")
            .setSuffixUrl(suffixUrl: "/user/test").getObservable()
        // 百度数据
        let second:Observable = AutoNet.getInstance().createNet()
        .doGet()
            .setFlag(flag: "zhuxiaoan")
        .getObservable()
        
        Observable<ContainEntity>.zip(first, second) { (firstEntity, secondEntity) -> ContainEntity in
            let containEntity: ContainEntity = ContainEntity()
            containEntity.setFirst(first: firstEntity.getMessage())
            containEntity.setSecond(second: secondEntity.getResponse())
            return containEntity
            }.subscribe(onNext: { (entity) in
                print("entity.first = \(entity.getFirst()), entity.second = \(entity.getSecond())")
            }, onError: { (erro) in
                print("出错了 error = \(erro)")
            }, onCompleted: {
            }) {
                
        }

    }
  
    func netLocal() -> Void{
        AutoNet.getInstance().createNet(BaseResponse<String>(), String())
            .doGet()
            .setDomainNameKey(domainNameKey: "test")
            .setSuffixUrl(suffixUrl: "/user/test")
            .setNetStrategy(netStrategy: AutoNetStrategy.NET_LOCAL)
            .start(handlerBefore: { (response, emmit) -> Bool in
                let data: String? = response.getData()
                if(data == nil){
                    emmit.onError(AutoNetError.EmptyError)
                    return true
                }
                emmit.onNext(data!)
                return true
            }, optLocalData: { (request, emmit) -> Bool in
                emmit.onNext("这个是本地数据~")
                return true
            }, onPregress: nil, onComplete: nil, onSuccess: { (response) in
                print("data = \(response)")
            }, onError: { (error) in
                print("请求错误: \(error)")
            }) {
                print("请求数据为空")
        }
    }
    
    func localNet() -> Void {
        AutoNet.getInstance().createNet(BaseResponse<String>(), String())
        .doGet()
            .setDomainNameKey(domainNameKey: "test")
            .setSuffixUrl(suffixUrl: "/user/test")
            .setNetStrategy(netStrategy: AutoNetStrategy.LOCAL_NET)
            .start(handlerBefore: { (response, emmit) -> Bool in
                let data: String? = response.getData()
                if(data == nil){
                    emmit.onError(AutoNetError.EmptyError)
                    return true
                }
                emmit.onNext(data!)
                return true
            }, optLocalData: { (request, emmit) -> Bool in
                emmit.onNext("这个是本地数据~")
                return true
            }, onPregress: nil, onComplete: nil, onSuccess: { (response) in
                print("data = \(response)")
            }, onError: { (error) in
                print("请求错误: \(error)")
            }) {
                print("请求数据为空")
        }
    }
    
    func net() -> Void{
        AutoNet.getInstance().createNet(BaseResponse<String>(), String())
        .doGet()
            .setDomainNameKey(domainNameKey: "test")
        .setSuffixUrl(suffixUrl: "/user/test")
            .start(handlerBefore: { (response, emmit) -> Bool in
                let data: String? = response.getData()
                if(data == nil){
                    emmit.onError(AutoNetError.EmptyError)
                    return true
                }
                emmit.onNext(data!)
                return true
            }, optLocalData: nil, onPregress: nil, onComplete: nil, onSuccess: { (entity) in
                print("data = \(entity)")
            }, onError: { (error) in
                print("请求错误: \(error)")
            }) {
                print("请求数据为空")
        }
    }
    
    func downFile() ->Void{
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
    
//    private func test() -> Void{
//        // AutoNet请求实例1： 默认返回类型为AutoNet定义好的AutoNetDefaultResponse(其中返回的数据存在对象内部response里)
//        1. AutoNet.getInstance().createNet()
//        // AutoNet请求实例2: 不需要二次转换，AutoNet会自动把请求数据进行转换
//        2. AutoNet.getInstance().createNet(HandyJSON)
//        // AutoNet请求实例3: 需要二次转换自己关心的数据， 需要复写handlerBefore方法
//        3. AutoNet.getInstance().createNet(HandyJSON, ExpectResponse)
//        // 设置请求地址（去除域名）
//        .setSuffixUrl(suffixUrl: "T##String")
//        // 设置追踪标志
//        .setFlag(flag: "T##Any")
//        // 设置请求参数
//        .setParam(key: "T##String", value: "T##Any")
//        .setParams(params: Dictionary<String, Any>())
//        // 发起post请求
//        .doPost()
//        // 发起get请求
//        .doGet()
//        // 发起put请求
//        .doPut()
//        // 发起delete请求
//        .doDelete()
//        // 设置使用的域名的key（默认default）
//        .setDomainNameKey(domainNameKey: "T##String")
//        // 设置请求方式
//        .setNetPattern(netPattern: AutoNetPattern.get)
//        // 设置请求策略
//        .setNetStrategy(netStrategy: AutoNetStrategy.NET)
//        // 设置请求类型（JSON/FORM/STREAM/OTHER）
//        .setReqType(reqType: AutoNetType.JSON)
//        // 设置返回类型（JSON/FORM/STREAM/OTHER）
//        .setResType(resType: AutoNetType.JSON)
//            // 设置额外参数（主要解决动态的拼在URL中的参数。eg: www.xxx.com/news/1, 最后的那个动态的参数1）
//        .setExtraDynamicParam(extraDynamicParam: "T##String")
//        // 设置连接超时时间
//        .setConnectOutTime(outTime: 5000)
//        // 设置读取超时时间
//        .setReadOutTime(readOutTime: 5000)
//        // 设置写入超时时间
//        .setWriteOutTime(writeOutTime: 5000)
//        // 设置解密的key
//        .setEncryptionKey(encryptionKey: 0)
//        // 是否开启加密功能
//        .isEncryption(isEncryption: true)
//        // 设置MediaType
//        .setMediaType(mediaType: "T##String")
//        // 下载文件
//        .setPullFileParams(filePath: "T##String", fileName: "T##String")
//        // 上传文件
//        .setPushFileParams(pushFileKey: "T##String", filePath: "T##String")
//        // 设置头部数据（临时有效）
//        .setHeads(heads: Dictionary<String, Any>())
//            // 获取上游发射者
//            (1).getObservable()
//            // 开始请求
//            (2).start(...)
//    }
}
