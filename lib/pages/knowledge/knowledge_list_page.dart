import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../models/article.dart';
import '../../repository/article_repository.dart';

/// 健康科普文章列表页
///
/// 功能说明：
/// - 展示科普文章列表，每项显示标题和发布时间
/// - 支持下拉刷新获取最新数据
/// - 点击列表项跳转到文章详情页
class KnowledgeListPage extends StatefulWidget {
  const KnowledgeListPage({super.key});

  @override
  State<KnowledgeListPage> createState() => _KnowledgeListPageState();
}

class _KnowledgeListPageState extends State<KnowledgeListPage> {
  /// 文章数据仓库
  final ArticleRepository _repository = ArticleRepository();

  /// 文章列表数据
  List<Article> _articles = [];

  /// 加载状态
  bool _isLoading = true;

  /// 错误信息（为空表示无错误）
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  /// 加载文章列表数据
  ///
  /// 从服务器获取科普文章列表，更新页面状态
  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: 调用 ArticleRepository.getArticleList() 获取文章列表
      // 数据层组员已实现该接口，直接调用即可
      final articles = await _repository.getArticleList();

      if (mounted) {
        setState(() {
          _articles = articles;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = '加载失败，请下拉重试';
        });
      }
    }
  }

  /// 跳转到文章详情页
  ///
  /// [article] 要查看的文章对象
  void _navigateToDetail(Article article) {
    // 通过命名路由跳转，携带文章对象作为参数
    Navigator.pushNamed(
      context,
      AppRoutes.knowledgeDetail,
      arguments: article,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('健康科普'),
        centerTitle: true,
      ),
      body: _buildBody(theme),
    );
  }

  /// 构建页面主体
  ///
  /// 根据当前状态显示不同的内容：加载中、错误提示或文章列表
  Widget _buildBody(ThemeData theme) {
    // 加载中状态
    if (_isLoading && _articles.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 错误状态（且列表为空）
    if (_errorMessage != null && _articles.isEmpty) {
      return Center(
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
              _errorMessage!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loadArticles,
              icon: const Icon(Icons.refresh),
              label: const Text('重新加载'),
            ),
          ],
        ),
      );
    }

    // 空列表状态
    if (_articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无科普文章',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    // 文章列表（支持下拉刷新）
    return RefreshIndicator(
      onRefresh: _loadArticles,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return _buildArticleItem(theme, article);
        },
      ),
    );
  }

  /// 构建单个文章列表项
  ///
  /// [theme] 主题数据
  /// [article] 文章对象
  Widget _buildArticleItem(ThemeData theme, Article article) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToDetail(article),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 文章标题
              Text(
                article.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // 发布时间
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    article.publishTime,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
