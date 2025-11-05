import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_app/datas/music_data.dart';
import 'package:my_app/widgets/mini_player.dart';

class AuthorSongsPage extends StatefulWidget {
  final String author;
  final Function(MusicItem) onSongSelected;

  const AuthorSongsPage({
    super.key,
    required this.author,
    required this.onSongSelected,
  });

  @override
  State<AuthorSongsPage> createState() => _AuthorSongsPageState();
}

class _AuthorSongsPageState extends State<AuthorSongsPage> {
  final AudioPlayer _player = AudioPlayer();
  MusicItem? _currentSong;
  bool _isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _playSong(MusicItem song) async {
    setState(() {
      _currentSong = song;
    });

    await _player.setAsset(song.audioUrl);
    await _player.play();

    _player.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });

    widget.onSongSelected(song); // Gọi callback để cập nhật MiniPlayer ở MainScreen
  }

  void _togglePlay() {
    setState(() {
      if (_isPlaying) {
        _player.pause();
      } else {
        _player.play();
      }
    });
  }

  void _openPlayerPage() {
    // Mở trang Player nếu bạn muốn
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
    final authorSongs = alllists.where((song) => song.author == widget.author).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.author, style: const TextStyle(color: Colors.green)),
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
                player: _player,
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
