import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('⚙️ ${l10n.settings}'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildLanguageSection(context, languageProvider, l10n),
              const SizedBox(height: 24),
              _buildThemeSection(context, themeProvider, l10n),
              const SizedBox(height: 24),
              _buildGameplaySection(context, themeProvider, l10n),
              const SizedBox(height: 24),
              _buildAboutSection(context, l10n),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageSection(BuildContext context, LanguageProvider languageProvider, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...languageProvider.supportedLanguages.map((language) {
              final isSelected = languageProvider.currentLanguageCode == language['code'];
              return RadioListTile<String>(
                title: Text(language['name']!),
                value: language['code']!,
                groupValue: languageProvider.currentLanguageCode,
                onChanged: (value) {
                  if (value != null) {
                    languageProvider.changeLanguage(value);
                  }
                },
                secondary: Icon(
                  Icons.language,
                  color: isSelected ? Theme.of(context).primaryColor : null,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, ThemeProvider themeProvider, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appearance,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.darkMode),
              subtitle: Text(l10n.useTheme),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            SwitchListTile(
              title: Text(l10n.kidsMode),
              subtitle: Text(l10n.switchToKidFriendly),
              value: themeProvider.isKidsMode,
              onChanged: (value) => themeProvider.setKidsMode(value),
              secondary: Icon(
                themeProvider.isKidsMode ? Icons.child_care : Icons.person,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameplaySection(BuildContext context, ThemeProvider themeProvider, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.gameplay,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text(l10n.howToPlay),
              subtitle: Text(l10n.learnRules),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showHowToPlayDialog(context, l10n),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: Text(l10n.statistics),
              subtitle: Text(l10n.viewProgress),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(context, '/statistics'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.about,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(l10n.version),
              subtitle: const Text('1.0.0'),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text(l10n.developer),
              subtitle: Text(l10n.builtWithLove),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: Text(l10n.rateUs),
              subtitle: Text(l10n.enjoyingGame),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showRateDialog(context, l10n),
            ),
          ],
        ),
      ),
    );
  }

  void _showHowToPlayDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.sudokuTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.basicRules,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(l10n.fillGrid),
                Text(l10n.eachRowNumbers),
                Text(l10n.eachColumnNumbers),
                Text(l10n.eachBoxNumbers),
                const SizedBox(height: 16),
                Text(
                  l10n.tips,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(l10n.lookForCells),
                Text(l10n.useNotes),
                Text(l10n.startEasier),
                Text(l10n.practiceRegularly),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  void _showRateDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('⭐ ${l10n.rateUs}'),
          content: Text(l10n.enjoyingGame),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.maybeLater),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.thankYou),
                  ),
                );
              },
              child: Text(l10n.rateNow),
            ),
          ],
        );
      },
    );
  }
}