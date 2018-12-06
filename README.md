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
	pod 'AutoNet', '~> 1.0.0'
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

# 使用
## 1. 初始化
### 1.1 AutoNetConfig(配置AutoNet的基本配置) 注意： 该配置基本是固定的， eg: 域名， 头部数据等
	* 设置是否开启默认的网络日志功能
	* 设置默认域名（key: default）
	* 设置多个域名
	* 设置头部参数
	* 设置拦截器


