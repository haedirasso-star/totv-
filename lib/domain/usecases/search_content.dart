import 'package:dartz/dartz.dart';
import '../entities/content.dart';
import '../repositories/content_repository.dart';
import '../../core/error/failures.dart';

/// Use Case للبحث في المحتوى
class SearchContentUseCase {
  final ContentRepository repository;

  SearchContentUseCase(this.repository);

  Future<Either<Failure, List<Content>>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Left(ParsingFailure('الرجاء إدخال نص للبحث'));
    }
    return await repository.searchContent(query);
  }
}
