import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/news_article.dart';

class NewsArticleCard extends StatelessWidget {
  const NewsArticleCard({super.key, required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(article.title),
        subtitle: article.description != null
            ? Text(
                article.description!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            : (article.sourceName != null ? Text(article.sourceName!) : null),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          final u = Uri.parse(article.url);
          if (await canLaunchUrl(u)) {
            await launchUrl(u, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }
}
