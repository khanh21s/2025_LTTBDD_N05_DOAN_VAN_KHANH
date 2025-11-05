import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_app/datas/music_data.dart';
import 'package:my_app/widgets/mini_player.dart';

class AuthorSongsPage extends StatefulWidget {
  final String author;
  final AudioPlayer player;
  final Function(MusicItem) onSongSelected;

  const AuthorSongsPage({
    super.key,
    required this.author,
    required this.onSongSelected,
    required this.player,
  });

  @override
  State<AuthorSongsPage> createState() => _AuthorSongsPageState();
}

class _AuthorSongsPageState extends State<AuthorSongsPage> {
  MusicItem? _currentSong;
  bool _isPlaying = false;

  void _playSong(MusicItem song) async {
    setState(() {
      _currentSong = song;
    });

    try {
      await widget.player.setAsset(song.audioUrl);
      await widget.player.play();

      widget.player.playerStateStream.listen((state) {
        setState(() {
          _isPlaying = state.playing;
        });
      });

      // Gọi callback để cập nhật MiniPlayer ở MainScreen
      widget.onSongSelected(song);
    } catch (e) {
      debugPrint("Lỗi phát nhạc: $e");
    }
  }

  void _togglePlay() {
    setState(() {
      if (_isPlaying) {
        widget.player.pause();
      } else {
        widget.player.play();
      }
    });
  }

  void _openPlayerPage() {
    // Nếu bạn muốn mở trang Player, có thể thêm logic ở đây
  }

  void _addToLibrary(BuildContext context, MusicItem song) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${song.title} đã thêm vào thư viện 🎵'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authorSongs =
        alllists.where((song) => song.author == widget.author).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.author,
          style: const TextStyle(color: Colors.green),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: authorSongs.length,
            itemBuilder: (context, index) {
              final music = authorSongs[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      music.imageUrl,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    music.title,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    music.subtitle,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  onTap: () => _playSong(music),
                ),
              );
            },
          ),

          // 🟩 MiniPlayer hiển thị ngay trong trang album
          if (_currentSong != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MiniPlayer(
                player: widget.player, // ✅ Dùng player chung
                currentSong: _currentSong,
                isPlaying: _isPlaying,
                onTogglePlay: _togglePlay,
                onTap: _openPlayerPage,
                onAdd: () {
                  if (_currentSong != null) {
                    _addToLibrary(context, _currentSong!);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
