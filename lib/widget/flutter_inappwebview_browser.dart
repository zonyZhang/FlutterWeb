import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../utils/log_util.dart';

class WebPage extends StatefulWidget {
  final String? url;
  final String? title;

  const WebPage({Key? key, this.url, this.title}) : super(key: key);

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  /// 进度条进度
  double progress = 0.0;

  InAppWebViewController? _inAppWebViewController;

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false),
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    ios: IOSInAppWebViewOptions(allowsAirPlayForMediaPlayback: true),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title.toString()),
              bottom: PreferredSize(
                  child: _progressBar(context, progress),
                  preferredSize: Size.fromHeight(3)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _willPopCallback();
                },
              ),
            ),
            body: Column(
              children: <Widget>[
                _getMoreWidget(),
                Expanded(
                  // 官方代码
                  child: InAppWebView(
                    initialUrlRequest:
                        URLRequest(url: Uri.parse(widget.url.toString())),
                    initialOptions: options,
                    // 加载进度变化事件
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress.toDouble();
                        LogUtil.i(progress.toString(),
                            tag: '_WebPageState.build progress:');
                      });
                    },
                    onWebViewCreated: (InAppWebViewController controller) {
                      _inAppWebViewController = controller;
                      LogUtil.i('onWebViewCreated');
                    },
                    onLoadStart: (InAppWebViewController controller, Uri? url) {
                      LogUtil.i("onLoadStart url:$url");
                    },
                    onLoadStop: (InAppWebViewController controller, Uri? url) {
                      LogUtil.i("onLoadStop url:$url");
                    },
                    onLoadError: (InAppWebViewController controller, Uri? url,
                        int code, String message) {
                      LogUtil.i(
                          "onLoadError url:$url code:$code message:$message");
                    },
                    onLoadHttpError: (InAppWebViewController controller,
                        Uri? url, int statusCode, String description) {
                      LogUtil.i(
                          "onLoadHttpError url:$url statusCode:$statusCode                                   description:$description");
                    },
                    onConsoleMessage: (InAppWebViewController controller,
                        ConsoleMessage consoleMessage) {
                      LogUtil.i(
                          "onConsoleMessage consoleMessage:$consoleMessage");
                    },
                    shouldOverrideUrlLoading:
                        (InAppWebViewController controller,
                            NavigationAction navigationAction) async {
                      LogUtil.i(
                          "shouldOverrideUrlLoading navigationAction:$navigationAction");
                      return NavigationActionPolicy.ALLOW;
                    },
                    // 资源加载监听器
                    onLoadResource: (InAppWebViewController controller,
                        LoadedResource resource) {
                      LogUtil.i("onLoadResource resource:$resource");
                    },
                    // 滚动监听器
                    onScrollChanged:
                        (InAppWebViewController controller, int x, int y) {
                      LogUtil.i("onScrollChanged x:$x  y:$y");
                    },
                    onLoadResourceCustomScheme:
                        (InAppWebViewController controller, Uri url) async {
                      LogUtil.i("onLoadResourceCustomScheme url:$url");
                      return null;
                    },
                    onCreateWindow: (InAppWebViewController controller,
                        CreateWindowAction createWindowAction) async {
                      LogUtil.i("onCreateWindow");
                      return true;
                    },
                    onCloseWindow: (InAppWebViewController controller) {
                      LogUtil.i("onCloseWindow");
                    },
                    // 过量滚动监听器
                    onOverScrolled: (InAppWebViewController controller, int x,
                        int y, bool clampedX, bool clampedY) async {
                      LogUtil.i(
                          "onOverScrolled x:$x  y:$y clampedX：$clampedX clampedY：$clampedY");
                    },

                    //Android特有功能，请求加载链接，可以拦截资源加载，并替换为本地Web离线包内的资源
                    androidShouldInterceptRequest:
                        (InAppWebViewController controller,
                            WebResourceRequest request) async {
                      LogUtil.i(
                          "androidShouldInterceptRequest request:$request");
                      return null;
                    },

                    //iOS特有功能
                    iosOnNavigationResponse: (InAppWebViewController controller,
                        IOSWKNavigationResponse navigationResponse) async {
                      return null;
                    },
                  ),
                )
              ],
            )));
  }

  Future<bool> _willPopCallback() async {
    bool canNavigate = await _inAppWebViewController!.canGoBack();
    if (canNavigate) {
      _inAppWebViewController!.goBack();
      return false;
    } else {
      return true;
    }
  }

  ///
  /// 进度条
  ///
  /// [context] 环境上下文
  /// [progress] 进度
  /// @author zony
  /// @time 2022/4/14 18:06
  _progressBar(BuildContext context, double progress) {
    LogUtil.i(progress.toString(), tag: '_BrowserState._progressBar:');
    return Container(
      child: progress < 100.0
          ? LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.amberAccent,
              // color: Colors.deepOrange,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange))
          : Container(),
      height: 2,
    );
  }

  // 加载状态
  Widget _getMoreWidget() {
    return Center(
      child: this.progress < 100.0
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    '加载中...',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 1.0,
                  )
                ],
              ),
            )
          : Container(),
    );
  }
}
