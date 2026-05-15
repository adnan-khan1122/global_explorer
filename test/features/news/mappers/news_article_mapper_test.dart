import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/features/news/data/mappers/news_article_mapper.dart';
import 'package:global_explorer/features/news/data/models/news_article_dto.dart';
import 'package:global_explorer/features/news/domain/entities/news_article.dart';

import '../../../fixtures.dart';


void main() {
  group('NewsArticleMapper.toEntity', () {
    test('maps all fields correctly from DTO', () {
      final entity = NewsArticleMapper.toEntity(tNewsArticleDto);

      expect(entity.title, 'Germany wins the match');
      expect(entity.url, 'https://news.example.com/article/1');
      expect(entity.description, 'A great football match.');
      expect(entity.urlToImage, 'https://news.example.com/img/1.jpg');
      expect(entity.publishedAt, '2026-05-14T00:00:00Z');
      expect(entity.sourceName, 'Example News');
    });

    test('returns a NewsArticle instance', () {
      expect(NewsArticleMapper.toEntity(tNewsArticleDto), isA<NewsArticle>());
    });
  });

  group('NewsArticleDto.fromNewsApiJson', () {
    test('parses valid JSON correctly', () {
      final dto = NewsArticleDto.fromNewsApiJson(tNewsApiJson);

      expect(dto, isNotNull);
      expect(dto!.title, 'Germany wins the match');
      expect(dto.sourceName, 'Example News');
    });

    test('returns null when title is missing', () {
      final json = Map<String, dynamic>.from(tNewsApiJson)..remove('title');
      expect(NewsArticleDto.fromNewsApiJson(json), isNull);
    });

    test('returns null when url is missing', () {
      final json = Map<String, dynamic>.from(tNewsApiJson)..remove('url');
      expect(NewsArticleDto.fromNewsApiJson(json), isNull);
    });

    test('returns null when title is empty string', () {
      final json = Map<String, dynamic>.from(tNewsApiJson)
        ..['title'] = '';
      expect(NewsArticleDto.fromNewsApiJson(json), isNull);
    });

    test('handles missing optional fields gracefully', () {
      final json = <String, dynamic>{
        'title': 'Headline',
        'url': 'https://example.com',
      };
      final dto = NewsArticleDto.fromNewsApiJson(json);
      expect(dto, isNotNull);
      expect(dto!.description, isNull);
      expect(dto.sourceName, isNull);
    });
  });
}
