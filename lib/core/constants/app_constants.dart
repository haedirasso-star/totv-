/// ثوابت التطبيق
class AppConstants {
  // معلومات التطبيق
  static const String appName = 'ToTV+';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.totv.plus';
  
  // API URLs
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String tmdbPosterBaseUrl = 'https://image.tmdb.org/t/p/original';
  
  // API Keys
  static const String defaultMovieApiKey = '5b166a24c91f59178e8ce30f1f3735c0';
  
  // Firebase Remote Config Keys
  static const String remoteConfigChannelsKey = 'live_channels_m3u';
  static const String remoteConfigMovieApiKey = 'movie_api_key';
  static const String remoteConfigFeaturedKey = 'featured_content';
  static const String remoteConfigAppSettingsKey = 'app_settings';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Cache
  static const Duration cacheValidity = Duration(hours: 24);
  static const int maxCacheSize = 100;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Video Player
  static const String defaultUserAgent = 'ToTV+/1.0.0 (Android)';
  static const Duration bufferDuration = Duration(seconds: 50);
  static const Duration maxBufferDuration = Duration(seconds: 60);
  
  // Categories
  static const List<String> defaultCategories = [
    'الكل',
    'رياضة',
    'أخبار',
    'أفلام',
    'مسلسلات',
    'أطفال',
    'موسيقى',
    'ديني',
  ];
  
  // Countries
  static const List<String> supportedCountries = [
    'العراق',
    'لبنان',
    'مصر',
    'السعودية',
    'الإمارات',
    'الأردن',
    'سوريا',
  ];
  
  // Languages
  static const String defaultLanguage = 'ar';
  static const List<String> supportedLanguages = ['ar', 'en'];
}
