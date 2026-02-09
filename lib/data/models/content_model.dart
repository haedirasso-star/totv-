import '../../domain/entities/content.dart';

/// Content Model - Data Layer
/// المسؤول عن تحويل البيانات بين السيرفر (JSON) والتطبيق (Entity)
class ContentModel extends Content {
  const ContentModel({
    required String id,
    required String title,
    String? description,
    String? imageUrl,
    String? posterUrl,
    required ContentType type,
    bool isLive = false,
    List<StreamingUrlModel> streamingUrls = const [],
    List<QualityOptionModel> qualityOptions = const [],
    String? category,
    String? country,
    String? language,
    double? rating,
    int? year,
    String? duration,
    List<String>? genres,
    Map<String, dynamic>? metadata,
  }) : super(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          posterUrl: posterUrl,
          type: type,
          isLive: isLive,
          streamingUrls: streamingUrls,
          qualityOptions: qualityOptions,
          category: category,
          country: country,
          language: language,
          rating: rating,
          year: year,
          duration: duration,
          genres: genres,
          metadata: metadata,
        );

  /// تحويل JSON قادم من API إلى كائن ContentModel
  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'عنوان غير معروف',
      description: json['description'],
      imageUrl: json['image_url'] ?? json['thumbnail'],
      posterUrl: json['poster_url'],
      type: _parseContentType(json['type']),
      isLive: json['is_live'] ?? false,
      streamingUrls: (json['streaming_urls'] as List?)
              ?.map((e) => StreamingUrlModel.fromJson(e))
              .toList() ??
          [],
      qualityOptions: (json['quality_options'] as List?)
              ?.map((e) => QualityOptionModel.fromJson(e))
              .toList() ??
          [],
      category: json['category'],
      country: json['country'],
      language: json['language'],
      rating: (json['rating'] as num?)?.toDouble(),
      year: json['year'] as int?,
      duration: json['duration'],
      genres: (json['genres'] as List?)?.map((e) => e.toString()).toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// تحويل الكائن إلى JSON لإرساله للسيرفر أو تخزينه محلياً
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'poster_url': posterUrl,
      'type': type.name,
      'is_live': isLive,
      'streaming_urls': streamingUrls
          .map((e) => (e as StreamingUrlModel).toJson())
          .toList(),
      'quality_options': qualityOptions
          .map((e) => (e as QualityOptionModel).toJson())
          .toList(),
      'category': category,
      'country': country,
      'language': language,
      'rating': rating,
      'year': year,
      'duration': duration,
      'genres': genres,
      'metadata': metadata,
    };
  }

  /// دالة مساعدة لتحويل النص إلى Enum ContentType بشكل آمن
  static ContentType _parseContentType(dynamic type) {
    final typeString = type?.toString().toLowerCase();
    return ContentType.values.firstWhere(
      (e) => e.name.toLowerCase() == typeString,
      orElse: () => ContentType.liveTV,
    );
  }
}

/// StreamingUrl Model - تحويل بيانات روابط البث
class StreamingUrlModel extends StreamingUrl {
  const StreamingUrlModel({
    required String url,
    String quality = 'auto',
    Map<String, String>? headers,
    String? httpReferrer,
    String? userAgent,
    bool requiresAuth = false,
    Map<String, String>? drmConfig,
  }) : super(
          url: url,
          quality: quality,
          headers: headers,
          httpReferrer: httpReferrer,
          userAgent: userAgent,
          requiresAuth: requiresAuth,
          drmConfig: drmConfig,
        );

  factory StreamingUrlModel.fromJson(Map<String, dynamic> json) {
    return StreamingUrlModel(
      url: json['url'] ?? '',
      quality: json['quality'] ?? 'auto',
      headers: (json['headers'] as Map?)?.cast<String, String>(),
      httpReferrer: json['http_referrer'] ?? json['referer'],
      userAgent: json['user_agent'],
      requiresAuth: json['requires_auth'] ?? false,
      drmConfig: (json['drm_config'] as Map?)?.cast<String, String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'quality': quality,
      'headers': headers,
      'http_referrer': httpReferrer,
      'user_agent': userAgent,
      'requires_auth': requiresAuth,
      'drm_config': drmConfig,
    };
  }
}

/// QualityOption Model - تحويل خيارات الجودة
class QualityOptionModel extends QualityOption {
  const QualityOptionModel({
    required String label,
    required String resolution,
    required String url,
    int bitrate = 0,
  }) : super(
          label: label,
          resolution: resolution,
          url: url,
          bitrate: bitrate,
        );

  factory QualityOptionModel.fromJson(Map<String, dynamic> json) {
    return QualityOptionModel(
      label: json['label'] ?? '',
      resolution: json['resolution'] ?? '',
      url: json['url'] ?? '',
      bitrate: json['bitrate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'resolution': resolution,
      'url': url,
      'bitrate': bitrate,
    };
  }
}
