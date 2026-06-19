import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_list_tile.dart';
import '../../services/storage_util.dart';
import '../../config/routes.dart';
import '../../config/constants.dart';
import 'nickname_page.dart';

/// 个人中心主页
class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  String _nickname = '用户';
  int _avatarIndex = 0;

  // 预设头像图标列表
  static const List<IconData> _presetAvatars = [
    Icons.person,
    Icons.face,
    Icons.sentiment_satisfied_alt,
    Icons.pets,
    Icons.sports_soccer,
    Icons.music_note,
  ];

  // 预设头像颜色列表
  static const List<Color> _avatarColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkFirstLaunch();
  }

  /// 加载用户数据
  Future<void> _loadUserData() async {
    final nickname = StorageUtil().getString('profile_nickname');
    final avatarIndex = StorageUtil().getInt('profile_avatar_index');

    setState(() {
      if (nickname != null && nickname.isNotEmpty) {
        _nickname = nickname;
      }
      if (avatarIndex != null && avatarIndex >= 0 && avatarIndex < _presetAvatars.length) {
        _avatarIndex = avatarIndex;
      }
    });
  }

  /// 检查是否首次打开
  Future<void> _checkFirstLaunch() async {
    final hasSetNickname = StorageUtil().getBool('profile_has_set_nickname');
    if (hasSetNickname != true) {
      // 延迟显示弹窗，确保页面已构建完成
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNicknameDialog();
      });
    }
  }

  /// 显示昵称设置弹窗
  Future<void> _showNicknameDialog() async {
    final result = await showNicknameDialog(context);
    if (result == true) {
      await StorageUtil().saveBool('profile_has_set_nickname', true);
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CommonAppBar(title: '个人中心'),
      body: ListView(
        children: [
          // ── 用户信息卡片 ──
          _buildUserCard(theme),
          const SizedBox(height: 16),

          // ── 功能列表 ──
          CommonListTile(
            leading: Icon(
              Icons.flag,
              color: theme.colorScheme.primary,
            ),
            title: '健康目标设置',
            subtitle: '设置每日运动时长和卡路里摄入目标',
            onTap: () => _navigateToGoalSetting(),
          ),
          CommonListTile(
            leading: Icon(
              Icons.settings,
              color: theme.colorScheme.secondary,
            ),
            title: '设置',
            subtitle: '关于我们、清除数据',
            onTap: () => _navigateToSettings(),
          ),
        ],
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToNicknameSetting(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // 头像
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _avatarColors[_avatarIndex].withOpacity(0.15),
                ),
                child: Icon(
                  _presetAvatars[_avatarIndex],
                  size: 40,
                  color: _avatarColors[_avatarIndex],
                ),
              ),
              const SizedBox(width: 20),
              // 昵称和提示
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nickname,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '点击修改昵称和头像',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 跳转到昵称设置页
  Future<void> _navigateToNicknameSetting() async {
    await Navigator.pushNamed(context, AppRoutes.profileNickname);
    _loadUserData();
  }

  /// 跳转到健康目标设置页
  Future<void> _navigateToGoalSetting() async {
    await Navigator.pushNamed(context, AppRoutes.profileGoal);
    // 返回后刷新数据（目标可能已更新）
    _loadUserData();
  }

  /// 跳转到设置页
  Future<void> _navigateToSettings() async {
    await Navigator.pushNamed(context, AppRoutes.profileSettings);
    // 返回后刷新数据（可能清除了数据）
    _loadUserData();
  }
}