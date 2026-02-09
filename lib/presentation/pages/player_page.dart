import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../domain/entities/content.dart';

class PlayerPage extends StatefulWidget {
  final Content content;

  const PlayerPage({Key? key, required this.content}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // 1. استخراج الرابط والـ Headers
      final streamingUrl = widget.content.streamingUrls.first;
      
      // 2. تهيئة المشغل مع الـ Headers اللازمة لتجاوز الحماية (JADX Logic)
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(streamingUrl.url),
        httpHeaders: streamingUrl.headers ?? {
          'User-Agent': 'ToTV_Plus_Android_2026',
          if (streamingUrl.httpReferrer != null) 'Referer': streamingUrl.httpReferrer!,
        },
      );

      await _videoPlayerController!.initialize();

      // 3. إعداد واجهة التحكم (Chewie)
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        isLive: widget.content.isLive,
        allowedScreenSleep: false,
        fullScreenByDefault: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        // تخصيص الألوان لتناسب ثيم ToTV+
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.orange,
          handleColor: Colors.orangeAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white30,
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'خطأ في تشغيل البث: $errorMessage',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      setState(() {});
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      debugPrint('Player Error: $e');
    }
  }

  @override
  void dispose() {
    // إعادة شريط الحالة والتحكم عند الخروج
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.content.title),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _hasError
            ? _buildErrorWidget()
            : _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.orange),
                      SizedBox(height: 20),
                      Text('جاري تجهيز البث المباشر...', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 80),
        const SizedBox(height: 20),
        const Text('عذراً، لا يمكن تشغيل هذا المحتوى حالياً', style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _hasError = false;
              _initializePlayer();
            });
          },
          child: const Text('إعادة المحاولة'),
        )
      ],
    );
  }
}
