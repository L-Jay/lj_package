import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lj_package/debug/lj_debug_config.dart';
import 'package:lj_package/lj_package.dart';
import 'package:lj_package/ui_component/lj_password_bar.dart';
import 'package:lj_package/ui_component/lj_webview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class ImageModel {
  String imageUrl;
  String contentUrl;

  ImageModel(this.imageUrl, this.contentUrl);
}

class _HomePageState extends State<HomePage> {
  List<ImageModel> imageList = [
    ImageModel(
        'https://img1.baidu.com/it/u=2093859625,3420507245&fm=253&fmt=auto&app=138&f=JPEG?w=649&h=437',
        'https:www.baidu.com'),
    ImageModel(
        'https://img2.baidu.com/it/u=3157650194,2969546188&fm=253&fmt=auto&app=120&f=JPEG?w=650&h=433',
        'https:www.baidu.com'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _config();
  }

  _config() async {
    await LJUtil.initInstance();

    // LJNetwork.baseUrl = 'http://apis.juhe.cn';
    // LJNetwork.codeKey = 'error_code';
    // LJNetwork.successCode = 0;
    // LJNetwork.messageKey = 'reason';
    // LJNetwork.handleAllFailureCallBack = (error) {};
    // LJNetwork.jsonParse = <T>(data) {
    //   return data;
    // };

    LJDebugConfig.debugState = kDebugMode;
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

    LJDebugConfig.debugServiceChangeCallback = (debugIndex, map) async {
      // if (isLogin) {
      //   logout();
      // }
      LJUtil.preferences.setInt('debugIndex', debugIndex);
      LJNetwork.baseUrl =
          LJDebugConfig.configList[LJDebugConfig.debugIndex]['baseUrl'];
      //push.key = LJDebugConfig.configList[LJDebugConfig.debugIndex]['pushKey'];
    };

    LJDebugConfig.addOverlay(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
            ),
            TextButton(
              onPressed: () {
                LJNetwork.post('/xzqh/query', params: {
                  'key': 'b0f6256515bfc7ae93ab3a48835bf91d',
                  'fid': '',
                }, successCallback: (data) {
                  print(data);
                }, failureCallback: (error) {
                  print(error);
                });
              },
              child: quickText('回调模式post request', 20, Colors.blue),
            ),
            TextButton(
              onPressed: () async {
                var map = await LJNetwork.post('/xzqh/query', params: {
                  'key': 'b0f6256515bfc7ae93ab3a48835bf91d',
                  'fid': '',
                });
                print(map);
              },
              child: quickText('await模式post request', 20, Colors.blue),
            ),
            LJPasswordBar(
              width: 50,
              borderColor: Colors.orange,
              // type: LJPasswordBarType.line,
            ),
          ],
        ),
      ),
    );
  }
}
