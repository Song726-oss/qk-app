import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储工具类 — 对 shared_preferences 的薄封装
/// 提供类型安全的读写方法，组员无需直接操作 SharedPreferences。
class StorageUtil {
  static final StorageUtil _instance = StorageUtil._internal();
  factory StorageUtil() => _instance;

  StorageUtil._internal();

  SharedPreferences? _prefs;

  /// 初始化，应在 main 中调用一次
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    assert(_prefs != null, 'StorageUtil 未初始化，请先调用 init()');
    return _prefs!;
  }

  // ── String ──
  Future<bool> saveString(String key, String value) => _p.setString(key, value);
  String? getString(String key) => _p.getString(key);

  // ── int ──
  Future<bool> saveInt(String key, int value) => _p.setInt(key, value);
  int? getInt(String key) => _p.getInt(key);

  // ── bool ──
  Future<bool> saveBool(String key, bool value) => _p.setBool(key, value);
  bool? getBool(String key) => _p.getBool(key);

  // ── double ──
  Future<bool> saveDouble(String key, double value) => _p.setDouble(key, value);
  double? getDouble(String key) => _p.getDouble(key);

  // ── String List ──
  Future<bool> saveStringList(String key, List<String> value) =>
      _p.setStringList(key, value);
  List<String>? getStringList(String key) => _p.getStringList(key);

  // ── 删除 & 清空 ──
  Future<bool> remove(String key) => _p.remove(key);
  Future<bool> clearAll() => _p.clear();
}
