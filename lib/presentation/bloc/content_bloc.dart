import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/content.dart';
import '../../data/repositories/content_repository_impl.dart';

abstract class ContentEvent {}
class FetchContent extends ContentEvent {}

abstract class ContentState {}
class ContentInitial extends ContentState {}
class ContentLoading extends ContentState {}
class ContentLoaded extends ContentState {
  final List<Content> content;
  ContentLoaded(this.content);
}
class ContentError extends ContentState {
  final String message;
  ContentError(this.message);
}

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepositoryImpl repository;

  ContentBloc(this.repository) : super(ContentInitial()) {
    on<FetchContent>((event, emit) async {
      emit(ContentLoading());
      try {
        final content = await repository.getLiveChannels();
        emit(ContentLoaded(content));
      } catch (e) {
        emit(ContentError(e.toString()));
      }
    });
  }
}