import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../services/storage_util.dart';
import '../../config/constants.dart';
import 'profile_change_notifier.dart';

/// 昵称头像设置页
/// 支持首次打开弹窗和独立页面两种模式
class NicknamePage extends StatefulWidget {
  final bool isDialog;

  const NicknamePage({super.key, this.isDialog = false});

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final TextEditingController _nicknameController = TextEditingController();
  int _selectedAvatarIndex = 0;

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
    _loadSavedData();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  /// 加载已保存的数据
  Future<void> _loadSavedData() async {
    final nickname = StorageUtil().getString('profile_nickname');
    final avatarIndex = StorageUtil().getInt('profile_avatar_index');

    setState(() {
      if (nickname != null && nickname.isNotEmpty) {
        _nicknameController.text = nickname;
      }
      if (avatarIndex != null &&
          avatarIndex >= 0 &&
          avatarIndex < _presetAvatars.length) {
        _selectedAvatarIndex = avatarIndex;
      }
    });
  }

  /// 保存数据
  Future<void> _saveData() async {
    final nickname = _nicknameController.text.trim();

    if (nickname.isEmpty) {
      _showSnackBar('请输入昵称');
      return;
    }

    await StorageUtil().saveString('profile_nickname', nickname);
    await StorageUtil().saveInt('profile_avatar_index', _selectedAvatarIndex);

    ProfileChangeNotifier.notifyChange();

    if (mounted) {
      _showSnackBar('保存成功');
      Navigator.of(context).pop(true); // 返回 true 表示保存成功
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 弹窗模式
    if (widget.isDialog) {
      return Dialog(child: _buildContent(theme, isDialog: true));
    }

    // 独立页面模式
    return Scaffold(
      appBar: CommonAppBar(
        title: '设置昵称头像',
        actions: [TextButton(onPressed: _saveData, child: const Text('保存'))],
      ),
      body: _buildContent(theme, isDialog: false),
    );
  }

  Widget _buildContent(ThemeData theme, {required bool isDialog}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isDialog ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 昵称输入
          Text(
            '昵称',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nicknameController,
            maxLength: 12,
            decoration: InputDecoration(
              hintText: '请输入昵称（最多12字）',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 头像选择
          Text(
            '选择头像',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildAvatarGrid(theme),

          // 弹窗模式显示按钮
          if (isDialog) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _saveData, child: const Text('确定')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatarGrid(ThemeData theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: AppConstants.presetAvatarCount,
      itemBuilder: (context, index) {
        final isSelected = index == _selectedAvatarIndex;
        return GestureDetector(
          onTap: () => setState(() => _selectedAvatarIndex = index),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _avatarColors[index].withOpacity(0.15),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                width: 3,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  _presetAvatars[index],
                  size: 40,
                  color: _avatarColors[index],
                ),
                if (isSelected)
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 显示昵称设置弹窗的工具方法
Future<bool?> showNicknameDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => NicknamePage(isDialog: true),
  );
}
