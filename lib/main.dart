import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  
  runApp(const ToTVCinemaApp());
}

class ToTVCinemaApp extends StatelessWidget {
  const ToTVCinemaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToTV+ Cinema',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        primaryColor: const Color(0xFFE50914),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: const CinemaHomePage(),
    );
  }
}

class CinemaHomePage extends StatefulWidget {
  const CinemaHomePage({Key? key}) : super(key: key);

  @override
  State<CinemaHomePage> createState() => _CinemaHomePageState();
}

class _CinemaHomePageState extends State<CinemaHomePage> {
  List<Movie> movies = [];
  List<Movie> trending = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/popular',
        queryParameters: {
          'api_key': '5b166a24c91f59178e8ce30f1f3735c0',
          'language': 'ar',
          'page': 1,
        },
      );

      final trendingResponse = await dio.get(
        'https://api.themoviedb.org/3/trending/movie/week',
        queryParameters: {
          'api_key': '5b166a24c91f59178e8ce30f1f3735c0',
          'language': 'ar',
        },
      );

      setState(() {
        movies = (response.data['results'] as List)
            .map((m) => Movie.fromJson(m))
            .toList();
        trending = (trendingResponse.data['results'] as List)
            .map((m) => Movie.fromJson(m))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE50914)))
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(child: _buildHeroSection()),
                SliverToBoxAdapter(child: _buildTrendingSection()),
                SliverToBoxAdapter(child: _buildPopularSection()),
              ],
            ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.black.withOpacity(0.8),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE50914), Color(0xFFB20710)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'TO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'TV+ Cinema',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    if (trending.isEmpty) return const SizedBox();
    
    return Container(
      height: 500,
      child: CarouselSlider.builder(
        itemCount: trending.take(5).length,
        options: CarouselOptions(
          height: 500,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
        ),
        itemBuilder: (context, index, realIndex) {
          final movie = trending[index];
          return _buildHeroCard(movie);
        },
      ),
    );
  }

  Widget _buildHeroCard(Movie movie) {
    return Stack(
      children: [
        // الخلفية
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: 'https://image.tmdb.org/t/p/original${movie.backdropPath}',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[900]),
            errorWidget: (context, url, error) => Container(color: Colors.grey[900]),
          ),
        ),
        // التدرج
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  Colors.black,
                ],
              ),
            ),
          ),
        ),
        // المحتوى
        Positioned(
          left: 24,
          right: 24,
          bottom: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    movie.releaseDate.split('-')[0],
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                movie.overview,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('تشغيل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('قائمتي'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingSection() {
    return _buildMovieSection('الأكثر مشاهدة', trending);
  }

  Widget _buildPopularSection() {
    return _buildMovieSection('الأفلام الشائعة', movies);
  }

  Widget _buildMovieSection(String title, List<Movie> movieList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              return _buildMovieCard(movieList[index]);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w342${movie.posterPath}',
              height: 180,
              width: 130,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[900],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[900],
                child: const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
    );
  }
}
