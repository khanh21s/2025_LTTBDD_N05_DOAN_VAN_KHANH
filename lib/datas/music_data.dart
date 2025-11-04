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

List<MusicItem> alllists = [
  MusicItem(
    imageUrl: "assets/audio/Âm Thầm Bên Em.mp3", 
    subtitle: "K-Pop", 
    title: "",
    audioUrl: "assets/audio/Âm Thầm Bên Em.mp3", 
    author: ""
  ),
  MusicItem(
    imageUrl: "assets/images/chap-chon.jpg", 
    subtitle: "Pop", 
    title: "", 
    audioUrl: "assets/audi/Chập Chờn.mp3", 
    author: ""
  ),
  MusicItem(
    imageUrl: "assets/images/hay-trao-cho-anh.jpg", 
    subtitle: "K-Pop", 
    title: "", 
    audioUrl: "assets/audio/Hãy Trao Cho Anh.mp3", 
    author: ""
  ),
  MusicItem(
    imageUrl: "assets/images/lan-uu-tien.jpg", 
    subtitle: "", 
    title: "Pop", 
    audioUrl: "assets/audio/LÀN ƯU TIÊN.mp3", 
    author: ""
  ),
  MusicItem(
    imageUrl: "assets/images/noi-nay-co-anh.jpg", 
    subtitle: "", 
    title: "Classical", 
    audioUrl: "assets/images/noi-nay-co-anh.jpg", 
    author: ""
  ),
  MusicItem(
    imageUrl: "assets/images/tran-bo-nho.jpg", 
    subtitle: "", 
    title: "", 
    audioUrl: "assets/audio/TRÀN BỘ NHỚ.mp3", 
    author: " "
  ),

];
