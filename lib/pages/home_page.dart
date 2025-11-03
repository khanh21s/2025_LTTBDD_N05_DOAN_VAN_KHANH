import 'package:flutter/material.dart';
import 'package:my_app/datas/music_data.dart';
import 'package:my_app/datas/podcast_data.dart';
import 'package:my_app/pages/author_song_page.dart';
import 'package:my_app/widgets/mini_player.dart';


class HomePage extends StatefulWidget {
  final Function(MusicItem)? onSongSelected;
  const HomePage({super.key, this.onSongSelected});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showMusic = true; // true = hiển thị Music, false = Podcasts
  MusicItem? currentMusic;

  void playMusic(MusicItem music) {
    setState(() {
      currentMusic = music;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Spotify",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎚️ Nút chuyển giữa Music / Podcasts
                Row(
                  children: [
                    _buildToggleButton("Music", showMusic, () {
                      setState(() => showMusic = true);
                    }),
                    const SizedBox(width: 12),
                    _buildToggleButton("Podcasts", !showMusic, () {
                      setState(() => showMusic = false);
                    }),
                  ],
                ),
                const SizedBox(height: 20),

                // Nội dung thay đổi theo nút được chọn
                if (showMusic) ...
                [
                  _buildMusicSection(), 
                const SizedBox(height: 20,)]
                else _buildPodcastSection(),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // NOW PLAYING BAR 🎶
          if (currentMusic != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.grey[900],
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        currentMusic!.imageUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentMusic!.title,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              overflow: TextOverflow.ellipsis),
                          Text(
                            currentMusic!.subtitle,
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget nút chuyển đổi (bo tròn)
  Widget _buildToggleButton(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.grey[900],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  // 🎵 ALBUM THEO TÁC GIẢ (TỰ ĐỘNG CUỘN)


  // MUSIC SECTION
  Widget _buildMusicSection() {
  // Danh sách tác giả (loại trùng)
  final authors = playlists.map((e) => e.author).toSet().toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Danh sách nhạc hôm nay",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),

      // 🎵 Danh sách nhạc cuộn ngang
      SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final music = playlists[index];
            return GestureDetector(
              onTap: () {
                widget.onSongSelected?.call(music);
                playMusic(music);
              },
              child: Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        music.imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            music.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            music.subtitle,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      const SizedBox(height: 30),

      // 🎧 ALBUM THEO TÁC GIẢ
      const Text(
        "Album theo tác giả",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),

      SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: authors.length,
          itemBuilder: (context, index) {
            final author = authors[index];
            // Lấy ảnh đầu tiên của tác giả làm ảnh bìa
            final cover = playlists.firstWhere((m) => m.author == author).imageUrl;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AuthorSongsPage(author: author),
                  ),
                );
              },
              child: Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        cover,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Xem tất cả bài hát",
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}



  // PODCAST SECTION
  Widget _buildPodcastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Podcast nổi bật",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
