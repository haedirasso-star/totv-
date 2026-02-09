import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class VoduMoviesScreen extends StatefulWidget {
  @override
  _VoduMoviesScreenState createState() => _VoduMoviesScreenState();
}

class _VoduMoviesScreenState extends State<VoduMoviesScreen> {
  List<Map<String, String>> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVoduMovies();
  }

  Future<void> fetchVoduMovies() async {
    try {
      final response = await http.get(Uri.parse('https://movie.vodu.me/index.php'));
      if (response.statusCode == 200) {
        var document = parser.parse(response.body);
        // هذا الجزء سيسحب البوسترات والعناوين من موقع فودو
        var elements = document.querySelectorAll('.item'); 
        
        List<Map<String, String>> fetchedMovies = [];
        for (var element in elements) {
          fetchedMovies.add({
            'title': element.querySelector('.title')?.text ?? 'فيلم جديد',
            'image': element.querySelector('img')?.attributes['src'] ?? '',
            'link': element.querySelector('a')?.attributes['href'] ?? '',
          });
        }
        setState(() {
          movies = fetchedMovies;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("خطأ في جلب البيانات: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("أفلام فودو المباشرة"), backgroundColor: Colors.red),
      body: isLoading 
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: Image.network(
                      movies[index]['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.movie, color: Colors.white),
                    ),
                  ),
                  Text(movies[index]['title']!, 
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              );
            },
          ),
    );
  }
}
