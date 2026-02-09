import 'package:dartz/dartz.dart';
import '../../domain/entities/content.dart';
import '../../domain/repositories/content_repository.dart';
import '../../core/error/failures.dart';
import '../../core/services/m3u_parser_service.dart';
import '../../core/services/firebase_remote_config_service.dart';
import '../datasources/movie_remote_datasource.dart';

class ContentRepositoryImpl implements ContentRepository {
  final M3UParserService m3uParser;
  final FirebaseRemoteConfigService remoteConfig;
  final MovieRemoteDataSource movieDataSource;

  List<Content> _cachedChannels = [];

  ContentRepositoryImpl({
    required this.m3uParser,
    required this.remoteConfig,
    required this.movieDataSource,
  });

  // قائمة القنوات الافتراضية - محدثة لعام 2026 مع دعم الـ Headers
  static const String _defaultM3U = '''
#EXTM3U
#EXTINF:-1 tvg-id="AlRabiaaTV.iq" http-referrer="https://player.castr.com/",Al Rabiaa TV (1080p)
https://stream.castr.com/65045e4aba85cfe0025e4a60/live_c6c4040053cd11ee95b47153d2861736/index.fmp4.m3u8
#EXTINF:-1 tvg-id="MBCIraq.iq",MBC Iraq (1080p)
https://shd-gcp-live.edgenextcdn.net/live/bitmovin-mbc-iraq/e38c44b1b43474e1c39cb5b90203691e/index.m3u8
#EXTINF:-1 tvg-id="spacetoon.lb",Spacetoon (1080p)
https://streams.spacetoon.com/live/stchannel/smil:livesmil.smil/playlist.m3u8
''';

  @override
  Future<Either<Failure, List<Content>>> getLiveChannels() async {
    try {
      // محاولة التحديث من Firebase أولاً
      try {
        await remoteConfig.fetchAndActivate();
        final remoteM3u = remoteConfig.getChannelsM3U();
        if (remoteM3u.isNotEmpty) {
          _cachedChannels = m3uParser.parseM3U(remoteM3u);
        }
      } catch (_) {
        // إذا فشل الفايربيس نستخدم الافتراضي
        if (_cachedChannels.isEmpty) {
          _cachedChannels = m3uParser.parseM3U(_defaultM3U);
        }
      }
      return Right(_cachedChannels);
    } catch (e) {
      return Left(ServerFailure('فشل في معالجة القنوات المباشرة: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Content>>> getMovies() async {
    try {
      final movies = await movieDataSource.getMovies();
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure('فشل في جلب قائمة الأفلام'));
    }
  }

  @override
  Future<Either<Failure, List<Content>>> getSeries() async {
    try {
      final series = await movieDataSource.getSeries();
      return Right(series);
    } catch (e) {
      return Left(ServerFailure('فشل في جلب المسلسلات'));
    }
  }

  @override
  Future<Either<Failure, List<Content>>> getContentByCategory(String category) async {
    try {
      final filtered = _cachedChannels.where((c) => c.category == category).toList();
      return Right(filtered);
    } catch (e) {
      return Left(ServerFailure('التصنيف غير موجود'));
    }
  }

  @override
  Future<Either<Failure, Content>> getContentDetails(String id) async {
    try {
      // البحث في الكاش أولاً (للقنوات)
      final content = _cachedChannels.firstWhere(
        (c) => c.id == id,
        orElse: () => throw Exception('Not Found in Cache'),
      );
      return Right(content);
    } catch (_) {
      try {
        final movie = await movieDataSource.getMovieDetails(id);
        return Right(movie);
      } catch (e) {
        return const Left(ServerFailure('المحتوى غير موجود في السيرفر'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Content>>> searchContent(String query) async {
    try {
      final List<Content> results = _cachedChannels
          .where((c) => c.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      final movies = await movieDataSource.searchMovies(query);
      results.addAll(movies);
      
      return Right(results);
    } catch (e) {
      return Left(ServerFailure('خطأ أثناء البحث: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, StreamingUrl>> refreshStreamingUrl(String contentId) async {
    // هذه الدالة مهمة لروابط JADX المتغيرة
    try {
      final newUrl = await movieDataSource.refreshUrl(contentId);
      return Right(newUrl);
    } catch (e) {
      return const Left(ServerFailure('فشل تحديث رابط البث'));
    }
  }
}
