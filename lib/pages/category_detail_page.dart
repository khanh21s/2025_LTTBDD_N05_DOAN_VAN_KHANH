import 'package:flutter/material.dart';
import 'package:my_app/datas/music_data.dart';

// để truy cập allLists và MusicItem
class CategoryDetailPage extends StatelessWidget {
  final String category;

  const CategoryDetailPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách nhạc theo thể loại
    final filteredSongs = alllists
        .where((song) => song.subtitle.toLowerCase() == category.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Thể loại: $category'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: filteredSongs.isEmpty
          ? const Center(
              child: Text(
                'Không có bài hát nào trong thể loại này',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return ListTile(
                  leading: Image.asset(song.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(song.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song.author, style: const TextStyle(color: Colors.grey)),
                  onTap: () {
                    // sau này bạn có thể mở trang phát nhạc tại đây
                  },
                );
              },
            ),
    );
  }
}
