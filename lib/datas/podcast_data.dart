class PodcastItem {
  final String title;     // tiêu đề podcast
  final String host;      // người dẫn chương trình
  final String imageUrl;  // đường dẫn ảnh
  final String audioUrl;  // đường dẫn file audio (nếu có)

  PodcastItem({
    required this.title,
    required this.host,
    required this.imageUrl,
    required this.audioUrl,
  });
}

// Danh sách podcast mẫu
List<PodcastItem> podcasts = [
  PodcastItem(
    title: "Tâm sự tuổi trẻ",
    host: "The Present Writer",
    imageUrl: "assets/images/podcast1.jpg",
    audioUrl: "assets/audio/podcast1.mp3",
  ),
  PodcastItem(
    title: "Wake Up with Motivation",
    host: "Motivational Daily",
    imageUrl: "assets/images/podcast2.jpg",
    audioUrl: "assets/audio/podcast2.mp3",
  ),
  PodcastItem(
    title: "Chuyện nhỏ - Vietcetera",
    host: "Vietcetera Production",
    imageUrl: "assets/images/podcast3.jpg",
    audioUrl: "assets/audio/podcast3.mp3",
  ),
  PodcastItem(
    title: "Everyday Greatness",
    host: "Nick Hewer",
    imageUrl: "assets/images/podcast4.jpg",
    audioUrl: "assets/audio/podcast4.mp3",
  ),
];
