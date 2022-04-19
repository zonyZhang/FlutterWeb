import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webs/utils/log_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatefulWidget {
  final String? url;

  final String? title;

  const Browser({this.url, this.title});

  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  double lineProgress = 0.0;

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  Future<bool> _willPopCallback() async {
    WebViewController webViewController = await _controller.future;
    bool canNavigate = await webViewController.canGoBack();
    if (canNavigate) {
      webViewController.goBack();
      return false;
    } else {
      return true;
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
              child: _progressBar(context, lineProgress),
              preferredSize: Size.fromHeight(3)),
          title: Text(widget.title!),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _willPopCallback();
            },
          ),
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            setState(() {
              lineProgress = progress.toDouble();
            });
            LogUtil.i('WebView is loading (progress : $progress%)',
                tag: 'onProgress');
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            if (!request.url.startsWith(new RegExp(r'http[s]:\/\/'))) {
              LogUtil.i('blocking navigation to $request}',
                  tag: '_BrowserState.build:');
              return NavigationDecision.prevent;
            }
            LogUtil.i('allowing navigation to $request',
                tag: '_BrowserState.build:');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            LogUtil.d('Page started loading: $url', tag: 'onPageStarted');
          },
          onPageFinished: (String url) {
            LogUtil.d('Page finished loading: $url', tag: 'onPageFinished');
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        ),
        // floatingActionButton: favoriteButton(),
      ),
    );
  }
}
