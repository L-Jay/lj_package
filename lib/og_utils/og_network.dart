import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:oralingo_package/og_utils/og_util.dart';

/*请求成功回调*/
typedef OGNetworkSuccessCallback<T> = void Function(T data);

/*请求失败回调*/
typedef OGNetworkFailureCallback = void Function(OGNetworkError error);

typedef OGNetworkJsonParse<T> = T Function<T>(dynamic data);

typedef OGNetworkStatusCallback = void Function(OGNetworkStatus status);

enum OGNetworkStatus { wifi, mobile, none }

class OGNetwork {
  /*baseUrl*/
  static String baseUrl;

  /*headers*/
  static Map<String, dynamic> headers = {};

  /*value*/
  static Map<String, String> defaultParams = {};

  /*状态码key*/
  static String codeKey;

  /*请求成功状态码，默认200*/
  static int successCode = 200;

  /*状态描述key*/
  static String messageKey;

  /*捕获全部请求错误*/
  static OGNetworkFailureCallback handleAllFailureCallBack;

  static OGNetworkJsonParse jsonParse;

  /*全局CancelToken*/
  static CancelToken _globalCancelToken = CancelToken();

  /*请求CancelToken Map*/
  static Map<String, CancelToken> _cancelTokens = Map();

  static final Dio dio = _createDio();

  static Dio _createDio() {
    Dio dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 15 * 1000,
      receiveTimeout: 15 * 1000,
    ));

    if (kDebugMode) {
      dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        print("\n================== 请求数据 ==========================");
        print("url = ${options.uri.toString()}");
        print("headers = ${options.headers}");
        print("queryParameters = ${options.queryParameters}");
        print("params = ${options.data}");

        return handler.next(options);
      }, onResponse: (response, handler) {
        print("\n================== 响应数据 ==========================");
        print("path = ${response.realUri.path}");
        print("code = ${response.statusCode}");
        print("data = ${response.data}");
        print('json = ${json.encode(response.data)}');
        print("\n");
        return handler.next(response);
      }, onError: (DioError e, handler) {
        print("\n================== 错误响应数据 ======================");
        print("type = ${e.type}");
        print("message = ${e.message}");
        print("\n");
        return handler.next(e);
      }));
    }

    return dio;
  }

  /*当前网络是否可用*/
  static bool networkActive;

  static Map<dynamic, StreamSubscription> _networkStatusSubscriptionMap = Map();

  /*
  监控网络状态
  context为key，取消监控使用
  */
  static handleNetworkStatus(
      dynamic context, OGNetworkStatusCallback callback) {
    // ignore: cancel_subscriptions
    StreamSubscription<ConnectivityResult> _connectivitySubscription =
        Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult result) {
      networkActive = result != ConnectivityResult.none;

      switch (result) {
        case ConnectivityResult.wifi:
          callback(OGNetworkStatus.wifi);
          break;
        case ConnectivityResult.mobile:
          callback(OGNetworkStatus.mobile);
          break;
        case ConnectivityResult.none:
          callback(OGNetworkStatus.none);
          break;
      }
    });

    _networkStatusSubscriptionMap[context] = _connectivitySubscription;
  }

  /*取消监控网络状态*/
  static cancelHandleNetworkStatus(dynamic context) {
    _networkStatusSubscriptionMap[context]?.cancel();
    _networkStatusSubscriptionMap.remove(context);
  }

  /*
  get请求
  path如果包含http/https,忽略baseUrl
  path作为取消网络请求的标识，如果为空，使用全局取消cancelToken
  * */
  static Future<dynamic> get<T>(String path,
      {Map<String, dynamic> params,
      Map<String, dynamic> addHeaders,
      OGNetworkSuccessCallback<T> successCallback,
      OGNetworkFailureCallback failureCallback}) async {
    return _request<T>(path,
        isGet: true,
        params: params,
        addHeaders: addHeaders,
        successCallback: successCallback,
        failureCallback: failureCallback);
  }

  /*
  post请求
  path如果包含http/https,忽略baseUrl
  path作为取消网络请求的标识，如果为空，使用全局取消cancelToken
  * */
  static Future<dynamic> post<T>(String path,
      {Map<String, dynamic> params,
      dynamic data,
      Map<String, dynamic> addHeaders,
      OGNetworkSuccessCallback<T> successCallback,
      OGNetworkFailureCallback failureCallback}) async {
    return _request<T>(path,
        isPost: true,
        params: params,
        data: data,
        addHeaders: addHeaders,
        successCallback: successCallback,
        failureCallback: failureCallback);
  }

  static Future<dynamic> put<T>(String path,
      {Map<String, dynamic> params,
      dynamic data,
      Map<String, dynamic> addHeaders,
      OGNetworkSuccessCallback<T> successCallback,
      OGNetworkFailureCallback failureCallback}) async {
    return _request<T>(path,
        isPut: true,
        params: params,
        data: data,
        addHeaders: addHeaders,
        successCallback: successCallback,
        failureCallback: failureCallback);
  }

  /*
  post请求
  path如果包含http/https,忽略baseUrl
  path作为取消网络请求的标识，如果为空，使用全局取消cancelToken
  * */
  static Future<dynamic> delete<T>(String path,
      {Map<String, dynamic> params,
      dynamic data,
      Map<String, dynamic> addHeaders,
      OGNetworkSuccessCallback<T> successCallback,
      OGNetworkFailureCallback failureCallback}) async {
    return _request<T>(
      path,
      params: params,
      data: data,
      isDelete: true,
      addHeaders: addHeaders,
      successCallback: successCallback,
      failureCallback: failureCallback,
    );
  }

  static Future<dynamic> _request<T>(
    String path, {
    bool isPost = false,
    bool isGet = false,
    bool isDelete = false,
    bool isPut = false,
    Map<String, dynamic> params,
    dynamic data,
    Map<String, dynamic> addHeaders,
    OGNetworkSuccessCallback<T> successCallback,
    OGNetworkFailureCallback failureCallback,
  }) async {
    // 未获取网络状态初次获取
    // if (networkActive == null) {
    //   var result = await Connectivity().checkConnectivity();
    //   networkActive = result != ConnectivityResult.none;
    // }
    //
    // if (!networkActive) {
    //   failureCallback?.call((OGNetworkError(444, '网络异常，请检查网络设置')));
    //   return;
    // }

    Completer completer = Completer<dynamic>();

    NetworkHistoryModel historyModel = NetworkHistoryModel();

    try {
      /*header*/
      Map<String, dynamic> _headers = {};
      _headers.addAll(headers);
      if (addHeaders != null) _headers.addAll(addHeaders);
      dio.options.headers = _headers;

      /*cancelToken*/
      CancelToken cancelToken;
      if (path != null) {
        cancelToken = CancelToken();
        _cancelTokens[path] = cancelToken;
      } else {
        cancelToken = _globalCancelToken;
      }

      // request
      Response response;
      if (isPost) {
        historyModel.method = 'post';

        response = await dio.post(
          path,
          queryParameters: params,
          data: data,
          cancelToken: cancelToken,
        );
      }
      if (isPut) {
        historyModel.method = 'put';

        response = await dio.put(
          path,
          queryParameters: params,
          data: data,
          cancelToken: cancelToken,
        );
      }
      if (isDelete) {
        historyModel.method = 'delete';

        response = await dio.delete(
          path,
          queryParameters: params,
          cancelToken: cancelToken,
        );
      }
      if (isGet) {
        historyModel.method = 'get';

        response = await dio.get(
          path,
          queryParameters: params,
          cancelToken: cancelToken,
        );
      }

      if (kDebugMode) {
        historyModel.title = path ?? baseUrl;
        historyModel.url = response.realUri?.toString();
        historyModel.headers = _headers;
        historyModel.params = params ?? (data is Map ? data : null);
        historyModel.responseHeaders = response.headers?.map;
        historyModel.jsonResult = jsonEncode(response.data);

        historyList.insert(0, historyModel);
      }

      // 删除本次请求的cancelToken
      _removeCancelToken(path);

      Map responseData = {};
      if (response.data is String)
        responseData = jsonDecode(response.data);
      else if (response.data is Map) responseData = response.data;

      int code = responseData[codeKey];

      /*请求数据成功*/
      if (code == null || code == successCode) {
        if (T == dynamic) {
          successCallback?.call(response.data);
          completer.complete(response.data);
        } else {
          T t = jsonParse<T>(response.data);
          successCallback?.call(t);
          completer.complete(t);
        }
      } else {
        /*请求数据发生错误*/
        OGNetworkError error = OGNetworkError(code, response.data[messageKey]);

        failureCallback?.call(error);

        handleAllFailureCallBack?.call(error);

        completer.complete(error);
      }
    } on DioError catch (error) {
      OGNetworkError finalError;
      int errorCode =
          error.response?.data is Map ? error.response.data[codeKey] : null;
      String message =
          error.response?.data is Map ? error.response.data[messageKey] : null;

      if (errorCode != null && message != null) {
        historyModel.errorCode = errorCode?.toString();
        historyModel.errorMsg = message;

        finalError = OGNetworkError(errorCode, message);

        failureCallback?.call(finalError);

        handleAllFailureCallBack?.call(finalError);
      } else {
        switch (error.type) {
          case DioErrorType.connectTimeout:
          case DioErrorType.receiveTimeout:
          case DioErrorType.sendTimeout:
            errorCode = 504;
            message = OGUtil.isEnglish ? 'Network exception' : '网络连接超时，请检查网络设置';
            break;
          case DioErrorType.response:
            errorCode = 404;
            message = OGUtil.isEnglish ? 'Network exception' : '服务器异常，请稍后重试！';
            break;
          case DioErrorType.other:
            errorCode = 500;
            message = OGUtil.isEnglish ? 'Network exception' : '网络异常，请稍后重试！';
            break;

          case DioErrorType.cancel:
            // TODO: Handle this case.
            break;
        }
        /*请求数据发生错误*/
        finalError = OGNetworkError(errorCode, message);

        failureCallback?.call(finalError);

        handleAllFailureCallBack?.call(finalError);

        historyModel.responseHeaders = error.response?.headers?.map;
        historyModel.errorCode = error.response?.statusCode?.toString();
        historyModel.errorMsg = error.response?.statusMessage;

        if (kDebugMode) historyList.insert(0, historyModel);
      }

      completer.complete(finalError);
    }

    return completer.future;
  }

  static Future download({
    @required String url,
    @required String savePath,
    ProgressCallback onReceiveProgress,
    Function error,
  }) {
    return dio
        .download(
          url,
          savePath,
          onReceiveProgress: onReceiveProgress,
          options: Options(receiveTimeout: 5 * 60 * 1000),
        )
        .catchError(error);
  }

  /*
  取消请求
  path为空时，取消所有path为空的请求
  */
  static cancel({String path}) {
    CancelToken cancelToken;
    if (path != null) {
      cancelToken = _cancelTokens[path];
    } else {
      cancelToken = _globalCancelToken;
    }

    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel();

      _removeCancelToken(path);

      if (kDebugMode) {
        print(path != null ? '========取消请求$path' : '========取消所有没有path的请求');
      }
    }
  }

  /*删除path对应的cancelToken*/
  static _removeCancelToken(String path) {
    if (path != null) {
      _cancelTokens.remove(path);
    }
  }

  /*------ Debug -------*/
  static List<NetworkHistoryModel> historyList = [];
}

class OGNetworkError {
  OGNetworkError(this.errorCode, this.errorMessage);

  int errorCode;
  String errorMessage;
}

class NetworkHistoryModel {
  String title;
  String url;
  String method;
  Map headers;
  Map params;
  Map<String, List<String>> responseHeaders;
  String jsonResult;
  String errorCode;
  String errorMsg;

  @override
  String toString() {
    return '{' +
        '"title":"' +
        (title ?? '') +
        '","url":"' +
        (url ?? '') +
        '","method":"' +
        (method ?? '') +
        '","headers":"' +
        (headers?.toString() ?? '') +
        '","params":"' +
        (params?.toString() ?? '') +
        '","responseHeaders":"' +
        (responseHeaders?.toString() ?? '') +
        '","jsonResult":' +
        (jsonResult ?? '') +
        ',"errorCode":"' +
        (errorCode ?? '') +
        '","errorMsg":"' +
        (errorMsg ?? '') +
        '"' +
        '}';
  }
}
