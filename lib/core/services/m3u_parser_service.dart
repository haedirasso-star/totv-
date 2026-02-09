import '../../domain/entities/content.dart';
import '../../data/models/content_model.dart';

/// M3U Parser Service
/// الخدمة المسؤولة عن تحليل ملفات الـ M3U واستخراج القنوات والـ Headers
class M3UParserService {
  
  /// تحويل نص M3U كامل إلى قائمة من كائنات Content
  List<Content> parseM3U(String m3uContent) {
    final List<Content> channels = [];
    final List<String> lines = m3uContent.split('\n');
    
    ContentModel? currentChannel;
    Map<String, String> currentHeaders = {};

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      if (line.isEmpty) continue;

      // 1. استخراج معلومات القناة من سطر #EXTINF
      if (line.startsWith('#EXTINF:')) {
        final String title = line.split(',').last.trim();
        final String id = _getAttribute(line, 'tvg-id') ?? title.replaceAll(' ', '_').toLowerCase();
        final String? logo = _getAttribute(line, 'tvg-logo');
        final String? group = _getAttribute(line, 'group-title');
        
        // استخراج الـ Referrer إذا وجد في نفس السطر (نمط JADX)
        final String? referrer = _getAttribute(line, 'http-referrer');
        if (referrer != null) {
          currentHeaders['Referer'] = referrer;
          currentHeaders['Origin'] = _extractOrigin(referrer);
        }

        currentChannel = ContentModel(
          id: id,
          title: title,
          imageUrl: logo,
          category: group ?? 'قنوات عامة',
          type: ContentType.liveTV,
          isLive: true,
          streamingUrls: [], // سيتم ملؤه في السطر التالي
        );
      } 
      // 2. استخراج خيارات إضافية مثل User-Agent (نمط VLC)
      else if (line.startsWith('#EXTVLCOPT:')) {
        if (line.contains('http-referrer=')) {
          final ref = line.split('http-referrer=').last;
          currentHeaders['Referer'] = ref;
          currentHeaders['Origin'] = _extractOrigin(ref);
        }
        if (line.contains('http-user-agent=')) {
          currentHeaders['User-Agent'] = line.split('http-user-agent=').last;
        }
      }
      // 3. استخراج رابط البث (السطر الذي لا يبدأ بـ #)
      else if (line.startsWith('http')) {
        if (currentChannel != null) {
          final streamingUrl = StreamingUrlModel(
            url: line,
            httpReferrer: currentHeaders['Referer'],
            userAgent: currentHeaders['User-Agent'],
            headers: Map.from(currentHeaders),
          );

          // إضافة الرابط للقناة وحفظ القناة في القائمة
          channels.add(currentChannel.copyWith(
            streamingUrls: [streamingUrl],
          ));

          // إعادة تهيئة للمحطة التالية
          currentChannel = null;
          currentHeaders = {};
        }
      }
    }
    return channels;
  }

  /// دالة مساعدة لاستخراج القيم من سطر EXTINF (مثل tvg-logo="url")
  String? _getAttribute(String line, String attribute) {
    final regExp = RegExp('$attribute="([^"]+)"');
    final match = regExp.firstMatch(line);
    return match?.group(1);
  }

  /// استخراج الـ Origin من الـ Referrer لضمان قبول السيرفر للطلب
  String _extractOrigin(String url) {
    try {
      final uri = Uri.parse(url);
      return '${uri.scheme}://${uri.host}';
    } catch (_) {
      return url;
    }
  }

  /// دالة البحث في القنوات (تستخدم في Repository)
  List<Content> searchChannels(List<Content> channels, String query) {
    return channels
        .where((c) => c.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// تصفية القنوات حسب التصنيف
  List<Content> filterByCategory(List<Content> channels, String category) {
    return channels.where((c) => c.category == category).toList();
  }
}
