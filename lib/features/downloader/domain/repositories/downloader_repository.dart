import '../models/video_info.dart';

abstract class DownloaderRepository {
  Future<VideoInfo> extractVideoInfo(String url);
}
