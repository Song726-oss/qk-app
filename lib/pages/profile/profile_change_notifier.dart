import 'package:flutter/foundation.dart';

/// 个人中心数据变更通知器
/// 用于在昵称、头像等数据变化时通知其他页面刷新
class ProfileChangeNotifier {
  ProfileChangeNotifier._();

  /// 数据变更通知器，每次个人中心数据变化时 +1
  static final ValueNotifier<int> changeNotifier = ValueNotifier<int>(0);

  /// 通知数据已变更
  static void notifyChange() {
    changeNotifier.value++;
  }
}