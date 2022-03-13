# SwiftFW

## #1 网络请求（基于AFN提供了两种形式：1.1 block模式； 1.2 delegate模式）

#### 1.1 block模式

```swift
        let apiUrl = "https://api.binstd.com/calendar/query?"
        var params = [String: Any]()
        params = ["appkey": "434911493a104bfb", "date": "2021-11-21"]
        GCNetworkBlockManager.shared.request(Method: GCNetworkRequestType.post,
                                             APIUrl: apiUrl, Parameters: params, SuccessBlock: { (successResponse) in
            print("--------------方式一（block形式）请求数据成功----------")
            let json: Dictionary<String, AnyObject> = successResponse.content as! Dictionary<String, AnyObject>
            let result = json["result"] as? [String: AnyObject]
            // 字典转模型
            let jsonString = ConvertUtility.convertDictionaryToString(dict: result ?? [:])
            let model = DateInfoModel.decodeJSON(from: jsonString)
            guard let huangli = model?.huangli else { return }
            guard let yi = huangli.yi else { return }
            for i in yi {
                print(i)
            }
        }) { (failureResponse) in
            print("--------------方式一请求数据失败----------")
        }
```



#### 1.2 delegate 模式

#### 新建 GCNetworkTestManager文件

```swift
import UIKit

class GCNetworkTestManager: GCNetworkDelegateManager, GCAPIManager, GCAPIManagerValidator {
    override init() {
        super.init()
        self.validatorDelegate = self
    }

    func methodName() -> String {
        return "https://api.binstd.com/calendar/query?"
    }

    func requestType() -> String {
        return GCNetworkRequestType.get.rawValue
    }

    func shouldCache() -> Bool {
        return true
    }

    func checkParams(Manager manager: GCNetworkDelegateManager, CorrectParamsData params: [String : Any]?) -> Bool {
        return true
    }

    func checkCallBackData(Manager manager: GCNetworkDelegateManager, CorrectWithCallBackData data: Any?) -> Bool {
        return true
    }
}

```



#### 在发起网络请求的文件中

```swift
    lazy var testManager: GCNetworkTestManager = {
        let testManager = GCNetworkTestManager()
        testManager.callBackDelagate = self
        testManager.paramSourceDelegate = self
        return testManager
    }()
```



#### 请求

```swift
self.testManager.loadData()
```



### 注意

#### 当后台参数需要传JSON 格式时(将NeedSerializer设置为true)

```swift
        GCNetworkBlockManager.shared.request(Method: GCNetworkRequestType.post,
                                             APIUrl: GCAPIURL.phoneRegistUrl,
                                             Parameters: params,
                                             NeedSerializer: true,
                                             SuccessBlock: { [weak self](successResponse)
```



## #2 JSON解析（提供了三种方式：2.1 Codable 协议解析（官方） 2.2 SwiftyJSON解析  2.3 HandyJSON解析）

#### 2.1 Codable 协议解析（官方）

#### 定义模型 (实现Codable协议)

```swift

import UIKit

class DateInfoModel: Codable {
    var year: String?
    var month: String?
    var day: String?
    var week: String?
    var lunaryear: String?
    var lunarmonth: String?
    var lunarday: String?
    var ganzhi: String?
    var shengxiao: String?
    var star: String?
    var huangli: HuangliModel?
}

```

#### JSON转model

```swift
let json: Dictionary<String, AnyObject> = successResponse.content as! Dictionary<String, AnyObject>
let result = json["result"] as? [String: AnyObject]
// 字典转模型
let jsonString = ConvertUtility.convertDictionaryToString(dict: result ?? [:])
let model = DateInfoModel.decodeJSON(from: jsonString)
```



### 2.2 SwiftyJSON 解析

#### 定义model

```swift
import UIKit
import SwiftyJSON

class SwiftyDateInfoModel: NSObject {
    var year: String?
    var month: String?
    var day: String?
    var week: String?
    var lunaryear: String?
    var lunarmonth: String?
    var lunarday: String?
    var ganzhi: String?
    var shengxiao: String?
    var star: String?
    var huangli: SwiftyHuangliInfoModel
 
    init(jsonData: JSON) {
        year = jsonData["year"].stringValue
        month = jsonData["month"].stringValue
        day = jsonData["day"].stringValue
        lunaryear = jsonData["lunaryear"].stringValue
        lunarmonth = jsonData["lunarmonth"].stringValue
        lunarday = jsonData["lunarday"].stringValue
        ganzhi = jsonData["ganzhi"].stringValue
        shengxiao = jsonData["shengxiao"].stringValue
        star = jsonData["star"].stringValue
        huangli = SwiftyHuangliInfoModel(jsonData: jsonData["huangli"])
    }
}

```

#### JSON转model

```swift
let jsonContent: Dictionary<String, AnyObject> = successResponse.content as! Dictionary<String, AnyObject>
let json = jsonContent["result"]
let jsonData = JSON(json as Any)
let model = SwiftyDateInfoModel(jsonData: jsonData)
```



### 2.3 HandyJSON 解析

#### 定义模型(继承BaseModel)

```swift
import UIKit

class HandyDateInfoModel: BaseModel {
    var year: String?
    var month: String?
    var day: String?
    var week: String?
    var lunaryear: String?
    var lunarmonth: String?
    var lunarday: String?
    var ganzhi: String?
    var shengxiao: String?
    var star: String?
    var huangli: HandyHuangliInfoModel?
}

```


#### JSON转model

```swift
let jsonContent: Dictionary<String, AnyObject> = successResponse.content as! Dictionary<String, AnyObject>
let result = jsonContent["result"] as? [String: AnyObject]
let jsonString = ConvertUtility.convertDictionaryToString(dict: result ?? [:])
let model: HandyDateInfoModel = HandyJsonUtil.jsonToModel(jsonString, HandyDateInfoModel.self) as! HandyDateInfoModel
```



#### 当返回的数据是一个jsonList 时

```swift
let jsonContent: Dictionary<String, AnyObject> = successResponse.content as! Dictionary<String, AnyObject>
let resultList = jsonContent["data"] as? [[String: AnyObject]]
var modelList: [GoodsInfoModel] = []
guard let count = resultList?.count else { return }
guard let dicList = resultList else { return }
for index in 0..<count {
let jsonString = ConvertUtility.convertDictionaryToString(dict: dicList[index])
let model = HandyJsonUtil.jsonToModel(jsonString, GoodsInfoModel.self) as! GoodsInfoModel
modelList.append(model)
}
```
## #3 RxNetworks(基于Moya+HandyJSON+RxSwift封装的网络请求 JSON解析响应式编程框架)

### 以查询XXapi为例

```swift
let disposeBag = DisposeBag()    

func searchAllDevice() {
        var api = NetworkAPIManager.init()
        api.url = "http://xxx.xxx.xxx.xxx:xxxx/xxxxxx?"
        api.parameters = ["XXXX": xxx]
        api.method = .get
        api.plugins = [NetworkLoadingPlugin.init()]
        api.request()
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe { (successResponse) in
                print("\(successResponse)")
                let jsonContent: Dictionary<String, AnyObject> = successResponse as! Dictionary<String, AnyObject>
                let resultList = jsonContent["data"] as? [[String: AnyObject]]
                var modelList: [DeviceInfoModel] = []
                guard let count = resultList?.count else { return }
                guard let dicList = resultList else { return }
                for index in 0..<count {
                    print(dicList[index])
                    let jsonString = ConvertUtility.convertDictionaryToString(dict: dicList[index])
                    let model = HandyJsonUtil.jsonToModel(jsonString, DeviceInfoModel.self) as! DeviceInfoModel
                    modelList.append(model)
                }
            } onError: { (error) in
                print("Network failed: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
    }
```

### 定义disposeBag

```swift
let disposeBag = DisposeBag()    
```

### 初始化api对象

```swift
var api = NetworkAPIManager.init()
```

### 设置url

```swift
api.url = "http://xxx.xxx.xxx.xxx:xxxx/xxxxxx?"
```

### 设置请求参数

```swift
api.parameters = ["xxx": xxx]
```

### 设置参数类型(如果后台请求参数需要JSON格式，则api.parametersType = .json, 否则api.parametersType = .queryString（默认）)

```swift
api.parametersType = .queryString
```

### 设置请求方式

```swift
api.method = .get
```

### 设置所需插件

```swift
api.plugins = [NetworkLoadingPlugin.init()]
```

### 发起请求

```swift
api.request()
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe { (successResponse) in
                 print("success")
            } onError: { (error) in
                print("Network failed: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
```



# 开发框架设计

## #1 MVP

### 视图层 (V)

```swift
class TestMVPViewController: UIViewController {
    
    /** 定义一个presenter，实例化 */
    private let presenter = TestMVPPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加v和p层的绑定
        self.presenter.attachView(viewDelegate: self)
        
        // 调用p层方法
        self.presenter.testMVP()
    }
}
```



### presenter (P)

```swift
class TestMVPPresenter: NSObject {
    // 代理
    private var testMVPProtocol: TestMVPProtocol?

    // MARK: - attach/detach methods

    func testMVP() {
        testMVPProtocol?.testMVPCallback()
    }
    
    // 绑定V和P
    func attachView(viewDelegate: TestMVPProtocol) {
        self.testMVPProtocol = viewDelegate
    }

    // 解除绑定
    func detachView()  {
        self.testMVPProtocol = nil
    }
}
```



### Model (M)

```swift
import UIKit

class TestModel: BaseModel {
     var id: String?
}
```



### Protocol

```swift
protocol TestMVPProtocol: NSObject {
    func testMVPCallback()
}
```



### Service

```swift
class XXXService: BaseService {
    
    static let shared = { XXXService() }()
    
    internal func xxx(success: @escaping ([YouxuanModel]) -> (), failure: @escaping (String) -> ()) {
        APIProvider.rx.request(api: XXXAPI())
            .asObservable()
            .subscribe { (successResponse) in
                print("\(successResponse)")
                        
                }
                success(modelList)
            } onError: { (error) in
                failure(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}

```



### 视图层实现代理的回调方法

```swift
extension TestMVPViewController: TestMVPProtocol {
    func testMVPCallback() {
    	//MARK: TODO
    }
}
```



## #2 MVVM

### 视图层 (V)

```swift

import UIKit

class TestMVVMViewController: BaseRxViewController<TestMVVMViewModel> {

    var datasource: [TestMVVMModel] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.xxxLoad()
        viewModel.outputs.dataSource.subscribe(onNext: { [weak self] data in
            self?.datasource = data
        }).disposed(by: disposeBag)
    }
}
```



### ViewModel (VM)

```swift
class MeituanHomeViewModel: BaseViewModel {
    
    let dataSource = PublishRelay<[YouxuanModel]>()
    
    func xxxLoad() {
        XXXService.shared.getxxx { (modelList) in
            self.dataSource.accept(modelList)
        } failure: { errString in
            print(errString)
        }
    }
}
```



## Model (M)

```swift
class TestMVVMModel: BaseModel {
    var id: String?
}
```



### service

```swift
class XXXService: BaseService {
    
    static let shared = { XXXService() }()
    
    internal func xxx(success: @escaping ([YouxuanModel]) -> (), failure: @escaping (String) -> ()) {
        APIProvider.rx.request(api: XXXAPI())
            .asObservable()
            .subscribe { (successResponse) in
                print("\(successResponse)")
                        
                }
                success(modelList)
            } onError: { (error) in
                failure(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
```



### API

```swift
class XXXAPI: NetworkAPI {
    var parametersType: ParametersType?
    
    var url: APIHost {
        return "https://meituan.thexxdd.cn"
    }
    
    var path: APIPath {
        return "/api/forshop/getprefer"
    }
    
    var method: APIMethod {
        return .get
    }
    
    var parameters: APIParameters? {
        let params: [String: Any] = [:]
        return params
    }
    
    var plugins: APIPlugins {
        let loading = NetworkLoadingPlugin()
        return [loading]
    }
}
```



## VIPER

视图(V)

```swift
class TestVIPERViewController: UIViewController {

    // MARK: - Properties
    var presenter: ViewToPresenterQuotesProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}
```



### Presenter (P)

```swift
class TestPresenter: ViewToPresenterTestProtocol {
    
    // MARK: Properties
    weak var view: PresenterToViewXXXProtocol?
    var interactor: PresenterToInteractorXXXProtocol?
    var router: PresenterToRouterXXXProtocol?
    
    // MARK: Inputs from view
    func viewDidLoad() {
        print("Presenter is being notified that the View was loaded.")
        interactor?.loadXXX()
    }
}
```



### Interactor (I)

```swift
class XXXInteractor: PresenterToInteractorXXXProtocol {
    
    // MARK: Properties
    weak var presenter: InteractorToPresenterXXXProtocol?
    var xxx: [XXX]?
    
    func loadQuotes() {
        print("Interactor receives the request from Presenter to load XXX from the server.")
        XXXService.shared.getxxx(count: 6, success: { (code, xxx) in
            self.xxx = xxx
            self.presenter?.fetchQuotesSuccess(xxx: xxx)
        }) { (code) in
            self.presenter?.fetchQuotesFailure(errorCode: code)
        }
    }
}

```



### Entity (E)

```swift
class XXX: BaseModel {
    var id: String?
}
```



### Router (R)

```swift
class XXXRouter: PresenterToRouterXXXProtocol {
    
    // MARK: - Navigation
    func pushToNextPage(on view: PresenterToViewXXXProtocol, with quote: Quote) {
        print("QuotesRouter is instructed to push QuoteDetailViewController onto the navigation stack.")
        let nextPageViewController = NextPageRouter.createModule(with: quote)
        let viewController = view as! TestVIPERViewController
        viewController.navigationController?.pushViewController(nextPageViewController, animated: true)
    }
}

```

