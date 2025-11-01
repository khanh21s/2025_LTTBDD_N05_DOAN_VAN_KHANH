import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String audioUrl;
  final AudioPlayer? existingPlayer;
  final VoidCallback? onClose; // callback khi bấm nút X

  const PlayerPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.audioUrl,
    this.existingPlayer,
    this.onClose,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = widget.existingPlayer ?? AudioPlayer();
    if (widget.existingPlayer == null) _init();

    _player.durationStream.listen((d) {
      if (d != null) setState(() => _duration = d);
    });
    _player.positionStream.listen((p) {
      setState(() => _position = p);
    });
    _player.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
    });
  }

  Future<void> _init() async {
    try {
      await _player.setAsset(widget.audioUrl);
    } catch (e) {
      print("Lỗi khi phát nhạc: $e");
    }
  }

  @override
  void dispose() {
    if (widget.existingPlayer == null) _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              widget.onClose?.call(); // báo cho LibraryPage ẩn mini player
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: widget.imageUrl.startsWith("http")
                ? Image.network(widget.imageUrl, width: 250, height: 250, fit: BoxFit.cover)
                : Image.asset(widget.imageUrl, width: 250, height: 250, fit: BoxFit.cover),
          ),
          const SizedBox(height: 30),
          Slider(
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.grey,
            value: _position.inSeconds.toDouble(),
            max: _duration.inSeconds.toDouble() == 0 ? 1 : _duration.inSeconds.toDouble(),
            onChanged: (value) {
              _player.seek(Duration(seconds: value.toInt()));
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position), style: const TextStyle(color: Colors.white)),
                Text(_formatDuration(_duration), style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          IconButton(
            iconSize: 80,
            color: Colors.white,
            icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
            onPressed: () {
              _isPlaying ? _player.pause() : _player.play();
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
