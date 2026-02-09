import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Firebase Remote Config Service - 2026 Updated
/// يدير التحديثات البعيدة للقنوات والإعدادات مع دعم التحديث اللحظي
class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  
  FirebaseRemoteConfigService(this._remoteConfig);
  
  static const String _channelsKey = 'live_channels_m3u';
  static const String _movieApiKeyKey = 'movie_api_key';
  static const String _featuredContentKey = 'featured_content';
  static const String _appSettingsKey = 'app_settings';
  static const String _globalHeadersKey = 'global_streaming_headers';

  /// تهيئة Remote Config مع إعدادات ذكية
  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          // في مرحلة التطوير نجعل التحديث فورياً، وفي الإنتاج كل ساعة
          minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );
      
      // القيم الافتراضية لضمان عمل التطبيق حتى بدون إنترنت في المرة الأولى
      await _remoteConfig.setDefaults({
        _movieApiKeyKey: '5b166a24c91f59178e8ce30f1f3735c0', // TMDB Key
        _channelsKey: '',
        _featuredContentKey: '[]',
        _globalHeadersKey: jsonEncode({
          'User-Agent': 'ToTV_Plus_Android_2026',
          'X-Requested-With': 'com.totv.plus'
        }),
        _appSettingsKey: jsonEncode({
          'enable_ads': false,
          'enable_analytics': true,
          'min_app_version': '1.0.0',
          'maintenance_mode': false,
        }),
      });
      
      await fetchAndActivate();

      // تفعيل التحديثات اللحظية (Real-time Config) لعام 2026
      _remoteConfig.onConfigUpdated.listen((event) async {
        await _remoteConfig.activate();
        if (kDebugMode) print('Remote Config Updated Automatically!');
      });

    } catch (e) {
      debugPrint('Error initializing Remote Config: $e');
    }
  }
  
  /// جلب وتفعيل القيم الجديدة يدوياً
  Future<bool> fetchAndActivate() async {
    try {
      final activated = await _remoteConfig.fetchAndActivate();
      return activated;
    } catch (e) {
      debugPrint('Error fetching Remote Config: $e');
      return false;
    }
  }
  
  /// الحصول على قائمة القنوات M3U
  String getChannelsM3U() {
    final m3u = _remoteConfig.getString(_channelsKey);
    return m3u.isNotEmpty ? m3u : '';
  }
  
  /// الحصول على الـ Headers العالمية المستخرجة من JADX لتشغيل القنوات
  Map<String, String> getGlobalHeaders() {
    try {
      final jsonString = _remoteConfig.getString(_globalHeadersKey);
      return Map<String, String>.from(jsonDecode(jsonString));
    } catch (e) {
      return {'User-Agent': 'ToTV_Plus_Android_2026'};
    }
  }

  /// الحصول على المحتوى المميز (Slider)
  List<Map<String, dynamic>> getFeaturedContent() {
    try {
      final jsonString = _remoteConfig.getString(_featuredContentKey);
      if (jsonString.isEmpty || jsonString == '[]') return [];
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error parsing featured content: $e');
      return [];
    }
  }
  
  /// الحصول على إعدادات التطبيق (إعلانات، وضع صيانة، إلخ)
  Map<String, dynamic> getAppSettings() {
    try {
      final jsonString = _remoteConfig.getString(_appSettingsKey);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  // الدوال المساعدة للوصول السريع
  String getString(String key) => _remoteConfig.getString(key);
  bool getBool(String key) => _remoteConfig.getBool(key);
  int getInt(String key) => _remoteConfig.getInt(key);
}
