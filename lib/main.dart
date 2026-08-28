import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/network/dio_client.dart';
import 'features/downloader/data/datasources/downloader_api_source.dart';
import 'features/downloader/data/repositories/downloader_repository_impl.dart';
import 'features/downloader/domain/repositories/downloader_repository.dart';
import 'features/downloader/presentation/controllers/downloader_controller.dart';
import 'features/downloader/presentation/screens/downloader_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _setupDependencies();
  runApp(const MyApp());
}

void _setupDependencies() {
  // Core
  Get.lazyPut(() => DioClient());

  // Data
  Get.lazyPut(() => DownloaderApiSource(Get.find<DioClient>()));
  
  // Repository
  Get.lazyPut<DownloaderRepository>(() => DownloaderRepositoryImpl(Get.find<DownloaderApiSource>()));
  
  // Controller
  Get.lazyPut(() => DownloaderController(Get.find<DownloaderRepository>()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jronix Video Downloader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const DownloaderScreen(),
    );
  }
}
