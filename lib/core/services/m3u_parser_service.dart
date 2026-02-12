import '../../domain/entities/content.dart';

/// M3U Parser Service
/// يحلل ملفات M3U ويحولها إلى Content objects
class M3UParserService {
  /// تحليل محتوى M3U
  List<Content> parseM3U(String m3uContent) {
    final List<Content> channels = [];
    final lines = m3uContent.split('\n');
    
    String? currentTitle;
    String? currentId;
    String? currentLogo;
    String? currentGroup;
    String? currentReferrer;
    Map<String, String>? currentHeaders;
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      
      // تخطي السطور الفارغة
      if (line.isEmpty) continue;
      
      // معالجة معلومات القناة
      if (line.startsWith('#EXTINF:')) {
        final info = _parseExtInf(line);
        currentTitle = info['title'];
        currentId = info['id'];
        currentLogo = info['logo'];
        currentGroup = info['group'];
      }
      // معالجة HTTP Referrer
      else if (line.startsWith('#EXTVLCOPT:http-referrer=')) {
        currentReferrer = line.substring('#EXTVLCOPT:http-referrer='.length);
      }
      // معالجة رابط البث
      else if (line.startsWith('http')) {
        if (currentTitle != null) {
          final channel = _createChannel(
            title: currentTitle,
            url: line,
            id: currentId,
            logo: currentLogo,
            group: currentGroup,
            referrer: currentReferrer,
          );
          
          channels.add(channel);
          
          // إعادة تعيين المتغيرات
          currentTitle = null;
          currentId = null;
          currentLogo = null;
          currentGroup = null;
          currentReferrer = null;
          currentHeaders = null;
        }
      }
    }
    
    return channels;
  }
  
  /// تحليل سطر EXTINF
  Map<String, String?> _parseExtInf(String line) {
    final Map<String, String?> info = {};
    
    // استخراج tvg-id
    final idMatch = RegExp(r'tvg-id="([^"]*)"').firstMatch(line);
    info['id'] = idMatch?.group(1);
    
    // استخراج tvg-logo
    final logoMatch = RegExp(r'tvg-logo="([^"]*)"').firstMatch(line);
    info['logo'] = logoMatch?.group(1);
    
    // استخراج group-title
    final groupMatch = RegExp(r'group-title="([^"]*)"').firstMatch(line);
    info['group'] = groupMatch?.group(1);
    
    // استخراج اسم القناة (آخر جزء بعد الفاصلة)
    final parts = line.split(',');
    if (parts.length > 1) {
      info['title'] = parts.last.trim();
    }
    
    return info;
  }
  
  /// إنشاء كائن Content من معلومات القناة
  Content _createChannel({
    required String title,
    required String url,
    String? id,
    String? logo,
    String? group,
    String? referrer,
  }) {
    // تحديد ID فريد
    final channelId = id ?? title.replaceAll(' ', '_').toLowerCase();
    
    // إنشاء StreamingUrl مع الـ Referrer
    final streamingUrl = StreamingUrl(
      url: url,
      quality: _detectQuality(url),
      httpReferrer: referrer,
    );
    
    // إنشاء QualityOptions
    final qualityOptions = [
      QualityOption(
        label: _detectQuality(url),
        resolution: _detectQuality(url),
        url: url,
      ),
    ];
    
    return Content(
      id: channelId,
      title: _cleanTitle(title),
      imageUrl: logo,
      posterUrl: logo,
      type: ContentType.liveTV,
      isLive: true,
      streamingUrls: [streamingUrl],
      qualityOptions: qualityOptions,
      category: group ?? 'عام',
      country: _detectCountry(title, group),
      language: 'ar',
    );
  }
  
  /// تنظيف عنوان القناة
  String _cleanTitle(String title) {
    // إزالة معلومات الجودة من العنوان
    return title
        .replaceAll(RegExp(r'\(.*?\)'), '')
        .replaceAll(RegExp(r'\[.*?\]'), '')
        .trim();
  }
  
  /// اكتشاف الجودة من الرابط أو العنوان
  String _detectQuality(String url) {
    if (url.contains('1080p') || url.contains('1080')) return '1080p';
    if (url.contains('720p') || url.contains('720')) return '720p';
    if (url.contains('480p') || url.contains('480')) return '480p';
    if (url.contains('360p') || url.contains('360')) return '360p';
    return 'auto';
  }
  
  /// اكتشاف الدولة من المعلومات
  String _detectCountry(String title, String? group) {
    final text = '${title.toLowerCase()} ${group?.toLowerCase() ?? ''}';
    
    if (text.contains('iraq') || text.contains('iq') || text.contains('عراق')) {
      return 'العراق';
    }
    if (text.contains('lebanon') || text.contains('lb') || text.contains('لبنان')) {
      return 'لبنان';
    }
    if (text.contains('egypt') || text.contains('مصر')) {
      return 'مصر';
    }
    if (text.contains('saudi') || text.contains('سعود')) {
      return 'السعودية';
    }
    if (text.contains('uae') || text.contains('إمارات')) {
      return 'الإمارات';
    }
    
    return 'عربي';
  }
  
  /// فلترة القنوات حسب الفئة
  List<Content> filterByCategory(List<Content> channels, String category) {
    return channels
        .where((channel) => 
            channel.category?.toLowerCase() == category.toLowerCase())
        .toList();
  }
  
  /// فلترة القنوات حسب الدولة
  List<Content> filterByCountry(List<Content> channels, String country) {
    return channels
        .where((channel) => 
            channel.country?.toLowerCase() == country.toLowerCase())
        .toList();
  }
  
  /// البحث في القنوات
  List<Content> searchChannels(List<Content> channels, String query) {
    final lowerQuery = query.toLowerCase();
    return channels
        .where((channel) =>
            channel.title.toLowerCase().contains(lowerQuery) ||
            (channel.category?.toLowerCase().contains(lowerQuery) ?? false) ||
            (channel.country?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }
}
