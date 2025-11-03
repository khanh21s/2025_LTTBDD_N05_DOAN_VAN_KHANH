import 'package:flutter/material.dart';
import 'package:my_app/datas/music_data.dart';
import 'package:my_app/datas/podcast_data.dart';
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
                _buildAuthorAlbumSection(), 
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
Widget _buildAuthorAlbumSection() {
  final authors = playlists.map((e) => e.author).toSet().toList();
  final PageController pageController = PageController(viewportFraction: 0.96);

  // Tự động chuyển trang sau 2 giây
  WidgetsBinding.instance.addPostFrameCallback((_) {
    int currentPage = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!pageController.hasClients) return false;
      currentPage = (currentPage + 1) % authors.length;
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return true;
    });
  });

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Album theo tác giả",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),

      // PageView cuộn ngang
      SizedBox(
        height: 210,
        child: PageView.builder(
          controller: pageController,
          itemCount: authors.length,
          itemBuilder: (context, index) {
            final author = authors[index];
            final songs = playlists.where((e) => e.author == author).toList();
            final image = songs.first.imageUrl;

            return AnimatedBuilder(
              animation: pageController,
              builder: (context, child) {
                double value = 1.0;
                if (pageController.position.haveDimensions) {
                  value = (pageController.page! - index).abs();
                  value = (1 - (value * 0.2)).clamp(0.8, 1.0);
                }
                return Transform.scale(scale: value, child: child);
              },
              child: GestureDetector(
                onTap: () {
                  // Khi bấm vào album -> hiện danh sách bài của tác giả
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ảnh + tên tác giả
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  image,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                author,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Danh sách bài hát của tác giả
                          ...songs.map((song) => ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    song.imageUrl,
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(song.title,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                subtitle: Text(song.subtitle,
                                    style:
                                        const TextStyle(color: Colors.grey)),
                                onTap: () {
                                  widget.onSongSelected?.call(song);
                                  Navigator.pop(context);
                                },
                              )),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                        child: Image.asset(
                          image,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        author,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Album nổi bật",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

  // MUSIC SECTION
  Widget _buildMusicSection() {
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

      // Danh sách nhạc cuộn ngang
      SizedBox(
        height: 200, // chiều cao cố định cho mỗi item
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // cuộn ngang
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final music = playlists[index];
            return GestureDetector(
              onTap: () {
                // TODO: mở trình phát nhạc hoặc cập nhật currentMusic
                widget.onSongSelected?.call(music);
              },
              child: Container(
                width: 160, // độ rộng mỗi item
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh bài hát
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        music.imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Tiêu đề và phụ đề
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
