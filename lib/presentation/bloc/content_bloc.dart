import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/content.dart';
import '../../domain/repositories/content_repository.dart';

// --- Events ---
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

class ChangeCategoryEvent extends ContentEvent {
  final String category;
  const ChangeCategoryEvent(this.category);
  @override
  List<Object?> get props => [category];
}

// --- States ---
abstract class ContentState extends Equatable {
  const ContentState();
  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

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
  // نعتمد على Interface (العقد) وليس التنفيذ الفعلي لضمان مرونة الكود
  final ContentRepository repository;

  ContentBloc({required this.repository}) : super(ContentInitial()) {
    on<FetchHomeContent>(_onFetchHomeContent);
    on<SearchContentEvent>(_onSearchContent);
  }

  Future<void> _onFetchHomeContent(
    FetchHomeContent event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());

    // جلب البيانات بشكل متوازي لسرعة الأداء في 2026
    final results = await Future.wait([
      repository.getLiveChannels(),
      repository.getMovies(),
      repository.getSeries(),
    ]);

    // استخراج النتائج ومعالجة الـ Either (Left للخطأ، Right للنجاح)
    final channelsResult = results[0];
    final moviesResult = results[1];
    final seriesResult = results[2];

    String errorMessage = "";
    List<Content> channels = [];
    List<Content> movies = [];
    List<Content> seriesList = [];

    // فحص النتائج (Pattern Matching)
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
}
