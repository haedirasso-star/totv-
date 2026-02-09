import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/content_bloc.dart';
import '../../domain/entities/content.dart';

// ملاحظة: سنقوم بإنشاء هذه الـ Widgets في الخطوة التالية لتختفي الأخطاء
// import '../widgets/content_card.dart';
// import 'player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  final List<Map<String, dynamic>> _tabs = [
    {'title': 'الكل', 'icon': Icons.grid_view},
    {'title': 'بث مباشر', 'icon': Icons.live_tv},
    {'title': 'أفلام', 'icon': Icons.movie},
    {'title': 'مسلسلات', 'icon': Icons.tv},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ContentBloc>().add(FetchHomeContent());
          },
          color: Colors.orange,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              _buildModernTabBar(),
              _buildBlocContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('أهلاً بك في', style: TextStyle(color: Colors.grey, fontSize: 14)),
                Text('ToTV+ Pro', style: TextStyle(color: Colors.orange[400], fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white, size: 28),
              onPressed: () {
                // سنقوم بإضافة نظام البحث لاحقاً
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTabBar() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _tabs.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 10)] : [],
                ),
                child: Center(
                  child: Text(
                    _tabs[index]['title'],
                    style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBlocContent() {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        if (state is ContentLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator(color: Colors.orange)),
          );
        }
        
        if (state is ContentError) {
          return SliverFillRemaining(
            child: Center(child: Text(state.message, style: const TextStyle(color: Colors.white))),
          );
        }

        if (state is ContentLoaded) {
          // تصفية المحتوى بناءً على التبويب المختار
          List<Content> displayList;
          if (_selectedIndex == 1) {
            displayList = state.liveChannels;
          } else if (_selectedIndex == 2) {
            displayList = state.movies;
          } else if (_selectedIndex == 3) {
            displayList = state.series;
          } else {
            displayList = [...state.liveChannels, ...state.movies];
          }

          return SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _tempContentCard(displayList[index]),
                childCount: displayList.length,
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }

  // كارد مؤقت لحين بناء الـ Widget المنفصل
  Widget _tempContentCard(Content content) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerPage(content: content)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(content.imageUrl ?? 'https://via.placeholder.com/150'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (content.isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                  child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(height: 5),
              Text(content.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
