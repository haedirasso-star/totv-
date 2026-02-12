import 'package:equatable/equatable.dart';

/// Content Entity - Domain Layer
/// يمثل محتوى القنوات المباشرة والأفلام
class Content extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? posterUrl;
  final ContentType type;
  final bool isLive;
  final List<StreamingUrl> streamingUrls;
  final List<QualityOption> qualityOptions;
  final String? category;
  final String? country;
  final String? language;
  final double? rating;
  final int? year;
  final String? duration;
  final List<String>? genres;
  final Map<String, dynamic>? metadata;

  const Content({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.posterUrl,
    required this.type,
    this.isLive = false,
    this.streamingUrls = const [],
    this.qualityOptions = const [],
    this.category,
    this.country,
    this.language,
    this.rating,
    this.year,
    this.duration,
    this.genres,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        posterUrl,
        type,
        isLive,
        streamingUrls,
        qualityOptions,
        category,
        country,
        language,
        rating,
        year,
        duration,
        genres,
        metadata,
      ];

  Content copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? posterUrl,
    ContentType? type,
    bool? isLive,
    List<StreamingUrl>? streamingUrls,
    List<QualityOption>? qualityOptions,
    String? category,
    String? country,
    String? language,
    double? rating,
    int? year,
    String? duration,
    List<String>? genres,
    Map<String, dynamic>? metadata,
  }) {
    return Content(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      posterUrl: posterUrl ?? this.posterUrl,
      type: type ?? this.type,
      isLive: isLive ?? this.isLive,
      streamingUrls: streamingUrls ?? this.streamingUrls,
      qualityOptions: qualityOptions ?? this.qualityOptions,
      category: category ?? this.category,
      country: country ?? this.country,
      language: language ?? this.language,
      rating: rating ?? this.rating,
      year: year ?? this.year,
      duration: duration ?? this.duration,
      genres: genres ?? this.genres,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// نوع المحتوى
enum ContentType {
  liveTV,
  movie,
  series,
  sports,
}

/// رابط البث مع معلومات إضافية
class StreamingUrl extends Equatable {
  final String url;
  final String quality;
  final Map<String, String>? headers;
  final String? httpReferrer;
  final bool requiresAuth;

  const StreamingUrl({
    required this.url,
    this.quality = 'auto',
    this.headers,
    this.httpReferrer,
    this.requiresAuth = false,
  });

  @override
  List<Object?> get props => [url, quality, headers, httpReferrer, requiresAuth];

  Map<String, String> getHeaders() {
    final Map<String, String> allHeaders = {};
    
    if (headers != null) {
      allHeaders.addAll(headers!);
    }
    
    if (httpReferrer != null) {
      allHeaders['Referer'] = httpReferrer!;
      allHeaders['Origin'] = httpReferrer!;
    }
    
    return allHeaders;
  }
}

/// خيارات الجودة المتاحة
class QualityOption extends Equatable {
  final String label;
  final String resolution;
  final String url;
  final int bitrate;

  const QualityOption({
    required this.label,
    required this.resolution,
    required this.url,
    this.bitrate = 0,
  });

  @override
  List<Object?> get props => [label, resolution, url, bitrate];
}

/// حالة المحتوى
enum ContentStatus {
  idle,
  loading,
  loaded,
  error,
}
