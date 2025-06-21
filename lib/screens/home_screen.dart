import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/theme_provider.dart';
import '../providers/statistics_provider.dart';
import '../models/sudoku_models.dart';
import '../utils/app_theme.dart';
import '../utils/chinese_filter.dart'; // Import the Chinese character filter

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Theme(
          data: themeProvider.isKidsMode ? AppTheme.kidsTheme : Theme.of(context),
          child: Scaffold(
            body: Container(
              decoration: themeProvider.isKidsMode
                  ? const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFF6B6B),
                          Color(0xFF4ECDC4),
                          Color(0xFFFFEB3B),
                          Color(0xFF4CAF50),
                        ],
                      ),
                    )
                  : null,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildHeader(context, themeProvider),
                      const SizedBox(height: 30),
                      _buildQuickStats(context),
                      const SizedBox(height: 30),
                      _buildGameModes(context, themeProvider),
                      const SizedBox(height: 30),
                      _buildQuickActions(context, themeProvider),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: -50.0,
        child: FadeInAnimation(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        themeProvider.isKidsMode ? '🧩 Kids Sudoku' : '🎯 Sudoku Master',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isKidsMode ? Colors.white : null,
                        ),
                      ),
                      Text(
                        themeProvider.isKidsMode
                            ? 'Fun puzzles for young minds!'
                            : 'Challenge your mind with numbers',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: themeProvider.isKidsMode 
                              ? Colors.white.withOpacity(0.9) 
                              : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                    icon: Icon(
                      Icons.settings,
                      color: themeProvider.isKidsMode ? Colors.white : null,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (themeProvider.isKidsMode)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.child_care, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Kids Mode Active',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Consumer<StatisticsProvider>(
      builder: (context, stats, child) {
        return AnimationConfiguration.staggeredList(
          position: 1,
          duration: const Duration(milliseconds: 600),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        icon: Icons.emoji_events,
                        label: 'Games Won',
                        value: stats.gamesWon.toString(),
                        color: Colors.amber,
                      ),
                      _buildStatItem(
                        context,
                        icon: Icons.local_fire_department,
                        label: 'Streak',
                        value: stats.currentStreak.toString(),
                        color: Colors.orange,
                      ),
                      _buildStatItem(
                        context,
                        icon: Icons.timer,
                        label: 'Best Time',
                        value: stats.formattedBestTime,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        CleanText(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        CleanText(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGameModes(BuildContext context, ThemeProvider themeProvider) {
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Your Challenge',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isKidsMode ? Colors.white : null,
                ),
              ),
              const SizedBox(height: 16),
              if (themeProvider.isKidsMode) ...[
                _buildKidsGameModes(context),
              ] else ...[
                _buildRegularGameModes(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKidsGameModes(BuildContext context) {
    return Column(
      children: [
        _buildGameModeCard(
          context,
          title: '🌟 Kids Beginner',
          subtitle: 'Perfect for first-time players',
          difficulty: Difficulty.kidsBeginner,
          color: const Color(0xFF4CAF50),
          isKidsMode: true,
        ),
        const SizedBox(height: 12),
        _buildGameModeCard(
          context,
          title: '🎯 Kids Easy',
          subtitle: 'A bit more challenging',
          difficulty: Difficulty.kidsEasy,
          color: const Color(0xFF2196F3),
          isKidsMode: true,
        ),
      ],
    );
  }

  Widget _buildRegularGameModes(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGameModeCard(
                context,
                title: 'Beginner',
                subtitle: 'New to Sudoku?',
                difficulty: Difficulty.beginner,
                color: const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGameModeCard(
                context,
                title: 'Easy',
                subtitle: 'Gentle challenge',
                difficulty: Difficulty.easy,
                color: const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGameModeCard(
                context,
                title: 'Medium',
                subtitle: 'Getting serious',
                difficulty: Difficulty.medium,
                color: const Color(0xFFFFC107),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGameModeCard(
                context,
                title: 'Hard',
                subtitle: 'Real challenge',
                difficulty: Difficulty.hard,
                color: const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildGameModeCard(
          context,
          title: 'Expert',
          subtitle: 'Only for masters',
          difficulty: Difficulty.expert,
          color: const Color(0xFFF44336),
        ),
      ],
    );
  }

  Widget _buildGameModeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Difficulty difficulty,
    required Color color,
    bool isKidsMode = false,
  }) {
    return Card(
      elevation: isKidsMode ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isKidsMode ? 20 : 12),
      ),
      child: InkWell(
        onTap: () {
          if (isKidsMode) {
            Navigator.pushNamed(
              context,
              '/kids',
              arguments: difficulty,
            );
          } else {
            Navigator.pushNamed(
              context,
              '/sudoku',
              arguments: difficulty,
            );
          }
        },
        borderRadius: BorderRadius.circular(isKidsMode ? 20 : 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isKidsMode ? 20 : 12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            children: [
              Icon(
                isKidsMode ? Icons.stars : Icons.grid_on,
                color: color,
                size: isKidsMode ? 48 : 40,
              ),
              const SizedBox(height: 12),
              CleanText(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              CleanText(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeProvider themeProvider) {
    return AnimationConfiguration.staggeredList(
      position: 3,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: Icons.bar_chart,
                      title: 'Statistics',
                      subtitle: 'View your progress',
                      onTap: () => Navigator.pushNamed(context, '/statistics'),
                      color: themeProvider.isKidsMode ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      icon: themeProvider.isKidsMode ? Icons.person : Icons.child_care,
                      title: themeProvider.isKidsMode ? 'Adult Mode' : 'Kids Mode',
                      subtitle: themeProvider.isKidsMode ? 'Switch to adult' : 'Fun for kids',
                      onTap: () => themeProvider.toggleKidsMode(),
                      color: themeProvider.isKidsMode ? Colors.white : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                color: color ?? Theme.of(context).primaryColor,
                size: 32,
              ),
              const SizedBox(height: 8),
              CleanText(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              CleanText(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
