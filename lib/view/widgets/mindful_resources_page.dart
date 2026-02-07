import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_space/model/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cText.dart';

class VideoResource {
  final String id;
  final String name;
  final String url;
  final String lang;

  VideoResource({
    required this.id,
    required this.name,
    required this.url,
    required this.lang,
  });

  factory VideoResource.fromFirestore(String docId, Map<String, dynamic> data) {
    return VideoResource(
      id: docId,
      name: data['name'] ?? 'Untitled',
      url: data['url'] ?? '',
      lang: data['lang'] ?? 'Unknown',
    );
  }
}

class MindfulResourcesPage extends StatefulWidget {
  const MindfulResourcesPage({Key? key}) : super(key: key);

  @override
  State<MindfulResourcesPage> createState() => _MindfulResourcesPageState();
}

class _MindfulResourcesPageState extends State<MindfulResourcesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<VideoResource>> _fetchVideos() async {
    try {
      final snap = await _firestore
          .collection('resources')
          .doc('videos')
          .collection('videos')
          .get();

      print('VIDEOS FOUND: ${snap.docs.length}');

      return snap.docs
          .map((doc) => VideoResource.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching videos: $e');
      rethrow;
    }
  }

  Future<void> _launchURL(String url) async {
    final cleanedUrl = url.trim();

    final uri = Uri.tryParse(cleanedUrl);
    if (uri == null) {
      _showError();
      return;
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showError();
    }
  }

  void _showError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open this resource'),
        backgroundColor: AppColors.brown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
        ),
        toolbarHeight: 75,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [cText(fontSize: 30, text: "Mindful Resources")],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
        backgroundColor: AppColors.mediumBrown,
      ),
      backgroundColor: AppColors.lightestBrowm.withOpacity(0.3),
      body: SafeArea(
        child: FutureBuilder<List<VideoResource>>(
          future: _fetchVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.mediumBrown),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.lightBrown.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Something went wrong',
                      style: TextStyle(color: AppColors.brown, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            final videos = snapshot.data ?? [];

            if (videos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_library_outlined,
                      size: 48,
                      color: AppColors.lightBrown.withOpacity(0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No resources yet',
                      style: TextStyle(color: AppColors.brown, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back soon for mindful content',
                      style: TextStyle(
                        color: AppColors.lightBrown.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Short videos to help you pause, breathe, and reset',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                if (videos.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildFeaturedCard(
                        context,
                        videos[0],
                        media.width,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 28)),

                if (videos.length > 1)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: Text(
                        'More Resources',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                if (videos.length > 1)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final video = videos[index + 1];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildVideoCard(context, video),
                        );
                      }, childCount: videos.length - 1),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(
    BuildContext context,
    VideoResource video,
    double width,
  ) {
    return GestureDetector(
      onTap: () => _launchURL(video.url),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.brown.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.mediumBrown.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      size: 48,
                      color: AppColors.mediumBrown.withOpacity(0.6),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Featured Video',
                      style: TextStyle(
                        color: AppColors.mediumBrown.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Text(
                      video.lang,
                      style: TextStyle(
                        color: AppColors.mediumBrown,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    video.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Tap to watch',
                    style: TextStyle(
                      color: AppColors.mediumBrown.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoResource video) {
    return GestureDetector(
      onTap: () => _launchURL(video.url),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.brown.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.mediumBrown.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 32,
                  color: AppColors.mediumBrown.withOpacity(0.5),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      video.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.brown,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.lang,
                      style: TextStyle(
                        color: AppColors.lightestBrowm,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.mediumBrown.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
