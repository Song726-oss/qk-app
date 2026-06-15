import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';

/// 个人中心 - 占位页（角色3负责）
class ProfilePlaceholder extends StatelessWidget {
  final String title;
  const ProfilePlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: title),
      body: Center(
        child: Text(
          '$title — 待角色3开发',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
