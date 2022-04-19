///
/// Log工具类：打印日志相关
///
/// @author zony
/// @time 2022/4/7 14:49
class LogUtil {
  /// 默认日志TAG
  static const String _TAG_DEF = "LogUtil: ";

  /// 是否打开输出日志，true：log输出
  static bool isOpenLogDef = true;

  /// 日志TAG
  static String TAG = _TAG_DEF;

  /// 运行在Release环境时，inProduction为true；
  /// 当App运行在Debug和Profile环境时，inProduction为false。
  static const bool inProduction = bool.fromEnvironment("dart.vm.product");

  ///
  /// 初始化log
  ///
  /// [isOpenLog] 是否打开日志
  /// [tag] tag标识
  /// @author zony
  /// @time 2022/4/7 14:45
  static void init({bool isOpenLog = false, String tag = _TAG_DEF}) {
    isOpenLogDef = isOpenLog;
    TAG = tag;
  }

  ///
  /// 打印INFO日志
  ///
  /// [object] 打印object内容
  /// [tag] tag标识
  /// @author zony
  /// @time 2022/4/7 14:47
  static void i(Object object, {String tag = _TAG_DEF}) {
    _printLog(tag, '[I]💡', object);
  }

  ///
  /// 打印警告日志
  ///
  /// [object] 打印object内容
  /// [tag] tag标识
  /// @author zony
  /// @time 2022/4/7 14:47
  static void w(Object object, {String tag = _TAG_DEF}) {
    _printLog(tag, '[W]⚠️', object);
  }

  ///
  /// 打印错误日志
  ///
  /// [object] 打印object内容
  /// [tag] tag标识
  /// @author zony
  /// @time 2022/4/7 14:47
  static void e(Object object, {String tag = _TAG_DEF}) {
    _printLog(tag, '[E]⛔', object);
  }

  ///
  /// 打印debug日志
  ///
  /// [object] 打印object内容
  /// [tag] tag标识
  /// @author zony
  /// @time 2022/4/7 14:47
  static void d(Object object, {String tag = _TAG_DEF}) {
    _printLog(tag, "[D]🐛", object);
  }

  ///
  /// 输出日志
  ///
  /// [tag] tag标识
  /// [stag] stag标识，比如e、i、v等
  /// [object] 输出object内容
  /// @author zony
  /// @time 2022/4/7 14:48
  static void _printLog(String tag, String stag, Object object) {
    if (!isOpenLogDef || inProduction) {
      print('LogUtil._printLog Log returen! [because isOpenLog: ' +
          isOpenLogDef.toString() +
          ', TAG: ' +
          TAG +
          ', inProduction: ' +
          inProduction.toString()+']');
      return;
    }
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.writeln(
        '┌-----------------------------------------------------------------------------------------');
    stringBuffer.write('│-> ');
    stringBuffer.write(stag);
    stringBuffer.write(" ");
    stringBuffer.write((tag == null || tag.isEmpty) ? TAG : tag);
    stringBuffer.write(": ");
    stringBuffer.write(object);
    print(stringBuffer.toString());
    print(
        '└-----------------------------------------------------------------------------------------');
  }
}
