import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/models/video_info.dart';
import '../../domain/repositories/downloader_repository.dart';

class DownloaderController extends GetxController with WidgetsBindingObserver {
  final DownloaderRepository _repository;

  DownloaderController(this._repository);

  final urlController = TextEditingController();
  final RxString currentUrl = ''.obs;
  final RxBool isLoading = false.obs;
  final Rxn<VideoInfo> videoInfo = Rxn<VideoInfo>();
  final Rxn<VideoFormat> selectedFormat = Rxn<VideoFormat>();
  final RxString errorMessage = ''.obs;
  final RxString activePlatform = 'Facebook'.obs;

  // Download state
  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final RxString downloadStatus = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    urlController.addListener(() {
      currentUrl.value = urlController.text;
    });

    // Web is not supported for background_downloader
    if (kIsWeb) return;

    // Configure downloader updates
    FileDownloader().updates.listen((update) async {
      if (update is TaskStatusUpdate) {
        if (update.status == TaskStatus.complete) {
          isDownloading.value = false;
          final filePath = await update.task.filePath();
          final customDir = update.task.metaData;

          if (customDir.isNotEmpty) {
            try {
              final newPath = '$customDir/${update.task.filename}';
              await File(filePath).copy(newPath);
              downloadStatus.value =
                  'Download Complete! Saved to custom folder.';
              Get.snackbar('Success', 'Video saved successfully!');
            } catch (e) {
              downloadStatus.value = 'Failed to save to selected folder.';
            }
          } else {
            try {
              await Gal.putVideo(filePath);
              downloadStatus.value = 'Download Complete! Saved to Gallery.';
            } catch (e) {
              downloadStatus.value = 'Failed to save to Gallery.';
            }
          }
        } else if (update.status == TaskStatus.canceled) {
          isDownloading.value = false;
          downloadStatus.value = 'Download Canceled';
        } else if (update.status == TaskStatus.failed) {
          isDownloading.value = false;
          downloadStatus.value = 'Download Failed';
        }
      } else if (update is TaskProgressUpdate) {
        downloadProgress.value = update.progress;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    checkClipboardForLink();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkClipboardForLink();
    }
  }

  void changePlatform(String platform) {
    if (activePlatform.value == platform) return;
    activePlatform.value = platform;
    urlController.clear();
    videoInfo.value = null;
    selectedFormat.value = null;
    errorMessage.value = '';
    isDownloading.value = false;
    downloadStatus.value = '';
  }

  Future<void> checkClipboardForLink() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final text = clipboardData?.text?.trim() ?? '';

      if (text.isEmpty || !text.startsWith('http')) return;

      // Check if it's already in the text field
      if (urlController.text.trim() == text) return;

      final uri = Uri.tryParse(text);
      if (uri == null || !uri.hasPort) return;

      final host = uri.host.toLowerCase();
      String? detectedPlatform;

      if (host.contains('facebook.com') ||
          host.contains('fb.watch') ||
          host.contains('fb.com') ||
          host.contains('fb.gg')) {
        detectedPlatform = 'Facebook';
      } else if (host.contains('tiktok.com') ||
          host.contains('iesdouyin.com')) {
        detectedPlatform = 'TikTok';
      } else if (host.contains('instagram.com')) {
        detectedPlatform = 'Instagram';
      }

      if (detectedPlatform != null) {
        changePlatform(detectedPlatform);
        urlController.text = text;
        Get.snackbar(
          'Link Detected',
          'Pasted $detectedPlatform link from clipboard',
          duration: const Duration(seconds: 2),
        );
        extractVideo();
      }
    } catch (e) {
      // Ignore clipboard errors
    }
  }

  Future<void> pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final text = clipboardData?.text?.trim() ?? '';
      if (text.isNotEmpty) {
        urlController.text = text;
        checkClipboardForLink();
        if (text.startsWith('http')) {
          extractVideo();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not read clipboard');
    }
  }

  bool _isValidUrl(String url, String platform) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) return false;

    final host = uri.host.toLowerCase();
    switch (platform.toLowerCase()) {
      case 'facebook':
        return host.contains('facebook.com') ||
            host.contains('fb.watch') ||
            host.contains('fb.com');
      case 'instagram':
        return host.contains('instagram.com');
      case 'tiktok':
        return host.contains('tiktok.com') || host.contains('iesdouyin.com');
      default:
        return true;
    }
  }

  void extractVideo() async {
    final url = urlController.text.trim();
    if (url.isEmpty) {
      errorMessage.value = 'Please enter a video link first.';
      return;
    }

    // Smart Platform Detector
    if (!_isValidUrl(url, activePlatform.value)) {
      // Try to find if it matches another platform
      String? detectedPlatform;
      if (_isValidUrl(url, 'Facebook')) {
        detectedPlatform = 'Facebook';
      } else if (_isValidUrl(url, 'TikTok')) {
        // ignore: curly_braces_in_flow_control_structures
        detectedPlatform = 'TikTok';
      } else if (_isValidUrl(url, 'Instagram')) {
        // ignore: curly_braces_in_flow_control_structures
        detectedPlatform = 'Instagram';
      }

      if (detectedPlatform != null) {
        changePlatform(detectedPlatform);
        // Get.snackbar(
        //   'Platform Switched',
        //   'Auto-detected $detectedPlatform link',
        //   duration: const Duration(seconds: 1),
        // );
      } else {
        errorMessage.value =
            'Please enter a valid video link for supported platforms.';
        return;
      }
    }

    isLoading.value = true;
    errorMessage.value = '';
    videoInfo.value = null;

    try {
      final info = await _repository.extractVideoInfo(url);
      videoInfo.value = info;
      if (info.formats.isNotEmpty) {
        selectedFormat.value = info.formats.first;
      } else {
        selectedFormat.value = null;
      }
    } catch (e) {
      String msg = e.toString();
      if (msg.startsWith('Exception: ')) {
        msg = msg.substring(11);
      }
      errorMessage.value = msg.isNotEmpty
          ? msg
          : 'Failed to extract video. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadVideo(
    VideoFormat format,
    String title, {
    bool saveAs = false,
  }) async {
    if (kIsWeb) {
      final uri = Uri.parse(format.url);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        Get.snackbar('Notice', 'Opening video in browser for download.');
      } catch (e) {
        Get.snackbar('Error', 'Could not open video URL');
      }
      return;
    }

    String customDirectory = '';
    if (saveAs) {
      final selectedDir = await FilePicker.getDirectoryPath();
      if (selectedDir == null) return; // User canceled
      customDirectory = selectedDir;
    } else {
      bool hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess(toAlbum: true);
      }
      if (!hasAccess) {
        Get.snackbar('Error', 'Storage permission required to save to gallery');
        return;
      }
    }

    isDownloading.value = true;
    downloadProgress.value = 0;
    downloadStatus.value = 'Downloading...';

    try {
      await getApplicationDocumentsDirectory();

      final safeTitle = title.replaceAll(RegExp(r'[^a-zA-Z0-9_\-\.]'), '_');
      final fileName = '${safeTitle}_${format.quality}.${format.ext}';

      final task = DownloadTask(
        url: format.url,
        filename: fileName,
        directory: 'downloads', // Subdirectory in app docs
        baseDirectory: BaseDirectory.applicationDocuments,
        metaData: customDirectory,
        updates: Updates.statusAndProgress,
        retries: 3,
        allowPause: true,
      );

      await FileDownloader().enqueue(task);
    } catch (e) {
      isDownloading.value = false;
      downloadStatus.value = 'Failed to start download';
      Get.snackbar('Error', e.toString());
    }
  }
}
