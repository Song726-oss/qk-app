import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';

/// 习惯打卡 - 占位页（角色6负责）
class HabitPlaceholder extends StatelessWidget {
  final String title;
  const HabitPlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: title),
      body: Center(
        child: Text(
          '$title — 待角色6开发',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
