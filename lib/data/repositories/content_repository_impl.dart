import 'package:dartz/dartz.dart';
import '../../domain/entities/content.dart';
import '../../domain/repositories/content_repository.dart';
import '../../core/error/failures.dart';
import '../../core/services/m3u_parser_service.dart';
import '../../core/services/firebase_remote_config_service.dart';
import '../datasources/movie_remote_datasource.dart';

/// Content Repository Implementation
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
  
  // قائمة القنوات الافتراضية (من الملف المرفق)
  static const String _defaultM3U = '''
#EXTM3U
#EXTINF:-1 tvg-id="ABNsat.iq",ABNsat (720p)
https://mediaserver.abnvideos.com/streams/abnsat.m3u8
#EXTINF:-1 tvg-id="AlRabiaaTV.iq" http-referrer="https://player.castr.com/live_c6c4040053cd11ee95b47153d2861736",Al Rabiaa TV (1080p)
#EXTVLCOPT:http-referrer=https://player.castr.com/live_c6c4040053cd11ee95b47153d2861736
https://stream.castr.com/65045e4aba85cfe0025e4a60/live_c6c4040053cd11ee95b47153d2861736/index.fmp4.m3u8
#EXTINF:-1 tvg-id="AlIraqia.iq",Al Iraqia (720p)
https://cdn.catiacast.video/abr/8d2ffb0aba244e8d9101a9488a7daa05/playlist.m3u8
#EXTINF:-1 tvg-id="AlIraqiaNews.iq",Al Iraqia News (720p)
https://cdn.catiacast.video/abr/78054972db7708422595bc96c6e024ac/playlist.m3u8
#EXTINF:-1 tvg-id="AlSharqiya.iq",Al-Sharqiya (1080p)
https://5d94523502c2d.streamlock.net/home/mystream/playlist.m3u8
#EXTINF:-1 tvg-id="AlSharqiyaNews.iq",Al-Sharqiya News (1080p)
https://5d94523502c2d.streamlock.net/alsharqiyalive/mystream/playlist.m3u8
#EXTINF:-1 tvg-id="DijlahTV.iq",Dijlah TV (1080p)
https://ghaasiflu.online/Dijlah/index.m3u8
#EXTINF:-1 tvg-id="DijlahTarab.iq",Dijlah Tarab (1080p)
https://ghaasiflu.online/tarab/index.m3u8
#EXTINF:-1 tvg-id="MBCIraq.iq",MBC Iraq (1080p)
https://shd-gcp-live.edgenextcdn.net/live/bitmovin-mbc-iraq/e38c44b1b43474e1c39cb5b90203691e/index.m3u8
#EXTINF:-1 tvg-id="MBCbollywood.iq",MBC Bollywood (1080p)
https://shd-gcp-live.edgenextcdn.net/live/bitmovin-mbc-bollywood/546eb40d7dcf9a209255dd2496903764/index.m3u8
#EXTINF:-1 tvg-id="NRT.iq",NRT TV (720p)
https://media.streambrothers.com:1936/8226/8226/playlist.m3u8
#EXTINF:-1 tvg-id="RudawTV.iq",Rudaw TV (1080p)
https://svs.itworkscdn.net/rudawlive/rudawlive.smil/playlist.m3u8
#EXTINF:-1 tvg-id="UTV.iq",UTV (1080p)
https://mn-nl.mncdn.com/utviraqi2/64c80359/index.m3u8
#EXTINF:-1 tvg-id="rotanaCinema.lb",Rotana Cinema (720p)
https://bcovlive-a.akamaihd.net/9527a892aeaf43019fd9eeb77ad1516e/eu-central-1/6057955906001/playlist.m3u8
#EXTINF:-1 tvg-id="rotanaAflam.lb",Rotana Aflam + (1080p)
https://cdn1.iptvcdn.tv/mcnc/ROTANA_AFLAMPLUS/playlist.m3u8?token=demo
#EXTINF:-1 tvg-id="rotanaClassic.lb",Rotana Classic (1080p)
https://bcovlive-a.akamaihd.net/0debf5648e584e5fb795c3611c5c0252/eu-central-1/6057955906001/playlist.m3u8
#EXTINF:-1 tvg-id="rotanaKids.lb",Rotana Kids (1080p)
https://cdn1.iptvcdn.tv/mcnc/ROTANA_KIDS/playlist.m3u8?&token=demo
#EXTINF:-1 tvg-id="mbc1.lb",MBC 1 (1080p)
https://mbc1-enc.edgenextcdn.net/out/v1/0965e4d7deae49179172426cbfb3bc5e/index.m3u8
#EXTINF:-1 tvg-id="mbc2.lb",MBC 2 (1080p)
https://edge66.magictvbox.com/liveApple/MBC_2/index.m3u8
#EXTINF:-1 tvg-id="mbc3.lb",MBC 3 (720p)
https://shd-gcp-live.edgenextcdn.net/live/bitmovin-mbc-3-usa/5d58265a862a476dc7f97694addb5ded/index.m3u8
#EXTINF:-1 tvg-id="mbc4.lb",MBC 4 (1080p)
https://shd-gcp-live.edgenextcdn.net/live/bitmovin-mbc-4/24f134f1cd63db9346439e96b86ca6ed/index.m3u8
#EXTINF:-1 tvg-id="mbc5.lb",MBC 5 (1080p)
https://shd-gcp-live.edgenextcdn.net/live/bitmovin-mbc-5/ee6b000cee0629411b666ab26cb13e9b/index.m3u8
#EXTINF:-1 tvg-id="mbcAction.lb",MBC Action (1080p)
https://edge66.magictvbox.com/liveApple/MBC_Action/index.m3u8
#EXTINF:-1 tvg-id="mbcDrama.lb",MBC Drama (1080p)
https://mbc1-enc.edgenextcdn.net/out/v1/b0b3a0e6750d4408bb86d703d5feffd1/index.m3u8
#EXTINF:-1 tvg-id="AlJazeeraArabic.lb",Al Jazeera Arabic (1080p)
https://live-hls-web-aja.getaj.net/AJA/index.m3u8
#EXTINF:-1 tvg-id="spacetoon.lb",Spacetoon (1080p)
https://streams.spacetoon.com/live/stchannel/smil:livesmil.smil/playlist.m3u8
#EXTINF:-1 tvg-id="alarabiya.lb",Al Arabiya (1080p)
https://mbc1-enc.edgenextcdn.net/out/v1/f5f319206ed740f9a831f2097c2ead23/index.m3u8
#EXTINF:-1 tvg-id="MTV.lb",MTV (1080p)
https://hms.pfs.gdn/v1/broadcast/mtv/playlist.m3u8
#EXTINF:-1 tvg-id="NBN.lb",NBN (1080p)
http://5.9.119.146:8883/nbn/index.m3u8
#EXTINF:-1 tvg-id="FutureTV.lb",Future TV (1080p)
https://live.kwikmotion.com/futurelive/ftv.smil/playlist.m3u8
''';

  @override
  Future<Either<Failure, List<Content>>> getLiveChannels() async {
    try {
      // محاولة جلب القنوات من Remote Config
      await updateChannelsFromRemoteConfig();
      
      // إذا لم تكن هناك قنوات محفوظة، استخدم القائمة الافتراضية
      if (_cachedChannels.isEmpty) {
        _cachedChannels = m3uParser.parseM3U(_defaultM3U);
      }
      
      return Right(_cachedChannels);
    } catch (e) {
      return Left(ServerFailure('فشل في جلب القنوات: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Content>>> getMovies({
    int page = 1,
    String? genre,
    String? searchQuery,
  }) async {
    try {
      final movies = await movieDataSource.getMovies(
        page: page,
        genre: genre,
        searchQuery: searchQuery,
      );
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure('فشل في جلب الأفلام: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Content>> getContentDetails(String id) async {
    try {
      // البحث في القنوات أولاً
      final channel = _cachedChannels.firstWhere(
        (c) => c.id == id,
        orElse: () => throw Exception('المحتوى غير موجود'),
      );
      return Right(channel);
    } catch (e) {
      // محاولة جلب تفاصيل الفيلم
      try {
        final movie = await movieDataSource.getMovieDetails(id);
        return Right(movie);
      } catch (e) {
        return Left(NotFoundFailure('المحتوى غير موجود'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Content>>> searchContent(String query) async {
    try {
      final searchResults = <Content>[];
      
      // البحث في القنوات
      final channels = m3uParser.searchChannels(_cachedChannels, query);
      searchResults.addAll(channels);
      
      // البحث في الأفلام
      final moviesResult = await getMovies(searchQuery: query);
      moviesResult.fold(
        (failure) => null,
        (movies) => searchResults.addAll(movies),
      );
      
      return Right(searchResults);
    } catch (e) {
      return Left(ServerFailure('فشل في البحث: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Content>>> getContentByCategory(
      String category) async {
    try {
      final filtered = m3uParser.filterByCategory(_cachedChannels, category);
      return Right(filtered);
    } catch (e) {
      return Left(ServerFailure('فشل في جلب المحتوى: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Content>>> getFeaturedContent() async {
    try {
      final featured = remoteConfig.getFeaturedContent();
      // يمكن تحويل البيانات إلى Content objects هنا
      return Right(_cachedChannels.take(10).toList());
    } catch (e) {
      return Left(ServerFailure('فشل في جلب المحتوى المميز: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateChannelsFromRemoteConfig() async {
    try {
      await remoteConfig.fetchAndActivate();
      final m3uContent = remoteConfig.getChannelsM3U();
      
      if (m3uContent.isNotEmpty) {
        _cachedChannels = m3uParser.parseM3U(m3uContent);
      }
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('فشل في التحديث: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getRemoteConfig() async {
    try {
      final config = remoteConfig.getAppSettings();
      return Right(config);
    } catch (e) {
      return Left(ServerFailure('فشل في جلب الإعدادات: ${e.toString()}'));
    }
  }
}
