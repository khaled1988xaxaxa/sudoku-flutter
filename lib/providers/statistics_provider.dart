import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/sudoku_models.dart';

class GameStatistics {
  final String id;
  final DateTime date;
  final Difficulty difficulty;
  final int timeInSeconds;
  final bool completed;
  final int hintsUsed;
  final int mistakes;
  final int score;

  GameStatistics({
    required this.id,
    required this.date,
    required this.difficulty,
    required this.timeInSeconds,
    required this.completed,
    required this.hintsUsed,
    required this.mistakes,
    required this.score,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'difficulty': difficulty.index,
    'timeInSeconds': timeInSeconds,
    'completed': completed,
    'hintsUsed': hintsUsed,
    'mistakes': mistakes,
    'score': score,
  };

  factory GameStatistics.fromJson(Map<String, dynamic> json) => GameStatistics(
    id: json['id'],
    date: DateTime.parse(json['date']),
    difficulty: Difficulty.values[json['difficulty']],
    timeInSeconds: json['timeInSeconds'],
    completed: json['completed'],
    hintsUsed: json['hintsUsed'],
    mistakes: json['mistakes'],
    score: json['score'],
  );
}

class StatisticsProvider extends ChangeNotifier {
  List<GameStatistics> _gameHistory = [];
  int _totalGames = 0;
  int _gamesWon = 0;
  int _gamesLost = 0;
  int _totalPlayTime = 0;
  int? _bestTime;
  int _currentStreak = 0;
  int _bestStreak = 0;
  int _hintsUsed = 0;
  Set<String> _achievements = {};

  // Getters
  List<GameStatistics> get gameHistory => _gameHistory;
  int get totalGames => _totalGames;
  int get gamesWon => _gamesWon;
  int get gamesLost => _gamesLost;
  int get totalPlayTime => _totalPlayTime;
  int? get bestTime => _bestTime;
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  int get hintsUsed => _hintsUsed;
  Set<String> get achievements => _achievements;

  double get winRate => _totalGames > 0 ? (_gamesWon / _totalGames) * 100 : 0;

  String get formattedTotalPlayTime {
    int hours = _totalPlayTime ~/ 3600;
    int minutes = (_totalPlayTime % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

  String get formattedBestTime {
    if (_bestTime == null) return '--:--';
    int minutes = _bestTime! ~/ 60;
    int seconds = _bestTime! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Map<Difficulty, int> get difficultyStats {
    Map<Difficulty, int> stats = {};
    for (Difficulty difficulty in Difficulty.values) {
      stats[difficulty] = _gameHistory
          .where((game) => game.difficulty == difficulty && game.completed)
          .length;
    }
    return stats;
  }

  List<GameStatistics> get recentGames {
    return _gameHistory.take(10).toList();
  }

  StatisticsProvider() {
    _loadStatistics();
  }

  Future<void> recordGame({
    required Difficulty difficulty,
    required int timeInSeconds,
    required bool completed,
    required int hintsUsed,
    required int mistakes,
  }) async {
    final game = GameStatistics(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      difficulty: difficulty,
      timeInSeconds: timeInSeconds,
      completed: completed,
      hintsUsed: hintsUsed,
      mistakes: mistakes,
      score: _calculateScore(difficulty, timeInSeconds, hintsUsed, mistakes, completed),
    );

    _gameHistory.insert(0, game);
    
    // Keep only last 1000 games for performance
    if (_gameHistory.length > 1000) {
      _gameHistory = _gameHistory.take(1000).toList();
    }

    _totalGames++;
    _hintsUsed += hintsUsed;

    if (completed) {
      _gamesWon++;
      _totalPlayTime += timeInSeconds;
      _currentStreak++;

      // Update best time
      if (_bestTime == null || timeInSeconds < _bestTime!) {
        _bestTime = timeInSeconds;
      }

      // Update best streak
      if (_currentStreak > _bestStreak) {
        _bestStreak = _currentStreak;
      }
    } else {
      _gamesLost++;
      _currentStreak = 0;
    }

    _checkAchievements();
    await _saveStatistics();
    notifyListeners();
  }

  Future<void> recordHintUsed() async {
    _hintsUsed++;
    await _saveStatistics();
    notifyListeners();
  }

  int _calculateScore(Difficulty difficulty, int timeInSeconds, int hintsUsed, int mistakes, bool completed) {
    if (!completed) return 0;

    int baseScore = 1000;
    
    // Difficulty multiplier
    double difficultyMultiplier = 1.0;
    switch (difficulty) {
      case Difficulty.beginner:
        difficultyMultiplier = 1.0;
        break;
      case Difficulty.easy:
        difficultyMultiplier = 1.2;
        break;
      case Difficulty.medium:
        difficultyMultiplier = 1.5;
        break;
      case Difficulty.hard:
        difficultyMultiplier = 2.0;
        break;
      case Difficulty.expert:
        difficultyMultiplier = 3.0;
        break;
      case Difficulty.kidsBeginner:
        difficultyMultiplier = 0.8;
        break;
      case Difficulty.kidsEasy:
        difficultyMultiplier = 1.0;
        break;
    }

    // Time bonus (faster = better)
    int timeBonus = (600 - timeInSeconds).clamp(0, 600);
    
    // Hint penalty
    int hintPenalty = hintsUsed * 50;
    
    // Mistake penalty
    int mistakePenalty = mistakes * 25;

    double finalScore = (baseScore + timeBonus - hintPenalty - mistakePenalty) * difficultyMultiplier;
    
    return finalScore.clamp(0, double.infinity).round();
  }

  void _checkAchievements() {
    // First win
    if (_gamesWon == 1) {
      _achievements.add('first_win');
    }

    // Speed demon (complete game under 3 minutes)
    if (_bestTime != null && _bestTime! < 180) {
      _achievements.add('speed_demon');
    }

    // Perfectionist (10 games without hints)
    if (_gameHistory.length >= 10) {
      bool noHints = _gameHistory.take(10).every((game) => game.hintsUsed == 0);
      if (noHints) {
        _achievements.add('perfectionist');
      }
    }

    // Streak master (10 wins in a row)
    if (_currentStreak >= 10) {
      _achievements.add('streak_master');
    }

    // Dedicated player (100 games)
    if (_totalGames >= 100) {
      _achievements.add('dedicated_player');
    }

    // Expert level (50 hard games won)
    int hardGamesWon = _gameHistory
        .where((game) => game.difficulty == Difficulty.hard && game.completed)
        .length;
    if (hardGamesWon >= 50) {
      _achievements.add('expert_level');
    }

    // Kids champion (25 kids games won)
    int kidsGamesWon = _gameHistory
        .where((game) => 
            (game.difficulty == Difficulty.kidsBeginner || 
             game.difficulty == Difficulty.kidsEasy) && 
            game.completed)
        .length;
    if (kidsGamesWon >= 25) {
      _achievements.add('kids_champion');
    }
  }

  List<String> get achievementsList {
    return _achievements.toList();
  }

  String getAchievementTitle(String achievement) {
    switch (achievement) {
      case 'first_win':
        return 'First Victory';
      case 'speed_demon':
        return 'Speed Demon';
      case 'perfectionist':
        return 'Perfectionist';
      case 'streak_master':
        return 'Streak Master';
      case 'dedicated_player':
        return 'Dedicated Player';
      case 'expert_level':
        return 'Expert Level';
      case 'kids_champion':
        return 'Kids Champion';
      default:
        return 'Unknown Achievement';
    }
  }

  String getAchievementDescription(String achievement) {
    switch (achievement) {
      case 'first_win':
        return 'Complete your first puzzle';
      case 'speed_demon':
        return 'Complete a puzzle in under 3 minutes';
      case 'perfectionist':
        return 'Complete 10 games without using hints';
      case 'streak_master':
        return 'Win 10 games in a row';
      case 'dedicated_player':
        return 'Play 100 games';
      case 'expert_level':
        return 'Complete 50 hard puzzles';
      case 'kids_champion':
        return 'Complete 25 kids puzzles';
      default:
        return 'Achievement unlocked';
    }
  }

  Future<void> resetStatistics() async {
    _gameHistory.clear();
    _totalGames = 0;
    _gamesWon = 0;
    _gamesLost = 0;
    _totalPlayTime = 0;
    _bestTime = null;
    _currentStreak = 0;
    _bestStreak = 0;
    _hintsUsed = 0;
    _achievements.clear();
    
    await _saveStatistics();
    notifyListeners();
  }

  Future<void> _saveStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    
    final data = {
      'gameHistory': _gameHistory.map((game) => game.toJson()).toList(),
      'totalGames': _totalGames,
      'gamesWon': _gamesWon,
      'gamesLost': _gamesLost,
      'totalPlayTime': _totalPlayTime,
      'bestTime': _bestTime,
      'currentStreak': _currentStreak,
      'bestStreak': _bestStreak,
      'hintsUsed': _hintsUsed,
      'achievements': _achievements.toList(),
    };
    
    await prefs.setString('sudoku_statistics', json.encode(data));
  }

  Future<void> _loadStatistics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString('sudoku_statistics');
      
      if (dataString != null) {
        final data = json.decode(dataString);
        
        _gameHistory = (data['gameHistory'] as List)
            .map((gameJson) => GameStatistics.fromJson(gameJson))
            .toList();
        
        _totalGames = data['totalGames'] ?? 0;
        _gamesWon = data['gamesWon'] ?? 0;
        _gamesLost = data['gamesLost'] ?? 0;
        _totalPlayTime = data['totalPlayTime'] ?? 0;
        _bestTime = data['bestTime'];
        _currentStreak = data['currentStreak'] ?? 0;
        _bestStreak = data['bestStreak'] ?? 0;
        _hintsUsed = data['hintsUsed'] ?? 0;
        _achievements = Set<String>.from(data['achievements'] ?? []);
        
        notifyListeners();
      }
    } catch (e) {
      // If loading fails, start with empty statistics
      print('Error loading statistics: $e');
    }
  }
}