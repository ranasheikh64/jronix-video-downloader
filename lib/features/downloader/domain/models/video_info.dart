class VideoFormat {
  final String quality;
  final String resolution;
  final String url;
  final String ext;

  VideoFormat({
    required this.quality,
    required this.resolution,
    required this.url,
    required this.ext,
  });

  factory VideoFormat.fromJson(Map<String, dynamic> json) {
    return VideoFormat(
      quality: json['quality'] ?? 'Unknown',
      resolution: json['resolution'] ?? 'Unknown',
      url: json['url'] ?? '',
      ext: json['ext'] ?? 'mp4',
    );
  }
}

class VideoInfo {
  final bool success;
  final String platform;
  final String? title;
  final String? thumbnail;
  final double? duration;
  final List<VideoFormat> formats;
  final String? errorMessage;

  VideoInfo({
    required this.success,
    required this.platform,
    this.title,
    this.thumbnail,
    this.duration,
    required this.formats,
    this.errorMessage,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    var list = json['formats'] as List? ?? [];
    List<VideoFormat> formatsList = list.map((i) => VideoFormat.fromJson(i)).toList();

    return VideoInfo(
      success: json['success'] ?? false,
      platform: json['platform'] ?? 'unknown',
      title: json['title'],
      thumbnail: json['thumbnail'],
      duration: (json['duration'] as num?)?.toDouble(),
      formats: formatsList,
      errorMessage: json['error_message'],
    );
  }
}
