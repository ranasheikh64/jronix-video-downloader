import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_download/features/downloader/presentation/controllers/downloader_controller.dart';
import '../../domain/models/video_info.dart';

class DownloaderScreen extends GetView<DownloaderController> {
  const DownloaderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final isMobile = MediaQuery.of(context).size.width < 650;

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: _buildDrawer(scrollController),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              // Top Navigation Bar
              _buildNavBar(context, scrollController, isMobile),
              
              if (kIsWeb)
                Container(
                  width: double.infinity,
                  color: const Color(0xFFEFF6FF),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'For the best experience, download our Mobile App!',
                            style: TextStyle(
                              color: Color(0xFF1E3A8A),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          const link = 'YOUR_DRIVE_APK_LINK_HERE';
                          if (link.contains('YOUR_DRIVE_APK_LINK_HERE') || link.isEmpty) {
                            Get.snackbar('Coming Soon', 'Our mobile app is launching very soon!', backgroundColor: Colors.blue, colorText: Colors.white);
                            return;
                          }
                          final uri = Uri.tryParse(link);
                          if (uri != null && uri.hasScheme) {
                            launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            Get.snackbar('Coming Soon', 'Our mobile app is launching very soon!', backgroundColor: Colors.blue, colorText: Colors.white);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Text('Download', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

              _buildDivider(),
              const SizedBox(height: 16),

              // Breadcrumbs
              _buildBreadcrumbs(),
              const SizedBox(height: 60),

              // Main Content Area
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 750),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // Title
                        Obx(
                          () => Text(
                            '${controller.activePlatform.value} Video Downloader',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Search Box
                        _buildSearchBox(isMobile),
                        const SizedBox(height: 12),

                        // Terms Text
                        const Text(
                          'By using our service you accept our Terms of Service and Privacy Policy',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        _buildErrorSection(),
                        _buildResultSection(),
                        _buildProgressSection(),

                        const SizedBox(height: 80),
                        _buildDivider(),
                        const SizedBox(height: 80),

                        // How To Section
                        _buildHowToSection(),

                        const SizedBox(height: 80),
                        _buildFooter(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(color: Color(0xFFEEEEEE), height: 1),
        const SizedBox(height: 32),
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200, width: 2),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/company_logo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '© 2026 Jronix Software Solutions. All rights reserved.',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Built with ❤️ for Fast & Secure Downloads',
          style: TextStyle(color: Color(0xFF999999), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildNavBar(
    BuildContext context,
    ScrollController scrollController,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 12 : 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/app_logo_new.jpg',
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.video_library,
                      color: Color(0xFF2563EB),
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Jronix VideoDownloader',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            Obx(
              () => Row(
                children: [
                  _navLink(
                    'Facebook',
                    controller.activePlatform.value == 'Facebook',
                    scrollController,
                  ),
                  _navLink(
                    'Instagram',
                    controller.activePlatform.value == 'Instagram',
                    scrollController,
                  ),
                  _navLink(
                    'TikTok',
                    controller.activePlatform.value == 'TikTok',
                    scrollController,
                  ),
                  _navLink('How to', false, scrollController),
                  if (kIsWeb) ...[
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        const link = 'YOUR_DRIVE_APK_LINK_HERE';
                        if (link.contains('YOUR_DRIVE_APK_LINK_HERE') || link.isEmpty) {
                          Get.snackbar('Coming Soon', 'Our mobile app is launching very soon!', backgroundColor: Colors.blue, colorText: Colors.white);
                          return;
                        }
                        final uri = Uri.tryParse(link);
                        if (uri != null && uri.hasScheme) {
                          launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          Get.snackbar('Coming Soon', 'Our mobile app is launching very soon!', backgroundColor: Colors.blue, colorText: Colors.white);
                        }
                      },
                      icon: const Icon(Icons.android, color: Colors.white, size: 20),
                      label: const Text('Download App', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          if (isMobile)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.grey),
                onPressed: () {
                  Scaffold.of(ctx).openEndDrawer();
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawer(ScrollController scrollController) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/app_logo_new.jpg',
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.video_library,
                        color: Color(0xFF2563EB),
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Jronix VideoDownloader',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
            _drawerLink(
              'Facebook',
              controller.activePlatform.value == 'Facebook',
              scrollController,
            ),
            _drawerLink(
              'Instagram',
              controller.activePlatform.value == 'Instagram',
              scrollController,
            ),
            _drawerLink(
              'TikTok',
              controller.activePlatform.value == 'TikTok',
              scrollController,
            ),
            const Divider(),
            _drawerLink('How to', false, scrollController),
            if (kIsWeb) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.android, color: Color(0xFF2563EB)),
                title: const Text('Download Mobile App', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                onTap: () {
                  Get.back(); // close drawer
                  const link = 'YOUR_DRIVE_APK_LINK_HERE';
                  if (link.contains('YOUR_DRIVE_APK_LINK_HERE') || link.isEmpty) {
                    Get.snackbar('Coming Soon', 'Our mobile app is launching very soon!', backgroundColor: Colors.blue, colorText: Colors.white);
                    return;
                  }
                  final uri = Uri.tryParse(link);
                  if (uri != null && uri.hasScheme) {
                    launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    Get.snackbar('Coming Soon', 'Our mobile app is launching very soon!', backgroundColor: Colors.blue, colorText: Colors.white);
                  }
                },
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _drawerLink(
    String title,
    bool isActive,
    ScrollController scrollController,
  ) {
    return ListTile(
      leading: Icon(
        title == 'How to' ? Icons.help_outline : Icons.link,
        color: isActive ? const Color(0xFF2563EB) : const Color(0xFF666666),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          color: isActive ? const Color(0xFF2563EB) : const Color(0xFF666666),
        ),
      ),
      selected: isActive,
      onTap: () {
        Get.back(); // Close the drawer
        if (title == 'How to') {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
        } else {
          controller.changePlatform(title);
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  Widget _navLink(
    String title,
    bool isActive,
    ScrollController scrollController,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: InkWell(
        onTap: () {
          if (title == 'How to') {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
            );
          } else {
            controller.changePlatform(title);
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? const Color(0xFF2563EB) : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildBreadcrumbs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Text(
            'Home',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Obx(
            () => Text(
              'Download from ${controller.activePlatform.value}',
              style: const TextStyle(color: Color(0xFF333333), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox(bool isMobile) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF2563EB),
          width: 3,
        ), // Blue border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => TextField(
                controller: controller.urlController,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText:
                      'Paste your ${controller.activePlatform.value} video link here',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 24,
                    vertical: 16,
                  ),
                  suffixIcon: Obx(() => controller.currentUrl.value.isEmpty
                      ? TextButton.icon(
                          onPressed: controller.pasteFromClipboard,
                          icon: const Icon(Icons.content_paste, color: Color(0xFF2563EB)),
                          label: const Text('Paste', style: TextStyle(color: Color(0xFF2563EB))),
                        )
                      : IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            controller.urlController.clear();
                          },
                        )),
                ),
              ),
            ),
          ),
          Obx(
            () => Container(
              height: double.infinity,
              width: isMobile ? 100 : 140,
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB), // Blue button
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.isLoading.value
                      ? null
                      : controller.extractVideo,
                  child: Center(
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Download',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 15 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection() {
    return Obx(() {
      if (controller.errorMessage.value.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF87171).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Color(0xFF991B1B)),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildResultSection() {
    return Obx(() {
      final info = controller.videoInfo.value;
      if (info == null) return const SizedBox.shrink();

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            // Image Widget
            final imageWidget = info.thumbnail != null
                ? Image.network(
                    info.thumbnail!,
                    height: isWide ? 220 : 200,
                    width: isWide ? 260 : double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(isWide),
                  )
                : _buildPlaceholder(isWide);

            // Details Widget
            final detailsWidget = Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.title ?? '${controller.activePlatform.value} Video',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Duration: ${(info.duration ?? 0).toInt()}s',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Select Format:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (info.formats.isEmpty)
                    const Text(
                      'No formats found.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    _buildDropdownFormatSelector(info, isWide),
                ],
              ),
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageWidget,
                  Expanded(child: detailsWidget),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [imageWidget, detailsWidget],
              );
            }
          },
        ),
      );
    });
  }

  Widget _buildPlaceholder(bool isWide) {
    return Container(
      height: isWide ? 220 : 200,
      width: isWide ? 260 : double.infinity,
      color: Colors.grey[200],
      child: const Icon(Icons.video_file, size: 64, color: Colors.grey),
    );
  }

  Widget _buildDropdownFormatSelector(VideoInfo info, bool isWide) {
    final dropdown = Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VideoFormat>(
          value: controller.selectedFormat.value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: info.formats.map((format) {
            return DropdownMenuItem<VideoFormat>(
              value: format,
              child: Text('${format.quality} - ${format.ext.toUpperCase()}'),
            );
          }).toList(),
          onChanged: (VideoFormat? newFormat) {
            if (newFormat != null) {
              controller.selectedFormat.value = newFormat;
            }
          },
        ),
      ),
    );

    final buttons = SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: controller.isDownloading.value
                  ? null
                  : () {
                      final format = controller.selectedFormat.value;
                      if (format != null) {
                        controller.downloadVideo(
                          format,
                          info.title ?? 'video',
                          saveAs: false,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: controller.isDownloading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const FittedBox(
                      child: Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.isDownloading.value
                  ? null
                  : () {
                      final format = controller.selectedFormat.value;
                      if (format != null) {
                        controller.downloadVideo(
                          format,
                          info.title ?? 'video',
                          saveAs: true,
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2563EB),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: Color(0xFF2563EB)),
                ),
              ),
              child: controller.isDownloading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFF2563EB),
                        strokeWidth: 2,
                      ),
                    )
                  : const FittedBox(
                      child: Text(
                        'Save As...',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );

    if (isWide) {
      return Row(
        children: [
          Expanded(flex: 3, child: dropdown),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: buttons),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [dropdown, const SizedBox(height: 12), buttons],
      );
    }
  }

  Widget _buildProgressSection() {
    return Obx(() {
      if (!controller.isDownloading.value &&
          controller.downloadStatus.value.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.cloud_download_rounded,
                  color: Color(0xFF2563EB),
                  size: 28,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    controller.downloadStatus.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ],
            ),
            if (controller.isDownloading.value) ...[
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: controller.downloadProgress.value > 0
                      ? controller.downloadProgress.value
                      : null,
                  backgroundColor: const Color(0xFFE5E7EB),
                  color: const Color(0xFF2563EB),
                  minHeight: 8,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildHowToSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How to download videos?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 32),
          _buildHowToStep(
            '1',
            'Copy the video URL from Facebook, Instagram, or TikTok.',
          ),
          _buildHowToStep(
            '2',
            'Paste the URL into the search box on the home page.',
          ),
          _buildHowToStep(
            '3',
            'Click the "Download" button to extract the video.',
          ),
          _buildHowToStep(
            '4',
            'Select your preferred video quality from the dropdown.',
          ),
          _buildHowToStep(
            '5',
            'Click the final "Download" button to save it to your device.',
          ),
        ],
      ),
    );
  }

  Widget _buildHowToStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4B5563),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
