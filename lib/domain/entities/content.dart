import 'package:equatable/equatable.dart';

/// نوع المحتوى - تم تحديثه ليدعم التصنيفات الجديدة لعام 2026
enum ContentType {
  liveTV,
  movie,
  series,
  sports,
  documentary,
  radio
}

/// Content Entity - Domain Layer
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

/// رابط البث مع دعم كامل للـ Headers المستخرجة من JADX
class StreamingUrl extends Equatable {
  final String url;
  final String quality;
  final Map<String, String>? headers;
  final String? httpReferrer;
  final String? userAgent;
  final bool requiresAuth;
  final Map<String, String>? drmConfig;

  const StreamingUrl({
    required this.url,
    this.quality = 'auto',
    this.headers,
    this.httpReferrer,
    this.userAgent,
    this.requiresAuth = false,
    this.drmConfig,
  });

  @override
  List<Object?> get props => [
        url, 
        quality, 
        headers, 
        httpReferrer, 
        userAgent, 
        requiresAuth, 
        drmConfig
      ];

  Map<String, String> getHeaders() {
    final Map<String, String> allHeaders = {
      'Accept': '*/*',
      'Connection': 'keep-alive',
    };

    if (userAgent != null) {
      allHeaders['User-Agent'] = userAgent!;
    } else {
      allHeaders['User-Agent'] = 'Mozilla/5.0 (Linux; Android 12; TV) AppleWebKit/537.36';
    }

    if (httpReferrer != null) {
      allHeaders['Referer'] = httpReferrer!;
      try {
        final uri = Uri.parse(httpReferrer!);
        allHeaders['Origin'] = '${uri.scheme}://${uri.host}';
      } catch (_) {
        allHeaders['Origin'] = httpReferrer!;
      }
    }

    if (headers != null) {
      allHeaders.addAll(headers!);
    }

    return allHeaders;
  }
}

/// خيارات الجودة المتاحة - تم الإصلاح هنا
class QualityOption extends Equatable {
  final String label;
  final String resolution;
  final String url;

  const QualityOption({
    required this.label,
    required this.resolution,
    required this.url,
  });

  @override
  List<Object?> get props => [label, resolution, url];
}
