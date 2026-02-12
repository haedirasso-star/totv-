import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/content_bloc.dart';
import '../../domain/entities/content.dart';
import '../widgets/content_card.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/category_tabs.dart';
import 'player_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  final List<Map<String, dynamic>> _tabs = [
    {'title': 'الرئيسية', 'icon': Icons.home},
    {'title': 'رياضة', 'icon': Icons.sports_soccer},
    {'title': 'أفلام', 'icon': Icons.movie},
    {'title': 'مسلسلات', 'icon': Icons.tv},
    {'title': 'البث المباشر', 'icon': Icons.live_tv},
  ];

  @override
  void initState() {
    super.initState();
    // تحميل المحتوى المميز عند بدء التطبيق
    context.read<ContentBloc>().add(LoadLiveChannels());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFF1976D2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'TO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Search Icon
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
          // Profile Icon
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              _loadContentForTab(index);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _tabs[index]['title'],
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _loadContentForTab(int index) {
    final contentBloc = context.read<ContentBloc>();
    
    switch (index) {
      case 0: // الرئيسية
        contentBloc.add(LoadFeaturedContent());
        break;
      case 1: // رياضة
        contentBloc.add(LoadContentByCategory('رياضة'));
        break;
      case 2: // أفلام
        contentBloc.add(LoadMovies());
        break;
      case 3: // مسلسلات
        contentBloc.add(LoadContentByCategory('مسلسلات'));
        break;
      case 4: // البث المباشر
        contentBloc.add(LoadLiveChannels());
        break;
    }
  }

  Widget _buildContent() {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        if (state is ContentLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          );
        }
        
        if (state is ContentError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _loadContentForTab(_selectedIndex);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        
        if (state is ContentLoaded) {
          final contents = state.contents;
          
          if (contents.isEmpty) {
            return const Center(
              child: Text(
                'لا يوجد محتوى متاح',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          
          return CustomScrollView(
            slivers: [
              // Featured Content Carousel
              if (_selectedIndex == 0)
                SliverToBoxAdapter(
                  child: FeaturedCarousel(
                    contents: contents.take(5).toList(),
                    onContentTap: _onContentTap,
                  ),
                ),
              
              // Content Grid
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final content = contents[index];
                      return ContentCard(
                        content: content,
                        onTap: () => _onContentTap(content),
                      );
                    },
                    childCount: contents.length,
                  ),
                ),
              ),
            ],
          );
        }
        
        return const SizedBox();
      },
    );
  }

  void _onContentTap(Content content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerPage(content: content),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _loadContentForTab(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        items: _tabs.map((tab) {
          return BottomNavigationBarItem(
            icon: Icon(tab['icon']),
            label: tab['title'],
          );
        }).toList(),
      ),
    );
  }
}
