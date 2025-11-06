import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _currentLanguage = "vi"; // Mặc định là tiếng Việt
  final Map<String, bool> _settings = {
    'dataSaver': false,
    'autoplay': true,
    'updateNotifications': true,
    'emailNotifications': false,
  };

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // 🔹 Load ngôn ngữ đã lưu
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('languageCode') ?? 'vi';
    setState(() {
      _currentLanguage = lang;
    });
  }

  // 🔹 Lưu ngôn ngữ khi thay đổi
  Future<void> _changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);
    setState(() {
      _currentLanguage = code;
    });

    // 🔹 Đổi ngôn ngữ toàn app
    await context.setLocale(Locale(code));
  }

  // 🔹 Hiển thị hộp chọn ngôn ngữ
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text("select_language".tr(), // 🔸 dùng key từ JSON
              style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption("Tiếng Việt", "vi"),
              _buildLanguageOption("English", "en"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String name, String code) {
    return ListTile(
      title: Text(name, style: const TextStyle(color: Colors.white)),
      trailing: _currentLanguage == code
          ? const Icon(Icons.check, color: Color(0xFF1ED760))
          : null,
      onTap: () {
        _changeLanguage(code);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Text(
          'settings_title'.tr(), // 🔸 đa ngôn ngữ
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          const SizedBox(height: 10),

          _buildSectionTitle("account".tr()),
          _buildSettingTile(
            icon: Icons.person_outline,
            title: "view_profile".tr(),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          _buildSettingTile(
            icon: Icons.lock_outline,
            title: "change_password".tr(),
            onTap: () {},
          ),
          const Divider(color: Colors.grey),

          _buildSectionTitle("playback".tr()),
          _buildSwitchTile(
            keyName: 'dataSaver',
            icon: Icons.wifi_tethering,
            title: "data_saver".tr(),
            subtitle: "data_saver_desc".tr(),
          ),
          _buildSwitchTile(
            keyName: 'autoplay',
            icon: Icons.play_circle_outline,
            title: "autoplay".tr(),
            subtitle: "autoplay_desc".tr(),
          ),
          const Divider(color: Colors.grey),

          _buildSectionTitle("notifications".tr()),
          _buildSwitchTile(
            keyName: 'updateNotifications',
            icon: Icons.notifications_outlined,
            title: "update_notifications".tr(),
          ),
          _buildSettingTile(
            icon: Icons.language,
            title: "language".tr(),
            onTap: _showLanguageDialog,
          ),
          const Divider(color: Colors.grey),

          _buildSectionTitle("about".tr()),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: "about_app".tr(),
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.logout,
            title: "logout".tr(),
            color: Colors.redAccent,
            onTap: () {},
          ),

          const SizedBox(height: 30),
          Center(
            child: Text(
              "version".tr(args: ['1.0.0']),
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Các widget phụ
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1ED760),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Color color = Colors.white,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13))
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String keyName,
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return SwitchListTile(
      activeColor: const Color(0xFF1ED760),
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.grey.shade800,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13))
          : null,
      secondary: Icon(icon, color: Colors.white),
      value: _settings[keyName] ?? false,
      onChanged: (v) {
        setState(() {
          _settings[keyName] = v;
        });
      },
    );
  }
}
