import 'package:flutter/material.dart';
import '../../models/article.dart';

/// 科普文章详情页
///
/// 功能说明：
/// - 展示文章的完整内容，包括标题、发布时间和正文
/// - 正文内容支持上下滚动
/// - AppBar 带有返回按钮
class KnowledgeDetailPage extends StatefulWidget {
  const KnowledgeDetailPage({super.key});

  @override
  State<KnowledgeDetailPage> createState() => _KnowledgeDetailPageState();
}

class _KnowledgeDetailPageState extends State<KnowledgeDetailPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 从路由参数中获取 Article 对象
    final article = ModalRoute.of(context)?.settings.arguments as Article?;

    // 如果没有传入文章对象，显示错误提示
    if (article == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('文章详情'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '文章不存在',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // AppBar 标题显示文章标题（过长时省略）
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        // 返回按钮是 AppBar 默认提供的，无需额外配置
      ),
      body: _buildBody(theme, article),
    );
  }

  /// 构建页面主体
  ///
  /// [theme] 主题数据
  /// [article] 文章对象
  Widget _buildBody(ThemeData theme, Article article) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 文章标题 ──
          Text(
            article.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // ── 发布时间 ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  article.publishTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── 分隔线 ──
          Divider(
            color: theme.colorScheme.outlineVariant,
            height: 1,
          ),
          const SizedBox(height: 24),

          // ── 文章正文 ──
          // 正文内容支持上下滚动（通过外层 SingleChildScrollView 实现）
          Text(
            article.content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.8,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
