import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/content.dart';
import '../pages/player_page.dart';

class ContentCard extends StatelessWidget {
  final Content content;

  const ContentCard({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerPage(content: content),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // 1. الصورة الخلفية (بوستر الفيلم أو شعار القناة)
              _buildImage(),

              // 2. طبقة التدرج اللوني (Gradient) لجعل النص مقروءاً
              _buildGradient(),

              // 3. معلومات المحتوى (العنوان، السنة، النوع)
              _buildContentInfo(),

              // 4. شارة "مباشر" للقنوات
              if (content.isLive) _buildLiveBadge(),
              
              // 5. التقييم (للأفلام والمسلسلات)
              if (content.rating != null && content.rating! > 0) _buildRatingBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Positioned.fill(
      child: CachedNetworkImage
