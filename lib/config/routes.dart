/// 命名路由表
class AppRoutes {
  AppRoutes._();

  // ── 首页 ──
  static const String home = '/';

  // ── 运动打卡（角色4） ──
  static const String exerciseAdd = '/exercise/add';
  static const String exerciseHistory = '/exercise/history';
  static const String exerciseStats = '/exercise/stats';

  // ── 饮食记录（角色5） ──
  static const String dietAdd = '/diet/add';
  static const String dietFoodSelect = '/diet/food-select';
  static const String dietToday = '/diet/today';
  static const String dietStats = '/diet/stats';

  // ── 习惯打卡（角色6） ──
  static const String habit = '/habit';
  static const String habitWeekly = '/habit/weekly';

  // ── 健康科普（角色6） ──
  static const String knowledgeList = '/knowledge/list';
  static const String knowledgeDetail = '/knowledge/detail';

  // ── 个人中心（角色3） ──
  static const String profile = '/profile';
  static const String profileNickname = '/profile/nickname';
  static const String profileGoal = '/profile/goal';
  static const String profileSettings = '/profile/settings';
}
