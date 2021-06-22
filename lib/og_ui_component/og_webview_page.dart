import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OGWebViewPage extends StatefulWidget {
  final String url;

  OGWebViewPage(this.url);

  @override
  _OGWebViewPageState createState() => _OGWebViewPageState(url);
}

class _OGWebViewPageState extends State<OGWebViewPage> {
  String _url;
  String _title;
  bool _canBack = false;
  bool _canForward = false;

  _OGWebViewPageState(this._url);

  WebViewController _webViewController;

  String toUtf8(String headHTML) {
    return Uri.dataFromString(headHTML,
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'),
            base64: true)
        .toString();
  }

  Widget _webView() {
    return WebView(
      initialUrl: _url,
      javascriptMode: JavascriptMode.unrestricted,
      gestureNavigationEnabled: true,
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onPageStarted: (String url) async {
        // Utils.showLoading();
        print('开始加载$url');
      },
      onPageFinished: (String url) async {
        // Utils.dismissLoading();
        print('完成加载$url');
        _title = await _webViewController.getTitle();
        _canBack = await _webViewController.canGoBack();
        _canForward = await _webViewController.canGoForward();

        setState(() {});
      },
      onWebResourceError: (WebResourceError error) {
        // Utils.dismissLoading();
        print('加载失败' + error.failingUrl + error.description);
      },
      navigationDelegate: (NavigationRequest request) async {
        String url = request.url;
        if (url != null &&
            !(url.startsWith("http:") || url.startsWith("https:"))) {
          await launch(url); //use url launcher plugin
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      javascriptChannels: <JavascriptChannel>[].toSet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        title: Text(_title ?? ''),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: _webView(),
            ),
          ],
        ),
      ),
    );
  }
}
