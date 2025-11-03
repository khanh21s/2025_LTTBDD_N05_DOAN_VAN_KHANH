import 'package:flutter/material.dart';
import 'package:my_app/datas/music_data.dart';

class AuthorSongsPage extends StatelessWidget {
  final String author;

  const AuthorSongsPage({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách bài hát theo tác giả
    final authorSongs = playlists.where((song) => song.author == author).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          author,
          style: const TextStyle(color: Colors.green),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
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
              onTap: () {
                // TODO: mở player hoặc cập nhật bài đang phát
              },
            ),
          );
        },
      ),
    );
  }
}
