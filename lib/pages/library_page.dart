import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_app/datas/music_data.dart';

class LibraryPage extends StatefulWidget {
  final Function(MusicItem)? onSongSelected; 
  const LibraryPage({super.key, this.onSongSelected});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String _selectedFilter = "playlist";
  MusicItem? _currentSong;
  AudioPlayer? _player;
  bool _isPlaying = false;

  List<MusicItem> dsnghsi = [
    MusicItem(
        title: "Sơn Tùng M-TP",
        subtitle: "Pop, V-Pop",
        imageUrl: "assets/images/maxresdefault.jpg",
        audioUrl: "",
        author: ""),
    MusicItem(
        title: "Đen Vâu",
        subtitle: "Rap, Hip-hop",
        imageUrl: "assets/images/Son-Tung-MTP2.jpg",
        audioUrl: "",
        author: "")
  ];

  List<MusicItem> dsalbum = [
    MusicItem(
        title: "Chúng Ta Của Hiện Tại",
        subtitle: "Sơn Tùng M-TP • 2020",
        imageUrl:
            "https://i.scdn.co/image/ab67616d0000b2735f68a9a5b123abcfa89342b8",
        audioUrl: "",
        author: ""),
    MusicItem(
        title: "99%",
        subtitle: "Đức Phúc • 2022",
        imageUrl:
            "https://i.scdn.co/image/ab67616d0000b273ddfba54a2f8d481cbb123a7c",
        audioUrl: "",
        author: "")
  ];

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _addPlaylist() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController subtitleController = TextEditingController();

        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: Text("add_playlist".tr(),
              style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController),
                TextField(controller: subtitleController),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("cancel".tr(),
                  style: const TextStyle(color: Colors.redAccent)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("add".tr(),
                  style: const TextStyle(color: Colors.greenAccent)),
              onPressed: () {
                setState(() {
                  playlists.add(MusicItem(
                      title: titleController.text.trim(),
                      imageUrl: "",
                      subtitle: subtitleController.text.trim(),
                      audioUrl: "",
                      author: ""));
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add, color: Colors.white),
              title:
                  Text("add_playlist".tr(), style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _addPlaylist();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.white),
              title:
                  Text("add_artist".tr(), style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.album, color: Colors.white),
              title:
                  Text("add_album".tr(), style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  int _getItemCount() {
    if (_selectedFilter == "playlist") return playlists.length;
    if (_selectedFilter == "artist") return dsnghsi.length;
    if (_selectedFilter == "album") return dsalbum.length;
    return 0;
  }

  MusicItem _getItem(String filter, int index) {
    if (filter == "playlist") return playlists[index];
    if (filter == "artist") return dsnghsi[index];
    if (filter == "album") return dsalbum[index];
    return MusicItem(
        imageUrl: "",
        subtitle: "",
        title: "no_data".tr(),
        audioUrl: "",
        author: "");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'library'.tr(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchPagelib(selectedFilter: _selectedFilter),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: _showAddOptions,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 🔹 Bộ lọc
            Row(
              children: [
                _buildChip('playlist', 'Playlist'),
                const SizedBox(width: 8),
                _buildChip('artist', 'Nghệ sĩ'),
                const SizedBox(width: 8),
                _buildChip('album', 'Album'),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Danh sách
            Expanded(
              child: ListView.builder(
                itemCount: _getItemCount(),
                itemBuilder: (context, index) {
                  final item = _getItem(_selectedFilter, index);
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey[800],
                            child: const Icon(Icons.music_note,
                                color: Colors.white),
                          );
                        },
                      ),
                    ),
                    title: Text(item.title,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(item.subtitle,
                        style: TextStyle(color: Colors.grey[600])),
                    onTap: () {
                      if (item.audioUrl.isNotEmpty) {
                        widget.onSongSelected?.call(item);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String key, String fallbackText) {
    final translatedText = tr(key);
    return FilterChip(
      label: Text(translatedText.isEmpty ? fallbackText : translatedText),
      labelStyle: const TextStyle(color: Colors.white),
      selected: _selectedFilter == key,
      selectedColor: Colors.green,
      backgroundColor: const Color(0xFF282828),
      onSelected: (_) => _onFilterSelected(key),
    );
  }

}

// 🔹 Trang tìm kiếm trong Library
class SearchPagelib extends StatefulWidget {
  final String selectedFilter;
  const SearchPagelib({super.key, required this.selectedFilter});

  @override
  State<SearchPagelib> createState() => _SearchPagelibState();
}

class _SearchPagelibState extends State<SearchPagelib> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText:
                tr('search_in', args: [tr(widget.selectedFilter)]), // 🔹 dynamic
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _searchText = value),
        ),
      ),
      body: Center(
        child: Text(
          _searchText.isEmpty
              ? tr('enter_to_search', args: [tr(widget.selectedFilter)])
              : tr('results_for', args: [_searchText]),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
