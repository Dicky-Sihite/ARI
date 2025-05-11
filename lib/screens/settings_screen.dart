import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔲 Switch Dark Mode
            _buildSimpleBox(context, [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mode Gelap'),
                    Switch(
                      value: isDark,
                      onChanged: (value) => themeProvider.toggleTheme(value),
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(height: 16),

            // 🔲 Info setting lainnya
            _buildSimpleBox(context, [
              _settingRow('Suhu', 'Celcius °C'),
              Divider(height: 1, color: Colors.grey.shade300),
              _settingRow('Angin', 'Mil Perjam(mpj)'),
              Divider(height: 1, color: Colors.grey.shade300),
              _settingRow('Tekanan Udara', 'Hektopaskal (hPa)'),
              Divider(height: 1, color: Colors.grey.shade300),
              _settingRow('Visibilitas', 'kilometer (Km)'),
            ]),
            SizedBox(height: 16),

            // 🔲 Navigasi ke About
            _buildSimpleBox(context, [
              ListTile(
                title: Text('Tentang ARI'),
                onTap: () => Navigator.pushNamed(context, '/about'),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _settingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSimpleBox(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(children: children),
    );
  }
}
