# 轻康 — 健康生活打卡APP

> 面向大学生群体的轻量化健康管理工具，基于 Flutter 跨平台开发。

---

## 🚀 快速开始

```bash
# 1. 克隆项目
git clone https://github.com/primer496/qk-app.git
cd qk-app

# 2. 安装依赖
flutter pub get

# 3. 运行（确保已连接设备或模拟器）
flutter run
```

---

## 📁 目录结构

```
lib/
├── main.dart                 # 应用入口（勿改）
├── app.dart                  # MaterialApp + 路由 + 底部导航（勿改）
├── config/
│   ├── theme.dart            # Material 3 主题（勿改）
│   ├── routes.dart           # 命名路由常量（按需引用）
│   └── constants.dart        # 全局常量（按需引用）
├── services/
│   ├── http_util.dart        # 网络工具（直接调用）
│   └── storage_util.dart     # 本地存储封装（直接调用）
├── models/                   # 🔲 角色2：数据模型
├── repositories/             # 🔲 角色2：数据仓库接口
├── pages/
│   ├── home/                 # ✅ 组长：首页
│   ├── exercise/             # 🔲 角色4：运动打卡
│   ├── diet/                 # 🔲 角色5：饮食记录
│   ├── habit/                # 🔲 角色6：习惯打卡
│   ├── knowledge/            # 🔲 角色6：健康科普
│   └── profile/              # 🔲 角色3：个人中心
└── widgets/                  # 公共组件（直接使用）
    ├── common_app_bar.dart
    ├── loading_widget.dart
    ├── empty_state_widget.dart
    └── common_list_tile.dart
```

---

## 🧰 工具箱（组长已封装，直接使用）

### 1. 页面跳转 — 命名路由

所有路由常量定义在 `config/routes.dart`，跳转时直接引用：

```dart
import 'package:qk/config/routes.dart';

// 跳转到指定页面
Navigator.pushNamed(context, AppRoutes.exerciseAdd);

// 返回上一页
Navigator.pop(context);
```

| 路由常量 | 对应页面 | 负责角色 |
|---|---|---|
| `AppRoutes.home` | 首页 | 组长 |
| `AppRoutes.exerciseAdd` | 添加运动记录 | 角色4 |
| `AppRoutes.exerciseHistory` | 运动历史 | 角色4 |
| `AppRoutes.exerciseStats` | 运动统计 | 角色4 |
| `AppRoutes.dietAdd` | 添加饮食记录 | 角色5 |
| `AppRoutes.dietFoodSelect` | 选择食物 | 角色5 |
| `AppRoutes.dietToday` | 今日饮食 | 角色5 |
| `AppRoutes.dietStats` | 饮食统计 | 角色5 |
| `AppRoutes.habit` | 习惯打卡 | 角色6 |
| `AppRoutes.habitWeekly` | 周打卡视图 | 角色6 |
| `AppRoutes.knowledgeList` | 科普列表 | 角色6 |
| `AppRoutes.knowledgeDetail` | 科普详情 | 角色6 |
| `AppRoutes.profile` | 个人中心 | 角色3 |
| `AppRoutes.profileNickname` | 昵称设置 | 角色3 |
| `AppRoutes.profileGoal` | 健康目标 | 角色3 |
| `AppRoutes.profileSettings` | 设置 | 角色3 |

### 2. 网络请求 — HttpUtil

```dart
import 'package:qk/services/http_util.dart';

// 获取列表数据（自动处理异常，失败返回空列表）
List<dynamic> data = await HttpUtil().getList('https://xxx.json');

// 获取单个对象
Map<String, dynamic>? obj = await HttpUtil().getMap('https://xxx.json');
```

> ⚠️ 不要自己 `new Dio()`，统一使用 `HttpUtil()`。

### 3. 本地存储 — StorageUtil

```dart
import 'package:qk/services/storage_util.dart';

// 保存
await StorageUtil().saveString('nickname', '小明');
await StorageUtil().saveInt('goal_calories', 2000);
await StorageUtil().saveBool('first_launch', false);

// 读取
String? name = StorageUtil().getString('nickname');
int? goal = StorageUtil().getInt('goal_calories');

// 删除 / 清空
await StorageUtil().remove('nickname');
await StorageUtil().clearAll();
```

> ⚠️ Key 命名规范：`模块_含义`，如 `exercise_records`、`diet_today`、`habit_check_日期`。

### 4. 公共UI组件

```dart
import 'package:qk/widgets/common_app_bar.dart';
import 'package:qk/widgets/loading_widget.dart';
import 'package:qk/widgets/empty_state_widget.dart';
import 'package:qk/widgets/common_list_tile.dart';

// 统一顶部栏
CommonAppBar(title: '运动打卡')

// 加载中
LoadingWidget(message: '正在加载数据...')

// 空数据占位
EmptyStateWidget(
  icon: Icons.fitness_center,
  message: '还没有运动记录',
  actionLabel: '添加记录',
  onAction: () => Navigator.pushNamed(context, AppRoutes.exerciseAdd),
)

// 统一列表项
CommonListTile(
  leading: Icon(Icons.directions_run),
  title: '跑步',
  subtitle: '30分钟 · 消耗200kcal',
  onTap: () {},
)
```

### 5. 全局常量

```dart
import 'package:qk/config/constants.dart';

// 应用名称
AppConstants.appName
// 预设习惯列表
AppConstants.presetHabits
// 数据URL（角色2用）
AppConstants.foodsUrl / AppConstants.sportsUrl / AppConstants.articlesUrl
```

---

## 📐 开发规范

### 命名规范
| 类型 | 规范 | 示例 |
|---|---|---|
| 文件 | `snake_case` | `home_page.dart` |
| 类 | `PascalCase` | `HomePage` |
| 变量/方法 | `camelCase` | `todayCalories` |
| 常量 | `camelCase` | `dataRepoBaseUrl` |
| 存储Key | `模块_含义` | `exercise_records` |

### Git 提交规范
```
feat: 新功能描述
fix: 修复xxx问题
docs: 更新文档
refactor: 重构xxx
```

### Git 协作流程
1. 从 `main` 创建自己的分支：`dev-姓名拼音`
2. 在个人分支上开发，**只修改自己负责的模块目录**
3. 开发完成自测通过 → 推送个人分支 → 告知组长合并
4. 修改公共文件（config/services/widgets）必须先和组长沟通

### 代码风格
- 关键位置加基础注释（类说明、方法用途）
- 优先保证功能跑通，UI 不过度美化
- 禁止私自添加方案外的第三方依赖
- 统一使用 `StatefulWidget` + `setState`，不引入状态管理库

---

## 📱 移动端适配说明

### 整体评估：✅ 适合手机应用

项目基于 **Material 3** 设计系统，原生面向移动端。以下为关键适配项说明：

### 触摸热区（Touch Target）

| 元素 | 尺寸 | 标准 | 状态 |
|---|---|---|---|
| 快捷功能图标 | 52×52dp | ≥48dp | ✅ 达标 |
| 习惯打卡圆圈 | 44×44dp | ≥48dp | ⚠️ 略小，建议后续调至48 |
| 底部导航项 | 系统默认 | ≥48dp | ✅ 达标 |
| 列表项 | 系统默认 | ≥48dp | ✅ 达标 |

### 屏幕适配

- 4列快捷功能网格在 **360dp 及以上**屏幕（主流手机）显示正常
- 320dp 窄屏（如 iPhone SE 1代）文字可能偏紧，可接受
- 卡片水平边距 16dp — 移动端标准间距
- 使用 `ListView` + `RefreshIndicator` — 原生下拉刷新体验

### 页面架构说明

```
Scaffold (MainShell，提供底部导航)
  └── IndexedStack（保持Tab状态不丢失）
        ├── HomePage 的 Scaffold（提供首页顶部栏）
        ├── 运动页 的 Scaffold（提供运动页顶部栏）
        ├── 饮食页 的 Scaffold
        ├── 习惯页 的 Scaffold
        └── 我的页 的 Scaffold
```

> 💡 每个Tab页面有自己的 `Scaffold` + `AppBar`，外层共用底部导航栏。这是 Flutter 官方推荐的多Tab架构，确保各页面独立且状态保持。

### 当前未覆盖（后续可选）

| 项目 | 说明 |
|---|---|
| 暗色主题 | 仅实现了亮色主题，暗色模式后续可加 |
| 横屏布局 | 未做横屏适配，建议锁定竖屏 |
| iOS 安全区 | `AppBar` 自动处理顶部，底部有导航栏无需额外处理 |
| 字体缩放 | 使用系统默认字体，支持系统字体大小设置 |

### 组员开发注意

1. **不要套多层 Scaffold** — 你的页面本身如果是完整页（有 AppBar），就像占位页一样直接 `Scaffold + CommonAppBar` 即可
2. **可点击元素 ≥ 48dp** — 图标按钮、列表项等确保最小触摸区域
3. **避免固定宽度** — 使用 `MediaQuery` 或弹性布局，不要写死像素宽度
4. **测试不同屏幕** — 至少在 360dp 和 414dp 两种宽度下验证布局

---

## 👥 分工与进度

| 角色 | 模块 | 分支 | 状态 |
|---|---|---|---|
| 组长 | 架构+首页+公共层 | main | ✅ 已交付 |
| 角色2 | 数据层+Model+Repository | dev-xxx | 🔲 待开发 |
| 角色3 | 个人中心 | dev-xxx | 🔲 待开发 |
| 角色4 | 运动打卡 | dev-xxx | 🔲 待开发 |
| 角色5 | 饮食记录 | dev-xxx | 🔲 待开发 |
| 角色6 | 习惯打卡+科普 | dev-xxx | 🔲 待开发 |
| 角色7 | 文档+测试 | — | 🔲 待开始 |

---

## 🔗 仓库地址

- **主代码仓库**: `https://github.com/primer496/qk-app`
- **数据仓库**: `https://gitee.com/hwuipj/qk-data` （角色2上传 JSON）
