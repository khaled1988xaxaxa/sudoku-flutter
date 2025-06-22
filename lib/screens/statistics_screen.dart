import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/statistics_provider.dart';
import '../models/sudoku_models.dart';
import '../l10n/app_localizations.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('📊 ${l10n.statistics}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showResetDialog(context, l10n),
          ),
        ],
      ),
      body: Consumer<StatisticsProvider>(
        builder: (context, stats, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCards(context, stats, l10n),
                const SizedBox(height: 24),
                _buildDifficultyStats(context, stats, l10n),
                const SizedBox(height: 24),
                _buildAchievements(context, stats, l10n),
                const SizedBox(height: 24),
                _buildRecentGames(context, stats, l10n),
                const SizedBox(height: 80), // Bottom padding
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, StatisticsProvider stats, AppLocalizations l10n) {
    return AnimationConfiguration.staggeredList(
      position: 0,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: Icons.games,
                      title: l10n.totalGames,
                      value: stats.totalGames.toString(),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: Icons.emoji_events,
                      title: l10n.gamesWon,
                      value: stats.gamesWon.toString(),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: Icons.local_fire_department,
                      title: l10n.streak,
                      value: stats.currentStreak.toString(),
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: Icons.timer,
                      title: l10n.bestTime,
                      value: stats.formattedBestTime,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: Icons.percent,
                      title: l10n.winRate,
                      value: '${stats.winRate.toStringAsFixed(1)}%',
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: Icons.access_time,
                      title: 'Total Time',
                      value: stats.formattedTotalPlayTime,
                      color: Colors.indigo,
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

  Widget _buildStatCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyStats(BuildContext context, StatisticsProvider stats, AppLocalizations l10n) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.performanceByDifficulty,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...Difficulty.values.map((difficulty) {
                    final count = stats.difficultyStats[difficulty] ?? 0;
                    return _buildDifficultyRow(context, difficulty, count);
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyRow(BuildContext context, Difficulty difficulty, int count) {
    Color color = _getDifficultyColor(difficulty);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              difficulty.displayName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context, StatisticsProvider stats, AppLocalizations l10n) {
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Achievements',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${stats.achievements.length}/7',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (stats.achievements.isEmpty)
                    const Center(
                      child: Text(
                        'No achievements yet.\nKeep playing to unlock them!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: stats.achievementsList.map((achievement) {
                        return _buildAchievementChip(context, stats, achievement);
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementChip(BuildContext context, StatisticsProvider stats, String achievement) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            stats.getAchievementTitle(achievement),
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentGames(BuildContext context, StatisticsProvider stats, AppLocalizations l10n) {
    return AnimationConfiguration.staggeredList(
      position: 3,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Games',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (stats.recentGames.isEmpty)
                    const Center(
                      child: Text(
                        'No games played yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ...stats.recentGames.map((game) {
                      return _buildGameRow(context, game);
                    }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameRow(BuildContext context, GameStatistics game) {
    Color difficultyColor = _getDifficultyColor(game.difficulty);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: game.completed ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: game.completed ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            game.completed ? Icons.check_circle : Icons.cancel,
            color: game.completed ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: difficultyColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              game.difficulty.displayName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            _formatGameTime(game.timeInSeconds),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 8),
          if (game.completed)
            Text(
              '${game.score}pts',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.beginner:
        return Colors.green;
      case Difficulty.easy:
        return Colors.blue;
      case Difficulty.medium:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
      case Difficulty.expert:
        return Colors.purple;
      case Difficulty.kidsBeginner:
        return Colors.pink;
      case Difficulty.kidsEasy:
        return Colors.cyan;
    }
  }

  String _formatGameTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showResetDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.resetStatistics),
          content: Text(l10n.resetStatisticsMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<StatisticsProvider>(context, listen: false).resetStatistics();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.statisticsResetSuccess)),
                );
              },
              child: Text(l10n.restart, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}