import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/content.dart';
import '../../domain/repositories/content_repository.dart';

// --- Events (الأحداث) ---
abstract class ContentEvent extends Equatable {
  const ContentEvent();
  @override
  List<Object?> get props => [];
}

class FetchHomeContent extends ContentEvent {}

class SearchContentEvent extends ContentEvent {
  final String query;
  const SearchContentEvent(this.query);
  @override
  List<Object?> get props => [query];
}

// الحدث الجديد: طلب تشغيل الفيديو وجلب الرابط من فودو
class PlayVideoEvent extends ContentEvent {
  final Content content;
  const PlayVideoEvent(this.content);
  @override
  List<Object?> get props => [content];
}

// --- States (الحالات) ---
abstract class ContentState extends Equatable {
  const ContentState();
  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

// حالة جديدة: تظهر عند جلب رابط الفيديو بنجاح للانتقال للمشغل
class VideoReadyState extends ContentState {
  final String videoUrl;
  final Content content;
  const VideoReadyState(this.videoUrl, this.content);
  @override
  List<Object?> get props => [videoUrl, content];
}

class ContentLoaded extends ContentState {
  final List<Content> liveChannels;
  final List<Content> movies;
  final List<Content> series;

  const ContentLoaded({
    required this.liveChannels,
    required this.movies,
    required this.series,
  });

  @override
  List<Object?> get props => [liveChannels, movies, series];
}

class ContentError extends ContentState {
  final String message;
  const ContentError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Bloc Implementation ---
class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepository repository;

  ContentBloc({required this.repository}) : super(ContentInitial()) {
    on<FetchHomeContent>(_onFetchHomeContent);
    on<SearchContentEvent>(_onSearchContent);
    on<PlayVideoEvent>(_onPlayVideo); // معالج حدث التشغيل الجديد
  }

  Future<void> _onFetchHomeContent(
    FetchHomeContent event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());

    // جلب البيانات بشكل متوازي لسرعة الأداء
    final results = await Future.wait([
      repository.getLiveChannels(),
      repository.getMovies(),
      repository.getSeries(),
    ]);

    final channelsResult = results[0];
    final moviesResult = results[1];
    final seriesResult = results[2];

    String errorMessage = "";
    List<Content> channels = [];
    List<Content> movies = [];
    List<Content> seriesList = [];

    channelsResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => channels = data as List<Content>,
    );

    moviesResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => movies = data as List<Content>,
    );

    seriesResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => seriesList = data as List<Content>,
    );

    if (channels.isEmpty && movies.isEmpty && seriesList.isEmpty) {
      emit(ContentError(errorMessage.isNotEmpty ? errorMessage : "لا يوجد محتوى متاح حالياً"));
    } else {
      emit(ContentLoaded(
        liveChannels: channels,
        movies: movies,
        series: seriesList,
      ));
    }
  }

  Future<void> _onSearchContent(
    SearchContentEvent event,
    Emitter<ContentState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(FetchHomeContent());
      return;
    }

    emit(ContentLoading());
    final result = await repository.searchContent(event.query);

    result.fold(
      (failure) => emit(ContentError(failure.message)),
      (data) => emit(ContentLoaded(
        liveChannels: data.where((c) => c.isLive).toList(),
        movies: data.where((c) => c.type == ContentType.movie).toList(),
        series: data.where((c) => c.type == ContentType.series).toList(),
      )),
    );
  }

  // الدالة الجديدة لمعالجة جلب رابط الفيديو من فودو
  Future<void> _onPlayVideo(
    PlayVideoEvent event,
    Emitter<ContentState> emit,
  ) async {
    // جلب الرابط باستخدام العنوان (Title) للبحث عنه في فودو
    final result = await repository.refreshUrl(event.content.title);

    result.fold(
      (failure) => emit(ContentError("فشل العثور على رابط البث: ${failure.message}")),
      (streamingInfo) {
        if (streamingInfo.url.isNotEmpty) {
          emit(VideoReadyState(streamingInfo.url, event.content));
        } else {
          emit(const ContentError("عذراً، المحتوى غير متوفر على سيرفرات البث حالياً"));
        }
      },
    );
  }
}
