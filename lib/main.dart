import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:webs/utils/log_util.dart';
import 'package:webs/widget/flutter_inappwebview_browser.dart';

void main() {
  runApp(const MyApp());
  LogUtil.init(isOpenLog: true, tag: 'MyApp');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("网页列表"),
        ),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textFieldController = TextEditingController(
      text: "https://www.zhihu.com/zvideo/1299614767112294400");

  /// 地址list
  List urlList = [
    {'name': '百度', 'url': 'www.baidu.com'},
    {'name': '优酷', 'url': 'www.youku.com'},
    {'name': '爱奇艺', 'url': 'www.iqiyi.com'},
    {'name': '选课中心', 'url': 'http://m.chinaacc.com/xuanke'}
  ];

  @override
  void initState() {
    super.initState();
    _controllerAddListener();
  }

  ///
  /// 通过监听实时获取输入内容
  ///
  /// @author zony
  /// @time 2022/4/6 09:49
  _controllerAddListener() {
    _textFieldController.addListener(() {
      LogUtil.i(_textFieldController.text,
          tag: '_MyHomePageState._controllerAddListener:');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(

      /// 列
      crossAxisAlignment: CrossAxisAlignment.start, // 当前控件方向垂直的轴
      mainAxisSize: MainAxisSize.max, //有效，外层column高度为整个屏幕
      mainAxisAlignment: MainAxisAlignment.start, // 当前控件方向一致的轴
      children: <Widget>[
    Row(
    /// 行
    crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 2),
                labelText: "请输入网址",
                hintText: "请输入网址",
                hintStyle: TextStyle(color: Colors.black12),
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero)),

                /// 未获得焦点时，下划线颜色为红色
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.redAccent, width: 2)),

                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    LogUtil.d(value, tag: 'onChanged value');
                  });
                },
              ),
          ),
          ),
          Offstage(
            offstage: _textFieldController.text.isEmpty ? true : false,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _textFieldController.clear();
                });
              },
              child: Container(
                  width: 60,
                  height: 60,
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.grey,
                    size: 25,
                  )),
            ),
          ),
          IconButton(
            tooltip: "This is icon button!",
            icon: const Icon(Icons.start),
            // padding: const EdgeInsets.only(
            //     left: 10, top: 20, right: 10, bottom: 0),
            iconSize: 40,
            color: Colors.deepPurpleAccent,
            onPressed: () {
              LogUtil.d('main url: ' + _textFieldController.text);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WebPage(
                              url: _textFieldController.text, title: "百度一下")));
            },
          ),
          ],
        ),
        // CircularProgressIndicator(),
        // const RepaintBoundary(child: CircularProgressIndicator()),
        listViewListTile(urlList),
        // listviewTile(context),
      ],
    );
  }

  ///
  /// ListView中点击事件
  ///
  /// [name] name
  /// [url] url
  /// @author zony
  /// @time 2022/4/9 15:01
  void onItemClick(String name, String url) {
    Navigator.push(
        context,
        // MaterialPageRoute(
        //     builder: (context) => Browser(url: url, title: name)));
        MaterialPageRoute(
            builder: (context) => WebPage(url: url, title: name)));
  }

  /// item长按
  void _onItemLongPressed(int index) {
    setState(() {
      // showCustomDialog(context,index);
    });
  }

  /// ListTile
  Widget listViewListTile(List list) {
    List<Widget> _list = [];
    for (int i = 0; i < list.length; i++) {
      String name = list[i]['name'];
      String url = list[i]['url'];
      _list.add(Center(
        child: ListTile(
            leading: Icon(Icons.list),
            title: Text(name),
            subtitle: Text(url),
            trailing: Icon(Icons.keyboard_arrow_right),
            textColor: Colors.deepOrange,
            onTap: () {
              LogUtil.d(list[i]['url'],
                  tag: '_MyHomePageState.listViewListTile click:');
              setState(() {
                onItemClick(name, url);
              });
            },
            //item 长按事件
            onLongPress: () {
              LogUtil.d(list[i]['url'],
                  tag: '_MyHomePageState.listViewListTile long press:');
              setState(() {
                _onItemLongPressed(i);
              });
            }),
      ));
    }

    var divideList =
    ListTile.divideTiles(context: context, tiles: _list).toList();
    return Expanded(
      child: ListView(
        // 添加ListView控件
        // children: _list, // 无分割线
        children: divideList, // 添加分割线/
      ),
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}
