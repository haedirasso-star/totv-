import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:totv_plus/core/config/constants.dart';

class GlassmorphicAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final double scrollOffset;
  final TabController tabController;
  final List<String> categories;

  GlassmorphicAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.scrollOffset,
    required this.tabController,
    required this.categories,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final opacity = (scrollOffset / 300).clamp(0.0, 1.0);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: opacity * 10,
          sigmaY: opacity * 10,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3 + (opacity * 0.5)),
                Colors.black.withOpacity(0.1 + (opacity * 0.3)),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Image.asset(
                        AppConstants.appLogo,
                        height: 32,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Text(
                          'TOTV+',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B00),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.account_circle,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: const Color(0xFFFF6B00),
                  indicatorWeight: 3,
                  labelColor: const Color(0xFFFF6B00),
                  unselectedLabelColor: Colors.white70,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: categories.map((cat) => Tab(text: cat)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
