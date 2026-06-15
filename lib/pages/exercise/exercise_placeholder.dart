import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';

/// 运动打卡 - 占位页（角色4负责）
class ExercisePlaceholder extends StatelessWidget {
  final String title;
  const ExercisePlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: title),
      body: Center(
        child: Text(
          '$title — 待角色4开发',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
