import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_list_tile.dart';
import '../../services/storage_util.dart';
import '../../config/constants.dart';

/// 设置页面
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CommonAppBar(title: '设置'),
      body: ListView(
        children: [
          // ── 关于我们 ──
          CommonListTile(
            leading: Icon(
              Icons.info_outline,
              color: theme.colorScheme.primary,
            ),
            title: '关于我们',
            subtitle: '了解轻康APP',
            onTap: () => _showAboutDialog(context),
          ),

          const Divider(height: 32, indent: 16, endIndent: 16),

          // ── 数据管理 ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '数据管理',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),

          CommonListTile(
            leading: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error,
            ),
            title: '清除所有数据',
            subtitle: '删除所有本地存储的数据',
            onTap: () => _showClearDataDialog(context),
          ),

          const Divider(height: 32, indent: 16, endIndent: 16),

          // ── 版本信息 ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '版本 1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 显示关于我们对话框
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.favorite,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            const Text('关于我们'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '轻康',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              '面向大学生群体的轻量化健康管理工具',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '功能特点：',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('• 运动打卡与统计'),
            Text('• 饮食记录与热量管理'),
            Text('• 习惯养成打卡'),
            Text('• 健康科普知识'),
            SizedBox(height: 16),
            Text(
              '基于 Flutter 跨平台开发',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示清除数据确认对话框
  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('确认清除'),
          ],
        ),
        content: const Text(
          '此操作将清除所有本地存储的数据，包括：\n\n'
          '• 昵称和头像设置\n'
          '• 健康目标设置\n'
          '• 运动打卡记录\n'
          '• 饮食记录\n'
          '• 习惯打卡记录\n\n'
          '清除后数据无法恢复，确定要继续吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await _clearAllData(context);
            },
            child: const Text('确认清除'),
          ),
        ],
      ),
    );
  }

  /// 清除所有数据
  Future<void> _clearAllData(BuildContext context) async {
    try {
      await StorageUtil().clearAll();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('所有数据已清除'),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // 返回上一页，让用户重新开始
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('清除失败：$e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}