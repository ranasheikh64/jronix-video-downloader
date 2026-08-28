import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HowToScreen extends StatelessWidget {
  const HowToScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('How to Download'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to download videos?',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                Text(
                  '1. Copy the video URL from Facebook, Instagram, or TikTok.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 12),
                Text(
                  '2. Paste the URL into the search box on the home page.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 12),
                Text(
                  '3. Click the "Download" button to extract the video.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 12),
                Text(
                  '4. Select your preferred video quality from the dropdown.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 12),
                Text(
                  '5. Click the final "Download" button to save it to your device.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
