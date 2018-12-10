# AutoNet-Ios（网络框架， 加入了拦截器概念）

	AutoNet封装了URLSession并使用HandyJSON处理了Json数据。 提供了友好简易且强大的回调及API去处理繁琐的网络请求代码，加入了拦截器概念可更加方便用户使用及监控网络请求， 用户直接拿到实体类， 是Ios开发网络应用更加简单， 只需关注业务即可。

# Git地址
## 1. Ios版本：
	https://github.com/xiaoxige/AutoNet-Ios
## 2. Android版本：
	https://github.com/xiaoxige/AutoNet
# AutoNet 技术交流群：
	QQ: 141027175
# 特色
	* 使用简单、调用方便
	* 加入拦截器概念， 用户可以更加方便的制定和监控自己的请求
	* 可动态添加和修改头部
	* 可对请求参数数据进行加密
	* 可自主处理返回的头部数据
	* 可自主处理返回的body数据
	* 可自定义返回数据的类型
	* 可定义固定、灵活及临时的域名、头部信息（优先级： 临时>灵活>固定。 有效性： 固定 >= 灵活 > 临时）
	* 支持网络策略（网络、本地、先本地后网络、先网络后本地）
	* 支持上传文件和下载文件
	* 可直接获得上游的发射器, 用户自己进行操作结果。（eg: 使用zip去合并多个请求等）

# Pod依赖
	pod 'AutoNet', '~> 1.0.3'
# 简易使用demo
  ![image](https://github.com/xiaoxige/AutoNet-Ios/raw/master/Screenshots/autonet-ios-demo.png)

# 拦截器介绍
## 1. 拦截器协议
	/**
	* 拦截器协议
	**/
	public protocol Interceptor {
	/**
	* 拦截器
	* chain: 数据载体及回馈
	* responseBack: 用于上层向下层反馈数据
	**/
	func intercept(chain: Chain, responseBack: @escaping AutoNetClosure.responseBack) ->Void
	}
## 2. 事例：
### 1. AutoNet内部自带的一个默认日志拦截器
	/**
	* 默认日志实现（用户可根据自己的需求自定义拦截器去制定）
	**/
	class DefaultLogInterceptor: Interceptor{
		func intercept(chain: Chain, responseBack: @escaping AutoNetClosure.responseBack) {
			let request = chain.request()
			let url = request.getUrl()
			let method = request.getMethod()
			let params = request.getParam()?.getParams()
			let headers = request.getHeader()?.getHeaders()
			print("-------------------------------------------------------")
			print("---------------------网络请求日志------------------------")
			print("-\t请求地址： \(url)")
			print("-\t请求方式： \(method)")
			print("-\t请求头部参数：")
			if(headers == nil || headers!.count <= 0){
					print("\t\t\t无")
				}else{
					for key in headers!.keys{
						print("\t\t\t\(key): \(headers![key] ?? "")")
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
			print("\t\t\t\(response ?? "空")")
			
			let endTime = Date().timeIntervalSince1970
			print("-------------耗时：\(endTime - bgnTime)ms----------------")
			print("-------------------------------------------------------")
				responseBack(response)
			}
		}
	}	

### 2. 自定义参数拦截器
	final class ParamsInterceptor: Interceptor{
		func intercept(chain: Chain, responseBack: @escaping AutoNetClosure.responseBack) {
			
			var request = chain.request()
			
			let header = request.getHeader()
			// 构造新的头部数据
			let newHeader = header?.newBuilder(isFollow: true)
			.addHeader(key: "token", value: "a")
			.addHeader(key: "userId", value: "0")
			.build()
			
			let param = request.getParam()
			// 构造新的参数数据
			let newParam = param?.newBuilder(isFollow: true)
			.addParam(key: "params1", value: "value1")
			.addParam(key: "params2", value: "value2")
			.build()
			
			request = request.newBuilder()
			.setHeaders(header: newHeader)
			.setParam(param: newParam).build()
			
			chain.proceed(request: request) { (response) in
				responseBack(response)
			}
		}
	}

# AutoNet提供出的Error
	/**
 	 * AutoNet 错误分类
 	 **/
	public enum AutoNetError : Error{
	    /**
	     * 空数据错误（用户在拦截处理空时，可使用该错误）
	     */
	    case EmptyError
	    
	    /**
	     * 网络错误（当网络错误，AutoNet会自动抛出该错误）
	     */
	    case NetError
	    
	    /**
	     * 自定义错误（自定义错误， code及message可自定义。 其中json转换错误时AutoNet就会以该形式抛出）
	     */
	    case CustomError(code: Int, message: String?)

	}

# 使用
## 1. 初始化
### 1.1 AutoNetConfig(配置AutoNet的基本配置) 注意： 该配置基本是固定的， eg: 域名， 头部数据等
	* 设置是否开启默认的网络日志功能
	* 设置默认域名（key: default）
	* 设置多个域名
	* 设置头部参数
	* 设置拦截器
### 1.2 AutoNet的初始化操作
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
	可以全局修改域名和头部数据等， eg：
	AutoNet.updateOrInsertDomainNames(key: "T##String", value: "T##String")
	AutoNet.updateOrInsertHead(key: "T##String", value: "T##Any")
## 2 常用的闭包介绍
	在请求时需要需要关注那些操作就实现那些协议即可， AutoNet会自动判断及给你想要滴
### 2.1 数据相关的闭包
	/**
	* 数据相关回调
	**/
	public final class AutoNetDataClosure<T> {
	
		/**
		* 成功回调
		* t: 要返回的实体类对象
		**/
		public typealias onSuccess = (_ t: T) ->Void
		
		/**
		* 失败回调
		* err: 错误
		**/
		public typealias onError = (_ err: Error) ->Void
		
		/**
		* 数据空回调
		**/
		public typealias onEmpty = () -> Void
		
		/**
		* 本地处理回调
		* params: 请求参数
		* emitter: 数据上游发射器
		* @return true: 拦截AutoNet处理， false: 结果交给AutoNet继续处理（这里需要注意: 如果本地处理， 需要返回true， 在本地操作中只要返回false， AutoNet分分钟钟给你一个AutoNetError.Empty, 因为AutoNet真的不知道如何处理呢）
		**/
		public typealias optLocalData = (_ params: Dictionary<String, Any>?, _ emitter: RxSwift.AnyObserver<T>) -> Bool
	}
### 2.2 数据转换相关闭包
	/**
	* 数据转换相关回调
	**/
	public final class AutoNetConvertClosure<T, Z>{
	
	/**
	* 数据提前处理转换
	* t: 需要转换的前提类对象
	* emitter: RxSwitf 上游发射器
	* @return true: 拦截AutoNet处理， false: 结果交给AutoNet继续处理
	**/
	public typealias handlerBefore = (_ t: T, _ emitter: RxSwift.AnyObserver<Z>) -> Bool 
	}
### 2.3  全局数据回调相关闭包
	/**
	* 网络数据body回调（全局）
	* flag: 请求标识， 可追踪指定请求
	* body: 请求返回body内容
	* emitter: 上游发射器（可自定义返回或者个性化处理）
	* @return: true=> 拦截AutoNet处理， 交给自己处理， false=> 交于AutoNet自行处理
	**/
	public typealias body = (_ flag: Any?, _ body: String, _ emitter: AutoNetSimpleAnyObserver) -> Bool
	
	/**
	* 网络头部数据的返回回调（全局）
	* flag: 请求标识， 可追踪指定请求
	* headers: 请求返回的头部数据
	**/
	public typealias head = (_ flag: Any?, _ headers: Headers) -> Void
	
	/**
	* 参数解密回调
	* key: 加密标识， 可根据不同的标识进行多个加密方式
	* encryptionContent: 需要加密的数据
	* @return: 加密后的数据
	**/
	public typealias encryption = (_ key: Int, _ encryptionContent: String?) -> String

### 2.3 
	/**
	* 文件相关的闭包
	**/
	final class AutoNetFileClosure{
		
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

## 3 网络调用

	// AutoNet请求实例1： 默认返回类型为AutoNet定义好的AutoNetDefaultResponse(其中返回的数据存在对象内部response里)
	1. AutoNet.getInstance().createNet()
	// AutoNet请求实例2: 不需要二次转换，AutoNet会自动把请求数据进行转换
	2. AutoNet.getInstance().createNet(HandyJSON)
	// AutoNet请求实例3: 需要二次转换自己关心的数据， 需要复写handlerBefore方法
	3. AutoNet.getInstance().createNet(HandyJSON, ExpectResponse)
	// 设置请求地址（去除域名）
	.setSuffixUrl(suffixUrl: "T##String")
	// 设置追踪标志
	.setFlag(flag: "T##Any")
	// 设置请求参数
	.setParam(key: "T##String", value: "T##Any")
	.setParams(params: Dictionary<String, Any>())
	// 发起post请求
	.doPost()
	// 发起get请求
	.doGet()
	// 发起put请求
	.doPut()
	// 发起delete请求
	.doDelete()
	// 设置使用的域名的key（默认default）
	.setDomainNameKey(domainNameKey: "T##String")
	// 设置请求方式
	.setNetPattern(netPattern: AutoNetPattern.get)
	// 设置请求策略
	.setNetStrategy(netStrategy: AutoNetStrategy.NET)
	// 设置请求类型（JSON/FORM/STREAM/OTHER）
	.setReqType(reqType: AutoNetType.JSON)
	// 设置返回类型（JSON/FORM/STREAM/OTHER）
	.setResType(resType: AutoNetType.JSON)
	// 设置额外参数（主要解决动态的拼在URL中的参数。eg: www.xxx.com/news/1, 最后的那个动态的参数1）
	.setExtraDynamicParam(extraDynamicParam: "T##String")
	// 设置连接超时时间
	.setConnectOutTime(outTime: 5000)
	// 设置读取超时时间
	.setReadOutTime(readOutTime: 5000)
	// 设置写入超时时间
	.setWriteOutTime(writeOutTime: 5000)
	// 设置解密的key
	.setEncryptionKey(encryptionKey: 0)
	// 是否开启加密功能
	.isEncryption(isEncryption: true)
	// 设置MediaType
	.setMediaType(mediaType: "T##String")
	// 下载文件
	.setPullFileParams(filePath: "T##String", fileName: "T##String")
	// 上传文件
	.setPushFileParams(pushFileKey: "T##String", filePath: "T##String")
	// 设置头部数据（临时有效）
	.setHeads(heads: Dictionary<String, Any>())
	// 获取上游发射者
	(1).getObservable()
	// 开始请求
	(2).start(...)
## 4 获取上游并处理（已zip合并为例， 这里只是用了两个， 其实RxSwift提供了好多， 当然还有其他用法，详情可以看RxSwift的用法）
	// json 数据
	let first: Observable =  AutoNet.getInstance().createNet(BaseResponse<String>())
	.doGet()
	.setDomainNameKey(domainNameKey: "test")
	.setFlag(flag: "xiaoxige")
	.setSuffixUrl(suffixUrl: "/user/test")
	.getObservable()
	// 百度数据
	let second:Observable = AutoNet.getInstance().createNet()
	.doGet()
	.setFlag(flag: "zhuxiaoan")
	.getObservable()
	
	Observable<ContainEntity>.zip(first, second) { (firstEntity, secondEntity) -> ContainEntity in
			// 合并
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

# 简单的例子
## 初始化
	let config = AutoNetConfig.Builder()
	.setIsOpenDefaultLog(isOpen: true)
	.setDefaultDomainName(value: "http://xxx.xxx.com")
	.build()
	AutoNet.getInstance().initAutoNet(config: config)
		.setBodyCallback { (flag, response, emitter) -> Bool in
			// 全局， 所有请求都会经过这里
			// 可以在这里根据统一的字段去判读code什么的是成功
			// 如果不成功可以抛出异常，最后会在onError或者onEmpty中回调
			// 可以根据用户自己业务逻辑处理
			/**
			 * eg: 伪代码(假设 code:0成功, 1000: 数据为空， 其他为错误)
			 * let baseResponse = jsonToModel(response)
			 * let code = baseResponse.getCode()
			 * if(code != 0){
			 *      if(code == 1000){
			 *          emmit.onError(AutoNetError.Empty)
			 *       } else {
			 *          emmit.onError(AutoNetError.Custom(code, baseResponse.getMessage))
			 *       }
			 *      return true
			 *  }
			 **/
			
			return false
		}

## 使用
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
	
