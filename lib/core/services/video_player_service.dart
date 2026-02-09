import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/content.dart';

/// Video Player Service
/// يدير تشغيل الفيديو مع دعم البث المباشر والـ HTTP Referrer
class VideoPlayerService {
  BetterPlayerController? _controller;
  
  /// إنشاء مشغل فيديو للمحتوى
  BetterPlayerController createPlayer({
    required Content content,
    bool autoPlay = true,
    bool looping = false,
    bool showControls = true,
  }) {
    // إذا كان هناك مشغل سابق، قم بإيقافه
    disposePlayer();
    
    // تحديد رابط البث الأساسي
    final streamUrl = content.streamingUrls.isNotEmpty
        ? content.streamingUrls.first
        : null;
    
    if (streamUrl == null) {
      throw Exception('لا يوجد رابط بث متاح');
    }
    
    // إعداد البيانات المصدرية
    final dataSource = BetterPlayerDataSource(
      content.isLive 
          ? BetterPlayerDataSourceType.network
          : BetterPlayerDataSourceType.network,
      streamUrl.url,
      headers: _buildHeaders(streamUrl),
      useAsmsSubtitles: true,
      useAsmsTracks: true,
      useAsmsAudioTracks: true,
      liveStream: content.isLive,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: content.title,
        author: content.category ?? 'ToTV+',
      ),
    );
    
    // إعدادات المشغل
    final configuration = BetterPlayerConfiguration(
      autoPlay: autoPlay,
      looping: looping,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enablePlayPause: true,
        enableMute: true,
        enableFullscreen: true,
        enableProgressBar: !content.isLive,
        enableProgressText: !content.isLive,
        enablePlaybackSpeed: !content.isLive,
        enableSkips: !content.isLive,
        enableSubtitles: !content.isLive,
        enableQualities: true,
        enablePip: true,
        enableRetry: true,
        showControls: showControls,
        controlsHideTime: const Duration(seconds: 5),
        liveTextColor: Colors.red,
        loadingColor: Colors.orange,
        overflowModalColor: Colors.black87,
        iconsColor: Colors.white,
        textColor: Colors.white,
      ),
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      placeholder: _buildPlaceholder(content),
      errorBuilder: (context, errorMessage) {
        return _buildErrorWidget(errorMessage);
      },
    );
    
    _controller = BetterPlayerController(configuration);
    _controller!.setupDataSource(dataSource);
    
    return _controller!;
  }
  
  /// بناء الـ Headers مع دعم HTTP Referrer
  Map<String, String> _buildHeaders(StreamingUrl streamUrl) {
    final headers = <String, String>{
      'User-Agent': 'ToTV+/1.0.0 (Android)',
      'Accept': '*/*',
      'Connection': 'keep-alive',
    };
    
    // إضافة HTTP Referrer إذا كان موجوداً
    if (streamUrl.httpReferrer != null) {
      headers['Referer'] = streamUrl.httpReferrer!;
      headers['Origin'] = _extractOrigin(streamUrl.httpReferrer!);
    }
    
    // إضافة Headers إضافية
    if (streamUrl.headers != null) {
      headers.addAll(streamUrl.headers!);
    }
    
    return headers;
  }
  
  /// استخراج الـ Origin من الـ Referrer
  String _extractOrigin(String referrer) {
    try {
      final uri = Uri.parse(referrer);
      return '${uri.scheme}://${uri.host}';
    } catch (e) {
      return referrer;
    }
  }
  
  /// بناء شاشة التحميل
  Widget _buildPlaceholder(Content content) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (content.imageUrl != null)
              Image.network(
                content.imageUrl!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.tv,
                    size: 100,
                    color: Colors.white54,
                  );
                },
              ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            const SizedBox(height: 20),
            Text(
              'جاري تحميل ${content.title}...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// بناء شاشة الخطأ
  Widget _buildErrorWidget(String? errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'حدث خطأ في التشغيل',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage ?? 'غير معروف',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _controller?.retryDataSource();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// الحصول على المشغل الحالي
  BetterPlayerController? get controller => _controller;
  
  /// تشغيل الفيديو
  void play() {
    _controller?.play();
  }
  
  /// إيقاف الفيديو مؤقتاً
  void pause() {
    _controller?.pause();
  }
  
  /// إيقاف وتحرير الموارد
  void disposePlayer() {
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
  }
  
  /// التحقق من حالة التشغيل
  bool get isPlaying => _controller?.isPlaying() ?? false;
  
  /// التحقق من حالة البافر
  bool get isBuffering => _controller?.isBuffering() ?? false;
}
