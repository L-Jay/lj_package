# lj_package

lj_package包含网络请求组件、页面跳转路由管理组件、Event Bus等常用函数和类扩展；轮播图、官改tabbar(修改官方滑动抖动问题)、验证码button封装、密码输入框、网络图片缓存、Webview等常用自定义UI组件。

## 添加依赖
```yaml
dependencies:
    lj_package:
        git: https://github.com/L-Jay/lj_package.git
```

## 网络请求

```dart
// baseUrl配置，https://www.xxx.com
LJNetwork.baseUrl = 'https://www.xxx.com';

// 状态码配置，例如code、errorCode等
LJNetwork.codeKey = 'code';

// 状态码成功值配置，例如0、200等
LJNetwork.successCode = 200;

// 状态码描述配置，例如message、errorMessage等
LJNetwork.messageKey = 'message';

// 默认请求头配置，例如token、version等
LJNetwork.headers.addAll({
  'token': token,
  'version':version,
});

// 统一错误处理回调，例如token过期、服务器错误等
LJNetwork.handleAllFailureCallBack = (error) {
  // 登录过期
  if (error.code == xxx) {
    logout();
  }
};

// json解析回调，接口传入原始值，函数内可使用任何第三方解析库json解析，返回泛型T model类型
LJNetwork.jsonParse = <T>(data) {
  return JsonConvert.fromJsonAsT<T>(data);
};

// 回调请求
LJNetwork.post('/xxx',
params: {
    'key1': 'value1',
    'key2': 'value2',
}, successCallback: (data) {
    print(data);
}, failureCallback: (error) {
    print(error);
});

// await请求
T data = await LJNetwork.post<T>('/xxx', params: {
    'id': 'xxx',
});
print(data);
```

## 路由配置

```dart
// 注册路由页面
RouterManager.routes.addAll(routes);

// 获取登录态
RouterManager.getLoginStatus = () {
  return isLogin;
};

// 注册需要登录才可以跳转的页面，跳转前先判断登录态，未登录调用doLogin回调函数
RouterManager.verifyLoginPageList.addAll(verifyLoginPageList);

// 未登录回调函数，例如弹出登录页，返回Future<bool>类型，true表示登录成功，false取消登录
RouterManager.doLogin = (BuildContext context) {
  // 跳转登录页
  return showLoginPage(context);
};

// 全局返回上一页回调函数，可以做页面销毁后的一些操作，例如隐藏加载框
RouterManager.globalPopCallback = () {
  EasyLoading.dismiss();
};

// 跳转页面
RouterManager.pushNamed(context, 
                        pageName,
                        arguments: {'key': value},
                        popCallback: (value) {
                        // 返回上一页回调
                            setState(() {
                                value = value;
                            });
                        }
});

// 获取页面传递参数
void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // 字典参数获取
      id = argumentMap['id'];
      
      // 单参数获取
      value2 = argument;
      
      // 接口请求
      fetchData(parmas:{'id':id});
    });
}
```

## 工具类

```dart
// App入口
void initState() {
    super.initState();
    
    // 配置app
    _configApp();
  }
  
_configApp() async {
    /*
    preferences = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();
    androidDeviceInfo =
        Platform.isIOS ? null : await DeviceInfoPlugin().androidInfo;
    iosDeviceInfo = Platform.isIOS ? await DeviceInfoPlugin().iosInfo : null;
    */
    await LJUtil.initInstance();
    
    hadShow = LJUtil.preferences.getBool(show);
    version = LJUtil.packageInfo.version;
}
```

## 轮播图

```dart
// 轮播图model
List<ImageModel> imageList = [
    ImageModel(
        'https://xxxx',
        'https:www.baidu.com'),
    ImageModel(
        'https://xxxx',
        'https:www.baidu.com'),
];

LJSwiper(
          viewModels: imageList,
          fit: BoxFit.fitWidth,
          getImgUrl: (ImageModel model) {
            return model.imageUrl;
          },
          onTap: (index) {
            Navigator.push(
              context,
              pageRoute(
                  LJWebViewPage(imageList[index].contentUrl),
              ),
            );
          },
        )
```

## 图片加载

```dart
OGNetworkImage(
    url: url,
    width: 60,
    height: 60,
    radius: 30,
)
```

## 获取验证码按钮

```dart
SendCodeButton(
    controller: _phoneController,
    radius: 15,
    width: 100,
    height: 30,
    fontSize: 14,
    disableColor: garyColor,
    enableColor: blueColor,
    sendCodeMethod: () {
      // 返回Future<bool>，true开始进行倒计时
      return _fetchCode();
    },
)

Future<bool> _fetchCode() async {
    Completer completer = Completer<bool>();
    LJNetwork.post(
      '/fetchCode',
      data: {
        'phone': _phoneController.text,
      },
      successCallback: (data) {
        EasyLoading.showSuccess('获取验证码成功');
        completer.complete(true);
      },
      failureCallback: (error) {
        EasyLoading.showError(error.errorMessage);
        completer.complete(false);
      },
    );

    return completer.future;
}   
```

## 底部Container（全面屏Safe Area）

```dart
// 同时兼容普通屏、全面屏的底部安全区，child为实际显示内容，height为不包含底部安全区的高度，例如iPhone底部的34高度
BottomContainer(
    height: 50,
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          
        },
        style: buttonStyle(
          16,
          Colors.white,
          backgroundColor: blueColor,
        ),
        child: Text('提交'),
      ),
    ),
),
```

## Debug
```dart
// debug是否开启
LJDebugConfig.debugState = kDebugMode;

// 配置环境
LJDebugConfig.configList = [
  {
    'title': '正式',
    'baseUrl': 'https://www.product.com',
    'pushKey': 'product_xxxxx'
  },
  {
    'title': '测试',
    'baseUrl': 'https://www.test.com',
    'pushKey': 'test_xxxxx'
  },
];

if (LJDebugConfig.debugState) {
  //测试环境
  LJDebugConfig.debugIndex = LJUtil.preferences.getInt('debugIndex') ?? 1;
} else {
  //正式环境
  LJDebugConfig.debugIndex = 0;
}

// 环境修改回调
LJDebugConfig.debugServiceChangeCallback = (debugIndex, map) async {
      if (isLogin) {
          logout();
      }
      LJUtil.preferences.setInt('debugIndex', debugIndex);
      LJNetwork.baseUrl =
LJDebugConfig.configList[LJDebugConfig.debugIndex]['baseUrl'];
      push.key = LJDebugConfig.configList[LJDebugConfig.debugIndex]['pushKey'];
    };

// 添加入口
LJDebugConfig.addOverlay(context, 'Debug');
```

## 其他

| 文件 | 描述 |
|------|------|
|   lj_event_bus   |   Event Bus事件队列   |
|   lj_extensions   |  String扩展、State扩展    |
|   lj_permission   |  权限管理封装    |
|   lj_custom_ui    |  自定义UI    |
|   lj_password_bar    |  密码输入框    |
|  lj_imagebutton   |  自定义Button    |
|  lj_linear_progress_bar   |  直线进度条    |
|  lj_slivertabbardelegate   |  SliverPersistentHeader delegate封装    |
|   lj_starbar  |  星级条    |
|  lj_tabbar   |  官改tabbar，修复了滑动抖动问题    |
|  lj_webview_page  |  WebView Page    |


