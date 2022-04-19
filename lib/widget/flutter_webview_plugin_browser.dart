import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webs/utils/log_util.dart';

class FlutterWebViewPluginBrowser extends StatefulWidget {
  final String? url;

  final String? title;

  const FlutterWebViewPluginBrowser({Key? key, this.url, this.title})
      : super(key: key);

  @override
  State<FlutterWebViewPluginBrowser> createState() =>
      _FlutterWebViewPluginBrowserState();
}

class _FlutterWebViewPluginBrowserState
    extends State<FlutterWebViewPluginBrowser> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  late StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();

    // Add a listener to on url changed
    _onUrlChanged =
        flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      LogUtil.i(url, tag: '_FlutterWebViewPluginBrowserState.initState:');
      if (url.contains('weixin:') ||
          url.contains('alipay:') ||
          url.startsWith(new RegExp(r'http[s]:\/\/'))) {
        await flutterWebViewPlugin.stopLoading();
        // await flutterWebViewPlugin.reload();
        // await flutterWebViewPlugin.goBack();
        // if (await canLaunch(url)) {
        //   await launch(url);
        // } else {
        //   throw 'Could not launch $url';
        // }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(title: Text(widget.title.toString())),
      useWideViewPort: true,
      displayZoomControls: true,
      withOverviewMode: true,
    );
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}
