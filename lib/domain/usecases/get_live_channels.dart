import 'package:dartz/dartz.dart';
import '../entities/content.dart';
import '../repositories/content_repository.dart';
import '../../core/error/failures.dart';

/// Use Case لجلب القنوات المباشرة
class GetLiveChannelsUseCase {
  final ContentRepository repository;

  GetLiveChannelsUseCase(this.repository);

  Future<Either<Failure, List<Content>>> call() async {
    return await repository.getLiveChannels();
  }
}
