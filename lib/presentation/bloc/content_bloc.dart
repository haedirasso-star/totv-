import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/content.dart';
import '../../domain/repositories/content_repository.dart';

// Events
abstract class ContentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadLiveChannels extends ContentEvent {}

class LoadMovies extends ContentEvent {
  final int page;
  final String? genre;
  
  LoadMovies({this.page = 1, this.genre});
  
  @override
  List<Object?> get props => [page, genre];
}

class SearchContent extends ContentEvent {
  final String query;
  
  SearchContent(this.query);
  
  @override
  List<Object?> get props => [query];
}

class LoadContentByCategory extends ContentEvent {
  final String category;
  
  LoadContentByCategory(this.category);
  
  @override
  List<Object?> get props => [category];
}

class LoadFeaturedContent extends ContentEvent {}

class UpdateFromRemoteConfig extends ContentEvent {}

// States
abstract class ContentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<Content> contents;
  
  ContentLoaded(this.contents);
  
  @override
  List<Object?> get props => [contents];
}

class ContentError extends ContentState {
  final String message;
  
  ContentError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepository repository;
  
  ContentBloc({required this.repository}) : super(ContentInitial()) {
    on<LoadLiveChannels>(_onLoadLiveChannels);
    on<LoadMovies>(_onLoadMovies);
    on<SearchContent>(_onSearchContent);
    on<LoadContentByCategory>(_onLoadContentByCategory);
    on<LoadFeaturedContent>(_onLoadFeaturedContent);
    on<UpdateFromRemoteConfig>(_onUpdateFromRemoteConfig);
  }
  
  Future<void> _onLoadLiveChannels(
    LoadLiveChannels event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());
    
    final result = await repository.getLiveChannels();
    
    result.fold(
      (failure) => emit(ContentError(failure.message)),
      (channels) => emit(ContentLoaded(channels)),
    );
  }
  
  Future<void> _onLoadMovies(
    LoadMovies event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());
    
    final result = await repository.getMovies(
      page: event.page,
      genre: event.genre,
    );
    
    result.fold(
      (failure) => emit(ContentError(failure.message)),
      (movies) => emit(ContentLoaded(movies)),
    );
  }
  
  Future<void> _onSearchContent(
    SearchContent event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());
    
    final result = await repository.searchContent(event.query);
    
    result.fold(
      (failure) => emit(ContentError(failure.message)),
      (results) => emit(ContentLoaded(results)),
    );
  }
  
  Future<void> _onLoadContentByCategory(
    LoadContentByCategory event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());
    
    final result = await repository.getContentByCategory(event.category);
    
    result.fold(
      (failure) => emit(ContentError(failure.message)),
      (contents) => emit(ContentLoaded(contents)),
    );
  }
  
  Future<void> _onLoadFeaturedContent(
    LoadFeaturedContent event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentLoading());
    
    final result = await repository.getFeaturedContent();
    
    result.fold(
      (failure) => emit(ContentError(failure.message)),
      (contents) => emit(ContentLoaded(contents)),
    );
  }
  
  Future<void> _onUpdateFromRemoteConfig(
    UpdateFromRemoteConfig event,
    Emitter<ContentState> emit,
  ) async {
    await repository.updateChannelsFromRemoteConfig();
    
    // إعادة تحميل القنوات بعد التحديث
    add(LoadLiveChannels());
  }
}
