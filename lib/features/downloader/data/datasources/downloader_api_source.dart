import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/video_info.dart';

class DownloaderApiSource {
  final DioClient _dioClient;

  DownloaderApiSource(this._dioClient);

  Future<VideoInfo> extractVideoInfo(String url) async {
    try {
      final response = await _dioClient.dio.post(
        'extract',
        data: {'url': url},
      );
      
      if (response.statusCode == 200) {
        return VideoInfo.fromJson(response.data);
      } else {
        throw Exception('Failed to extract video: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null && e.response?.data != null) {
           throw Exception(e.response?.data['detail'] ?? e.message);
        }
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Unexpected error: $e');
    }
  }
}
