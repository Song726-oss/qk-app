import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';

/// 饮食记录 - 占位页（角色5负责）
class DietPlaceholder extends StatelessWidget {
  final String title;
  const DietPlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: title),
      body: Center(
        child: Text(
          '$title — 待角色5开发',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
