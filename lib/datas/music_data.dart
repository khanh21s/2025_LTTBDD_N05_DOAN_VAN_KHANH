import 'package:my_app/pages/library_page.dart';
class MusicItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String audioUrl;
  final String author;

  MusicItem({
    required this.imageUrl,
    required this.subtitle,
    required this.title ,
    required this.audioUrl,
    required this.author
  });
}
List<MusicItem> playlists = [
  MusicItem(
    title: "10 Mất 1 Còn Không",
    subtitle: "Danh sách phát • V-Pop",
    imageUrl: "assets/images/10-mat-1-con-khong.jpg",
    audioUrl: "assets/audio/10 Mất 1 Còn Không (Td Remix).mp3",
    author: "tac gia 1"
  ),
  MusicItem(
    title: "Để Anh Lương Thiện",
    subtitle: "Danh sách phát • Relax",
    imageUrl: "assets/images/de-anh-luong-thien.jpg",
    audioUrl: "assets/audio/Để Anh Lương Thiện (Huy PT Remix).mp3",
    author: "tac gia 1"

  ),
  MusicItem(
    title: "chẳng phải tình đầu sao đau đến thế",
    subtitle: "Danh sách phát • EDM",
    imageUrl: "assets/images/chang-phai-tinh-dau-sao-dau-den-the.jpg",
    audioUrl: "assets/audio/chẳng phải tình đầu sao đau đến thế.mp3",
    author: "tac gia 2"
  ),
];
