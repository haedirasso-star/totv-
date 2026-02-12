import 'package:dartz/dartz.dart';
import '../entities/content.dart';
import '../repositories/content_repository.dart';
import '../../core/error/failures.dart';

/// Use Case لجلب الأفلام
class GetMoviesUseCase {
  final ContentRepository repository;

  GetMoviesUseCase(this.repository);

  Future<Either<Failure, List<Content>>> call({
    int page = 1,
    String? genre,
    String? searchQuery,
  }) async {
    return await repository.getMovies(
      page: page,
      genre: genre,
      searchQuery: searchQuery,
    );
  }
}
