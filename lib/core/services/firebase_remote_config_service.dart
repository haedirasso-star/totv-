import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:convert';

/// Firebase Remote Config Service
/// يدير التحديثات البعيدة للقنوات والإعدادات
class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  
  FirebaseRemoteConfigService(this._remoteConfig);
  
  static const String _channelsKey = 'live_channels_m3u';
  static const String _movieApiKeyKey = 'movie_api_key';
  static const String _featuredContentKey = 'featured_content';
  static const String _appSettingsKey = 'app_settings';
  
  /// تهيئة Remote Config
  Future<void> initialize() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      
      // القيم الافتراضية
      await _remoteConfig.setDefaults({
        _movieApiKeyKey: '5b166a24c91f59178e8ce30f1f3735c0',
        _channelsKey: '',
        _featuredContentKey: '[]',
        _appSettingsKey: jsonEncode({
          'enable_ads': false,
          'enable_analytics': true,
          'min_app_version': '1.0.0',
        }),
      });
      
      await fetchAndActivate();
    } catch (e) {
      print('Error initializing Remote Config: $e');
    }
  }
  
  /// جلب وتفعيل القيم الجديدة
  Future<bool> fetchAndActivate() async {
    try {
      final activated = await _remoteConfig.fetchAndActivate();
      return activated;
    } catch (e) {
      print('Error fetching Remote Config: $e');
      return false;
    }
  }
  
  /// الحصول على مفتاح API الأفلام
  String getMovieApiKey() {
    return _remoteConfig.getString(_movieApiKeyKey);
  }
  
  /// الحصول على قائمة القنوات M3U
  String getChannelsM3U() {
    return _remoteConfig.getString(_channelsKey);
  }
  
  /// الحصول على المحتوى المميز
  List<Map<String, dynamic>> getFeaturedContent() {
    try {
      final jsonString = _remoteConfig.getString(_featuredContentKey);
      if (jsonString.isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error parsing featured content: $e');
      return [];
    }
  }
  
  /// الحصول على إعدادات التطبيق
  Map<String, dynamic> getAppSettings() {
    try {
      final jsonString = _remoteConfig.getString(_appSettingsKey);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('Error parsing app settings: $e');
      return {};
    }
  }
  
  /// الحصول على قيمة نصية
  String getString(String key) {
    return _remoteConfig.getString(key);
  }
  
  /// الحصول على قيمة رقمية
  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }
  
  /// الحصول على قيمة منطقية
  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }
  
  /// الحصول على قيمة مزدوجة
  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }
}
