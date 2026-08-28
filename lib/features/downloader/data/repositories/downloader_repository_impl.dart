import '../../domain/models/video_info.dart';
import '../../domain/repositories/downloader_repository.dart';
import '../datasources/downloader_api_source.dart';

class DownloaderRepositoryImpl implements DownloaderRepository {
  final DownloaderApiSource _apiSource;

  DownloaderRepositoryImpl(this._apiSource);

  @override
  Future<VideoInfo> extractVideoInfo(String url) {
    return _apiSource.extractVideoInfo(url);
  }
}
