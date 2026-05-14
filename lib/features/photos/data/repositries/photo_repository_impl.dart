import '../../domain/repositories/photo_repository.dart';
import '../datasources/pexels_remote_data_source.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl({required PexelsRemoteDataSource remote})
    : _remote = remote;

  final PexelsRemoteDataSource _remote;

  @override
  Future<String?> searchHeroPhoto(String query) =>
      _remote.searchLandscapePhoto(query);
}
