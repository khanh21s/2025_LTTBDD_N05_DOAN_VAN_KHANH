import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomNavBar extends StatefulWidget {
  final List<Widget> pages;
  final Function(int)? onPageChanged;

  const BottomNavBar({
    super.key,
    required this.pages,
    required this.onPageChanged,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 👇 Dòng này rất quan trọng: nó buộc widget rebuild khi đổi ngôn ngữ
    final locale = context.locale;

    return Column(
      children: [
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: widget.pages,
          ),
        ),
        BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (_selectedIndex == index) {
              // Nếu bấm lại cùng 1 tab
              if (index == 2) {
                // Nếu là tab Thư viện thì reload lại
                widget.onPageChanged?.call(index);
              }
            } else {
              // Nếu bấm tab khác thì chuyển sang tab đó
              setState(() {
                _selectedIndex = index;
                widget.onPageChanged?.call(index);
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: tr('home', context: context),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: tr('search', context: context),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.library_music_outlined),
              activeIcon: const Icon(Icons.library_music),
              label: tr('library', context: context),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.workspace_premium_outlined),
              activeIcon: const Icon(Icons.workspace_premium),
              label: tr('premium', context: context),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_outlined),
              activeIcon: const Icon(Icons.cancel_outlined),
              label: tr('personal', context: context),
            ),
          ],
        ),
      ],
    );
  }
}
