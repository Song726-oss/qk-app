import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../services/storage_util.dart';

/// 健康目标设置页
class GoalSettingPage extends StatefulWidget {
  const GoalSettingPage({super.key});

  @override
  State<GoalSettingPage> createState() => _GoalSettingPageState();
}

class _GoalSettingPageState extends State<GoalSettingPage> {
  // 运动时长目标（分钟）
  double _exerciseDuration = 30;
  // 卡路里摄入目标（kcal）
  double _calorieIntake = 2000;

  // 预设选项
  final List<int> _exercisePresets = [15, 30, 45, 60, 90, 120];
  final List<int> _caloriePresets = [1500, 1800, 2000, 2200, 2500, 3000];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  /// 加载已保存的目标
  Future<void> _loadGoals() async {
    final exerciseDuration = StorageUtil().getInt('goal_exercise_duration');
    final calorieIntake = StorageUtil().getInt('goal_calorie_intake');

    setState(() {
      if (exerciseDuration != null) {
        _exerciseDuration = exerciseDuration.toDouble();
      }
      if (calorieIntake != null) {
        _calorieIntake = calorieIntake.toDouble();
      }
    });
  }

  /// 保存目标
  Future<void> _saveGoals() async {
    await StorageUtil().saveInt('goal_exercise_duration', _exerciseDuration.round());
    await StorageUtil().saveInt('goal_calorie_intake', _calorieIntake.round());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('目标已保存'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CommonAppBar(
        title: '健康目标设置',
        actions: [
          TextButton(
            onPressed: _saveGoals,
            child: const Text('保存'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── 运动时长目标 ──
          _buildSectionHeader(theme, '每日运动时长', Icons.timer),
          const SizedBox(height: 12),
          _buildExerciseDurationCard(theme),
          const SizedBox(height: 24),

          // ── 卡路里摄入目标 ──
          _buildSectionHeader(theme, '每日卡路里摄入', Icons.restaurant),
          const SizedBox(height: 12),
          _buildCalorieIntakeCard(theme),
          const SizedBox(height: 24),

          // ── 提示信息 ──
          _buildTipCard(theme),
        ],
      ),
    );
  }

  /// 构建章节标题
  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// 构建运动时长卡片
  Widget _buildExerciseDurationCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 当前值显示
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '目标时长',
                  style: theme.textTheme.bodyMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_exerciseDuration.round()} 分钟',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 滑块
            Slider(
              value: _exerciseDuration,
              min: 10,
              max: 180,
              divisions: 17,
              label: '${_exerciseDuration.round()} 分钟',
              onChanged: (value) => setState(() => _exerciseDuration = value),
            ),

            const SizedBox(height: 8),

            // 预设快捷按钮
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _exercisePresets.map((duration) {
                final isSelected = _exerciseDuration.round() == duration;
                return ChoiceChip(
                  label: Text('$duration分钟'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _exerciseDuration = duration.toDouble());
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建卡路里摄入卡片
  Widget _buildCalorieIntakeCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 当前值显示
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '目标摄入',
                  style: theme.textTheme.bodyMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_calorieIntake.round()} kcal',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 滑块
            Slider(
              value: _calorieIntake,
              min: 1000,
              max: 4000,
              divisions: 30,
              label: '${_calorieIntake.round()} kcal',
              onChanged: (value) => setState(() => _calorieIntake = value),
            ),

            const SizedBox(height: 8),

            // 预设快捷按钮
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _caloriePresets.map((calorie) {
                final isSelected = _calorieIntake.round() == calorie;
                return ChoiceChip(
                  label: Text('$calorie kcal'),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _calorieIntake = calorie.toDouble());
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建提示卡片
  Widget _buildTipCard(ThemeData theme) {
    return Card(
      color: theme.colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              color: theme.colorScheme.onTertiaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '建议：成年人每天运动30分钟以上，每日摄入热量根据个人体质调整，一般建议1800-2500kcal。',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}