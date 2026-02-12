import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/content.dart';

part 'content_model.g.dart';

@JsonSerializable()
class ContentModel extends Content {
  const ContentModel({
    required super.id,
    required super.title,
    super.description,
    super.imageUrl,
    super.posterUrl,
    required super.type,
    super.isLive = false,
    super.streamingUrls = const [],
    super.qualityOptions = const [],
    super.category,
    super.country,
    super.language,
    super.rating,
    super.year,
    super.duration,
    super.genres,
    super.metadata,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContentModelToJson(this);

  factory ContentModel.fromEntity(Content content) {
    return ContentModel(
      id: content.id,
      title: content.title,
      description: content.description,
      imageUrl: content.imageUrl,
      posterUrl: content.posterUrl,
      type: content.type,
      isLive: content.isLive,
      streamingUrls: content.streamingUrls,
      qualityOptions: content.qualityOptions,
      category: content.category,
      country: content.country,
      language: content.language,
      rating: content.rating,
      year: content.year,
      duration: content.duration,
      genres: content.genres,
      metadata: content.metadata,
    );
  }
}
