# AutoNet-Ios（网络框架）

	AutoNet代理Alamofire并使用HandyJSON处理了Json数据。 用户直接拿到实体类， 是Ios开发网络应用更加简单

# Git地址
## 1. Ios版本：
	https://github.com/xiaoxige/AutoNet-Ios
## 2. Android版本：
	https://github.com/xiaoxige/AutoNet

# 特色
	* 使用简单，调用方便
	* 完全链式调用
	* 屏蔽复杂处理， 直接使用户可方便的得到自己想要的实体类
	* **加入拦截器概念， 用户可轻松定义自己的拦截器**
	* 可自主处理范湖的body数据
	* 网络请求的域名和地址分开， 可添加多个域名
	* 可自定义返回数据类型

# 说明
	本人是做Android开发。近几天看了下Ios的项目， 发现在项目中使用的网络框架是否反锁且很多重复代码，我对代码有强迫症，之前写了Android的AutoNet, 故封装开发了Ios版本的AutoNet, 用户和Android的基本一致， 不过没有Android的全面， 毕竟是做Android的， 刚正式接触Ios没几天。 该版本为第一版本， 暂只支持GET和POST请求, 简易版本（以后维护迭代完善）， 我对Ios也是刚刚入坑几天， 很多都不懂， 如果你感觉这个项目的结构或者想法满意的话， 可以跟我一起完善Ios版本的AutoNet!!!， 或者给我提意见， 欢迎！欢迎！欢迎！！！
	还有一个点就是，如果你要使用AutoNet， 请确定项目中Pod了Alamofire和HandyJSON
# 使用
## 1. 初始化
### 1.1 NetConfig(AutoNet的基本配置) 
	* 设置域名（有一个默认的域名， key: default）
	* 设置拦截器（AutoNet内部提供了一个默认的DefaultLogInterceptor日志拦截器， 可打印网络情况， 当然可能不满足你的个性想法， 你可以自定义拦截器）
	* 设置网络请求的基本属性（Alamofire: URLSessionConfiguration）

### 1.2 AutoNet的初始化操作(只需要在应用启动时初始化即可)
	let config = NetConfing.Builder()
                    .setBaseUrl(baseUrls: <#T##Dictionary<String, String>#>)
                    .setBaseUrl(baseUrls: <#T##Dictionary<String, String>#>, isApped: <#T##Bool#>)
                    .setInterceptor(interceptors: <#T##Array<Interceptor>#>)
                    .setInterceptor(interceptors: <#T##Array<Interceptor>#>, isApped: <#T##Bool#>)
                    .setURLSessionConfiguration(urlSessionCOnfiguration: <#T##URLSessionConfiguration#>)
                    .addDefaultBaseUrl(baseUrl: <#T##String#>)
                    .addBaseUrl(baseKey: <#T##String#>, baseUrl: <#T##String#>)
                    .addBaseUrl(baseKey: <#T##String#>, baseUrl: <#T##String#>, isApped: <#T##Bool#>)
                    .addInterceptor(interceptor: <#T##Interceptor#>, isApped: <#T##Bool#>)
                    .build()
        AutoNet.getInstance().initAutoNet(config: config)
			// 所有请求都会回调该方法， 如果需要自己处理需要返回True
            .setBodyCallback { (response, onError) -> Bool in
                return false
        }
## 2. 拦截器介绍
### 2.1 拦截器协议
	/**
	 * chain.request()-> Request: 得到请求参数
	 * chain.proceed(request: Request, responseBack: @escaping AutoNetClosure<Any>.responseBack) -> Void: 得到上级请求回来的结果
	 * responseBack： 返回给下级拦截器处理后的结果
	 */
	protocol Interceptor{
    	func intercept(chain: Chain, responseBack: @escaping AutoNetClosure<Any>.responseBack) -> Void
	}
### 2.2 拦截器（小例子）
#### 2.2.1 默认的Log拦截器
	class DefaultLogInterceptor: Interceptor{
    
	    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure<Any>.responseBack) {
	        let request = chain.request()
	        let params = request.getParams()?.getParams()
	        let headers = request.getHeaders()?.getHeaders()
	        print("-------------------------------------------------------")
	        print("---------------------网络请求日志------------------------")
	        print("-\t请求地址： \(request.getUrl())")
	        print("-\t请求方式： \(request.getMethod())")
	        print("-\t请求头部参数：")
	        if(headers == nil || headers!.count <= 0){
	            print("\t\t\t无")
	        }else{
	            for key in headers!.keys{
	                print("\t\t\t\(key): \(String(describing: headers![key]))")
	            }
	        }
	        print("-\t请求参数：")
	        if(params == nil || params!.count <= 0){
	            print("\t\t\t无")
	        }else{
	            for key in params!.keys{
	                print("\t\t\t\(key): \(String(describing: params![key]))")
	            }
	        }
	        
	        let bgnTime = Date().timeIntervalSince1970
	        chain.proceed(request: request) { (response) in
	            print("-\t数据返回：")
	            print("\t\t\t\(String(describing: response))")
	            
	            let endTime = Date().timeIntervalSince1970
	            print("-------------耗时：\(endTime - bgnTime)ms----------------")
	            print("-------------------------------------------------------")
	            responseBack(response)
	        }
	    }
	}
#### 2.2.2 添加默认的请求参数的拦截器
	class ParamsDefaultInterceptor: Interceptor{
    
	    func intercept(chain: Chain, responseBack: @escaping AutoNetClosure<Any>.responseBack) {
	        var request = chain.request()
	        
	        // 头部数据
	        var headers = request.getHeaders()
	        headers = headers?.newBuilder(isFollow: true)
	            .addHeader(key: "token", value: "A")
	            .addHeader(key: "userId", value: "0")
	            .build()
	        
	        // 请求参数
	        var params = request.getParams()
	        params = params?.newBuilder(isFollow: true)
	            .addParam(key: "createor", value: "Xiaoxige")
	            .build()
	        
	        request = request.newBuilder(isFollow: true)
	            .setHeaders(headers: headers)
	            .setParams(params: params)
	            .build()
	        
	        chain.proceed(request: request) { (response) in
	            responseBack(response)
	        }
	    }
	}

## 3. 回调闭包介绍
### 3.1 回调协议
	final class AutoNetClosure<T>{
	    
	    typealias onSuccess = (_ t: T) ->Void
	
	    typealias onError = (_ err: Error) ->Void
	    
	    /**
	     *  return: 是否拦截
	     */
	    typealias bodyBack = (_ body: DefaultDataResponse?, _ onError: onError?) -> Bool
	    
	    /**
	     *  用于Alamofire异步数据回调
	     */
	    typealias responseBack = (_ response: DefaultDataResponse?) -> Void
	}
	
	final class AutoNetConvertClosure<T, Z>{
	    
	    /**
	     * 用于提前处理数据（可以定义返回结果）
	     * 注意：（下面说的是要迭代实现的， 暂时如果返回nil, AutoNet会自动回调Empty错误）
	     * 返回结果如果为空， 则说明自己处理的（错误）。 eg: response里包含了一个List!, 如果该List为空， 则需要用户自己抛* 出错误， 即：onError(AutoNetError.EmptyError)
	     */
	    typealias handlerBefore = (_ t: T, _ onError: AutoNetClosure<Any>.onError?) -> Z?
	    
	}
## 4. AutoNet网络请求
### 4.1 语法
    AutoNet.getInstance().createNet(T: HandyJSON, Z)
                    .setUrl(url: <#T##String?#>)
                    .setBaseKey(baseKey: <#T##String#>)
                    .doGet()
                    .doPost()
                    .doGet(params: <#T##Dictionary<String, Any>?#>, isApped: <#T##Bool#>)
					.doPost(params: <#T##Dictionary<String, Any>?#>, isApped: <#T##Bool#>)
					.addParam(key: <#T##String#>, value: <#T##Any#>)
			        .addParams(params: <#T##Dictionary<String, Any>#>)
			        .start(handlerBefore: <#T##((AutoNetDefaultRespose, AutoNetClosure<Any>.onError?) -> AutoNetDefaultRespose?)?##((AutoNetDefaultRespose, AutoNetClosure<Any>.onError?) -> AutoNetDefaultRespose?)?##(AutoNetDefaultRespose, AutoNetClosure<Any>.onError?) -> AutoNetDefaultRespose?#>, onSuccess: <#T##((AutoNetDefaultRespose) -> Void)?##((AutoNetDefaultRespose) -> Void)?##(AutoNetDefaultRespose) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>)
### 4.2 说明
	* createNet(T: HandyJSON, Z): T为Response的类型， 而Z为Body的类型
	* createNet(): T和Z都为默认的AutoNetDefaultResponse, 其中内部的response变量保存这网络的response.data数据（该情况就不需要处理handlerBefore）
	* createNet(T): 直接返回T类型（改方式也不需要处理handlerBefore）
	* handlerBefore（..， ..）: 提前处理， 可以自主返回自己想要的数据
	* onSuccess(..)： 成功的回调
	* onError(..): 错误的回调

## 5. 简单的例子
### 初始化（在应用启动生命周期调用一次即可）
    let config = NetConfing.Builder()
			    .addDefaultBaseUrl(baseUrl: "http://192.168.1.125:8090")
			    .addInterceptor(interceptor:ParamsDefaultInterceptor(), isApped: true)
			    .addInterceptor(interceptor: DefaultLogInterceptor(), isApped: true)
			    .build()
	AutoNet.getInstance().initAutoNet(config: config)
		    .setBodyCallback { (response, onError) -> Bool in
		        if(response != nil){
		            let res = try? AutoNetUtil.jsonToModelConvert(jsonData: response?.data, t: BaseResponse<Any>())
		            if(res != nil){
		                if(!res!!.isSuccess()){
		                    if(onError != nil){
		                        onError!(AutoNetError.CustomError(code: res!!.getCode(), message: res!!.getMessage()))
		                        return true;
		                    }
		                }
		            }
		        }
		        return false
			}
### 简单使用
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