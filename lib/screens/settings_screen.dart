import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('⚙️ Settings'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildThemeSection(context, themeProvider),
              const SizedBox(height: 24),
              _buildGameplaySection(context, themeProvider),
              const SizedBox(height: 24),
              _buildAboutSection(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeSection(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme'),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            SwitchListTile(
              title: const Text('Kids Mode'),
              subtitle: const Text('Switch to kid-friendly interface'),
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

  Widget _buildGameplaySection(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gameplay',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('How to Play'),
              subtitle: const Text('Learn Sudoku rules and tips'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showHowToPlayDialog(context),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Statistics'),
              subtitle: const Text('View your game statistics'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(context, '/statistics'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Developer'),
              subtitle: const Text('Built with Flutter'),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Rate Us'),
              subtitle: const Text('Enjoying the game? Leave a review!'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showRateDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎯 How to Play Sudoku'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Basic Rules:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('• Fill the 9×9 grid with numbers 1-9'),
                const Text('• Each row must contain all numbers 1-9'),
                const Text('• Each column must contain all numbers 1-9'),
                const Text('• Each 3×3 box must contain all numbers 1-9'),
                const SizedBox(height: 16),
                const Text(
                  'Tips:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('• Look for cells with only one possible number'),
                const Text('• Use notes to track possible numbers'),
                const Text('• Start with easier difficulties'),
                const Text('• Practice regularly to improve'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it!'),
            ),
          ],
        );
      },
    );
  }

  void _showRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('⭐ Rate Sudoku Master'),
          content: const Text(
            'Are you enjoying Sudoku Master? Your feedback helps us improve the game!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your support! 🎉'),
                  ),
                );
              },
              child: const Text('Rate Now'),
            ),
          ],
        );
      },
    );
  }
}