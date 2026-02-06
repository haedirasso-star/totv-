/// TOTV+ Application Constants
/// Contains all app-wide constant values

class AppConstants {
  // App Information
  static const String appName = 'TOTV+';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.totv.plus';
  
  // API Configuration
  static const String movieApiKey = '5b166a24c91f59178e8ce30f1f3735c0';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/';
  
  // CDN URLs (Replace with actual CDN URLs)
  static const List<String> cdnBaseUrls = [
    'https://cdn1.totv.plus',
    'https://cdn2.totv.plus',
    'https://cdn3.totv.plus',
  ];
  
  // Support & Contact
  static const String supportWhatsApp = '009647714415816';
  static const String supportPhone = '+964 771 441 5816';
  static const String supportEmail = 'support@totv.plus';
  static const String whatsAppDeepLink = 'whatsapp://send?phone=009647714415816';
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/totvplus';
  static const String twitterUrl = 'https://twitter.com/totvplus';
  static const String instagramUrl = 'https://instagram.com/totvplus';
  
  // Security
  static const String encryptionKey = 'TOTV_PLUS_SECRET_KEY_2025';
  static const String jwtSecret = 'TOTV_JWT_SECRET_2025';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String contentCollection = 'content';
  static const String watchHistoryCollection = 'watch_history';
  static const String favoritesCollection = 'favorites';
  
  // Video Quality Options
  static const List<String> videoQualities = [
    'Auto',
    '4K (2160p)',
    '1080p',
    '720p',
    '480p',
    '360p',
    '240p',
  ];
  
  // Subtitle Languages
  static const List<String> subtitleLanguages = [
    'العربية',
    'English',
    'Français',
    'None',
  ];
  
  // Theme Colors
  static const int primaryColorValue = 0xFFFF6B00;
  static const int secondaryColorValue = 0xFF1E5FA8;
  static const int backgroundColorValue = 0xFF0A0A0A;
  
  // Feature Flags (can be overridden by Firebase Remote Config)
  static const bool enableDownloads = true;
  static const bool enablePiP = true;
  static const bool enableChromecast = true;
  static const bool enable4KQuality = true;
  static const bool enableAds = false;
  
  // Streaming Configuration
  static const int maxSimultaneousStreams = 2;
  static const int bufferDurationSeconds = 10;
  static const int retryAttempts = 3;
  static const int connectionTimeoutSeconds = 30;
  
  // Cache Configuration
  static const int maxCacheSize = 500; // MB
  static const int cacheDurationDays = 7;
  
  // Deep Links
  static const String deepLinkScheme = 'totvplus://';
  static const String webDeepLinkUrl = 'https://totv.plus';
  
  // Store URLs
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.totv.plus';
  static const String appStoreUrl = 'https://apps.apple.com/app/totv-plus/id123456789';
  
  // Privacy & Terms
  static const String privacyPolicyUrl = 'https://totv.plus/privacy';
  static const String termsOfServiceUrl = 'https://totv.plus/terms';
  static const String aboutUrl = 'https://totv.plus/about';
}

/// API Endpoints
class ApiEndpoints {
  // TMDB Endpoints
  static const String trending = '/trending/all/week';
  static const String popularMovies = '/movie/popular';
  static const String popularTVShows = '/tv/popular';
  static const String topRated = '/movie/top_rated';
  static const String nowPlaying = '/movie/now_playing';
  static const String movieDetails = '/movie/{id}';
  static const String tvDetails = '/tv/{id}';
  static const String search = '/search/multi';
  
  // Custom Backend Endpoints (if you have your own server)
  static const String liveStreams = '/api/v1/live';
  static const String userProfile = '/api/v1/user/profile';
  static const String watchHistory = '/api/v1/user/history';
  static const String favorites = '/api/v1/user/favorites';
}

/// Storage Keys
class StorageKeys {
  static const String authToken = 'auth_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String selectedQuality = 'selected_quality';
  static const String selectedSubtitle = 'selected_subtitle';
  static const String playbackSpeed = 'playback_speed';
  static const String autoPlayNext = 'auto_play_next';
  static const String downloadQuality = 'download_quality';
  static const String theme = 'theme';
  static const String language = 'language';
  static const String skipIntro = 'skip_intro';
  static const String parentalControl = 'parental_control';
}

/// Error Messages
class ErrorMessages {
  static const String noInternet = 'لا يوجد اتصال بالإنترنت';
  static const String serverError = 'خطأ في الخادم، يرجى المحاولة لاحقاً';
  static const String videoLoadFailed = 'فشل تحميل الفيديو';
  static const String authRequired = 'يجب تسجيل الدخول أولاً';
  static const String invalidCredentials = 'بيانات الدخول غير صحيحة';
  static const String sessionExpired = 'انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى';
  static const String maxStreamsReached = 'تم الوصول للحد الأقصى من البث المتزامن';
  static const String contentNotAvailable = 'المحتوى غير متاح في منطقتك';
  static const String downloadFailed = 'فشل التحميل';
  static const String unknown = 'حدث خطأ غير متوقع';
}

/// Success Messages
class SuccessMessages {
  static const String loginSuccess = 'تم تسجيل الدخول بنجاح';
  static const String downloadComplete = 'اكتمل التحميل';
  static const String addedToFavorites = 'تمت الإضافة إلى المفضلة';
  static const String removedFromFavorites = 'تمت الإزالة من المفضلة';
  static const String profileUpdated = 'تم تحديث الملف الشخصي';
}
