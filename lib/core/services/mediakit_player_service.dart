import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/content.dart';

/// خدمة مشغل الفيديو باستخدام Media Kit
/// مع دعم HLS/DASH و Hardware Acceleration و Adaptive Bitrate
class MediaKitPlayerService {
  Player? _player;
  VideoController? _controller;
  
  /// إنشاء مشغل فيديو متقدم
  Future<VideoController> createPlayer({
    required Content content,
    bool autoPlay = true,
    bool enableHardwareAcceleration = true,
  }) async {
    // إيقاف المشغل السابق إن وجد
    await disposePlayer();
    
    // تحديد رابط البث
    final streamUrl = content.streamingUrls.isNotEmpty
        ? content.streamingUrls.first
        : null;
    
    if (streamUrl == null) {
      throw Exception('لا يوجد رابط بث متاح');
    }
    
    // إنشاء Player مع إعدادات متقدمة
    _player = Player(
      configuration: PlayerConfiguration(
        // تفعيل Hardware Acceleration إلزامياً
        vo: enableHardwareAcceleration ? 'gpu' : 'x11',
        
        // إعدادات الأداء
        hwdec: 'auto-safe', // Hardware Decoder تلقائي
        
        // Buffer settings لمنع التوقف
        bufferSize: 32 * 1024 * 1024, // 32MB buffer
        
        // Cache للبث المباشر
        cache: true,
        cacheSeconds: 60, // 60 ثانية cache
        
        // تحسينات الشبكة
        userAgent: 'ToTV+/2.0.0 (Android) ExoPlayer/1.3.1',
        
        // Adaptive Bitrate
        videoBitrate: null, // Auto-detect
        audioBitrate: null, // Auto-detect
        
        // تحسينات الصورة
        videoDecoder: 'auto',
        audioDecoder: 'auto',
        
        // Log level
        logLevel: MPVLogLevel.error,
      ),
    );
    
    // إنشاء Video Controller
    _controller = VideoController(_player!);
    
    // فتح رابط البث مع Headers
    await _player!.open(
      Media(
        streamUrl.url,
        httpHeaders: _buildHeaders(streamUrl),
      ),
      play: autoPlay,
    );
    
    // إعدادات إضافية للبث المباشر
    if (content.isLive) {
      await _player!.setPlaylistMode(PlaylistMode.none);
      await _player!.setAudioTrack(AudioTrack.auto());
      await _player!.setVideoTrack(VideoTrack.auto());
    }
    
    // ضبط مستوى الصوت
    await _player!.setVolume(100);
    
    return _controller!;
  }
  
  /// بناء Headers مع دعم HTTP Referrer
  Map<String, String> _buildHeaders(StreamingUrl streamUrl) {
    final headers = <String, String>{
      'User-Agent': 'ToTV+/2.0.0 (Android) ExoPlayer/1.3.1',
      'Accept': '*/*',
      'Accept-Encoding': 'identity;q=1, *;q=0',
      'Range': 'bytes=0-',
      'Connection': 'keep-alive',
    };
    
    // إضافة HTTP Referrer
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
  
  /// استخراج Origin من Referrer
  String _extractOrigin(String referrer) {
    try {
      final uri = Uri.parse(referrer);
      return '${uri.scheme}://${uri.host}';
    } catch (e) {
      return referrer;
    }
  }
  
  /// الحصول على المشغل
  Player? get player => _player;
  
  /// الحصول على Controller
  VideoController? get controller => _controller;
  
  /// تشغيل
  Future<void> play() async {
    await _player?.play();
  }
  
  /// إيقاف مؤقت
  Future<void> pause() async {
    await _player?.pause();
  }
  
  /// إيقاف وتحرير الموارد
  Future<void> disposePlayer() async {
    await _player?.pause();
    await _player?.dispose();
    _player = null;
    _controller = null;
  }
  
  /// تغيير الجودة (للبث التكيفي)
  Future<void> setQuality(String quality) async {
    if (_player == null) return;
    
    // هنا يمكن تنفيذ منطق تغيير الجودة
    // Media Kit يدعم Adaptive Bitrate تلقائياً
  }
  
  /// الحصول على حالة التشغيل
  bool get isPlaying => _player?.state.playing ?? false;
  
  /// الحصول على حالة البافر
  bool get isBuffering => _player?.state.buffering ?? false;
  
  /// الحصول على المدة
  Duration? get duration => _player?.state.duration;
  
  /// الحصول على الموضع الحالي
  Duration? get position => _player?.state.position;
  
  /// الانتقال إلى موضع
  Future<void> seek(Duration position) async {
    await _player?.seek(position);
  }
  
  /// تفعيل/تعطيل كتم الصوت
  Future<void> setMute(bool mute) async {
    await _player?.setVolume(mute ? 0 : 100);
  }
  
  /// ضبط السرعة
  Future<void> setSpeed(double speed) async {
    await _player?.setRate(speed);
  }
}

/// Widget المشغل مع تحسينات الأداء
class MediaKitPlayerWidget extends StatefulWidget {
  final VideoController controller;
  final Content content;

  const MediaKitPlayerWidget({
    Key? key,
    required this.controller,
    required this.content,
  }) : super(key: key);

  @override
  State<MediaKitPlayerWidget> createState() => _MediaKitPlayerWidgetState();
}

class _MediaKitPlayerWidgetState extends State<MediaKitPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Video(
      controller: widget.controller,
      
      // تحسينات الأداء
      fill: Colors.black,
      
      // دعم 120Hz
      // Media Kit يدعم معدلات التحديث العالية تلقائياً
      
      // Controls
      controls: (state) => _buildControls(state),
    );
  }
  
  Widget _buildControls(VideoState state) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header
          _buildHeader(),
          
          // Center Controls
          _buildCenterControls(state),
          
          // Bottom Controls
          _buildBottomControls(state),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.content.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCenterControls(VideoState state) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rewind 10s
          _buildControlButton(
            icon: Icons.replay_10,
            onPressed: () {
              final position = state.position - const Duration(seconds: 10);
              widget.controller.player.seek(position);
            },
          ),
          
          const SizedBox(width: 32),
          
          // Play/Pause
          _buildControlButton(
            icon: state.playing ? Icons.pause : Icons.play_arrow,
            onPressed: () {
              state.playing
                  ? widget.controller.player.pause()
                  : widget.controller.player.play();
            },
            size: 64,
          ),
          
          const SizedBox(width: 32),
          
          // Forward 10s
          _buildControlButton(
            icon: Icons.forward_10,
            onPressed: () {
              final position = state.position + const Duration(seconds: 10);
              widget.controller.player.seek(position);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomControls(VideoState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Progress Bar
          VideoProgressIndicator(
            widget.controller,
            allowScrubbing: !widget.content.isLive,
            colors: const VideoProgressColors(
              playedColor: Colors.red,
              bufferedColor: Colors.white30,
              backgroundColor: Colors.white10,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Time & Controls
          Row(
            children: [
              Text(
                _formatDuration(state.position),
                style: const TextStyle(color: Colors.white),
              ),
              const Text(
                ' / ',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                _formatDuration(state.duration),
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              
              // Settings
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  // Show quality settings
                },
              ),
              
              // Fullscreen
              IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.white),
                onPressed: () {
                  // Toggle fullscreen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 48,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black38,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        iconSize: size,
        onPressed: onPressed,
      ),
    );
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
