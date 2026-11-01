class VideoItem {
  final String id;
  final String youtubeId;
  final String title;
  final String englishTitle;
  final String description;
  final String category; // 'All', 'Devices', 'General'
  final String tag;
  final bool isShort;
  final String? deviceName; // 'EVO PLUS', etc.
  final String duration;

  const VideoItem({
    required this.id,
    required this.youtubeId,
    required this.title,
    required this.englishTitle,
    required this.description,
    required this.category,
    required this.tag,
    this.isShort = false,
    this.deviceName,
    required this.duration,
  });

  String get thumbnailUrl => 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
  String get maxThumbnailUrl => 'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg';
  String get directUrl => isShort
      ? 'https://youtube.com/shorts/$youtubeId'
      : 'https://youtu.be/$youtubeId';
  String get embedUrl =>
      'https://www.youtube.com/embed/$youtubeId?autoplay=1&rel=0&modestbranding=1';
}

/// قائمة الفيديوهات
const kShowcaseVideos = [
  VideoItem(
    id: 'evo-plus-glucose-short',
    youtubeId: '4RDgSuPFSSc',
    title: 'EVO PLUS • جهاز قياس السكر',
    englishTitle: 'EVO PLUS Blood Glucose System',
    description: 'شرح عملي لجهاز قياس السكر EVO PLUS.',
    category: 'الأجهزة',
    tag: 'EVO PLUS',
    isShort: true,
    deviceName: 'EVO PLUS',
    duration: '0:58 (Shorts)',
  ),
  VideoItem(
    id: 'lab-instruments-kit',
    youtubeId: '5GauWnPZva4',
    title: 'الأدوات والمعدات الطبية المعملية',
    englishTitle: 'Medical & Clinical Equipment Kit',
    description: 'استعراض الأدوات والمجموعات الطبية.',
    category: 'عام',
    tag: 'CLINICAL KIT',
    isShort: false,
    duration: '12:45',
  ),
];
