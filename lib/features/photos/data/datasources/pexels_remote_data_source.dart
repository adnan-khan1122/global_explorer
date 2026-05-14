import 'package:dio/dio.dart';

import '../../../../core/config/app_env.dart';

class PexelsRemoteDataSource {
  PexelsRemoteDataSource({required this.dio});

  final Dio dio;
  static const _searchUrl = 'https://api.pexels.com/v1/search';

  Future<String?> searchLandscapePhoto(String query) async {
    final key = AppEnv.pexelsApiKey.trim();
    if (key.isEmpty || query.trim().isEmpty) return null;
    try {
      final response = await dio.get<Map<String, dynamic>>(
        _searchUrl,
        queryParameters: {
          'query': query.trim(),
          'per_page': 1,
          'orientation': 'landscape',
        },
        options: Options(headers: <String, dynamic>{'Authorization': key}),
      );
      final photos = response.data?['photos'] as List<dynamic>?;
      if (photos == null || photos.isEmpty) return null;
      final first = photos.first as Map<String, dynamic>;
      final src = first['src'] as Map<String, dynamic>?;
      if (src == null) return null;
      return src['large2x'] as String? ??
          src['large'] as String? ??
          src['medium'] as String?;
    } on DioException catch (_) {
      return null;
    }
  }
}
