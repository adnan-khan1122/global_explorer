import 'package:dio/dio.dart';

import '../../../../core/config/app_env.dart';
import '../models/news_article_dto.dart';

class NewsRemoteDataSource {
  NewsRemoteDataSource({required this.dio});

  final Dio dio;
  static const _base = 'https://newsapi.org/v2';

  Future<List<NewsArticleDto>> fetchTopHeadlinesByCountry({
    required String cca2,
    int pageSize = 10,
  }) async {
    final key = AppEnv.newsApiKey.trim();
    if (key.isEmpty) return const [];
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '$_base/top-headlines',
        queryParameters: {
          'country': cca2.toLowerCase(),
          'pageSize': pageSize,
          'apiKey': key,
        },
      );
      final data = response.data;
      if (data == null || data['status'] != 'ok') return [];
      final articles = data['articles'] as List<dynamic>? ?? [];
      final out = <NewsArticleDto>[];
      for (final raw in articles) {
        if (raw is Map<String, dynamic>) {
          final a = NewsArticleDto.fromNewsApiJson(raw);
          if (a != null) out.add(a);
        }
      }
      return out;
    } on DioException catch (_) {
      return const [];
    }
  }
}
