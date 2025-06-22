import 'package:flutter/material.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('ar', ''), // Arabic
    Locale('de', ''), // German
  ];

  // App Title and General
  String get appTitle;
  String get sudokuMaster;
  String get kidsSudoku;
  String get challengeMind;
  String get funPuzzles;
  String get kidsMode;
  String get adultMode;
  String get kidsModeActive;

  // Game Modes
  String get chooseChallenge;
  String get beginner;
  String get easy;
  String get medium;
  String get hard;
  String get expert;
  String get kidsBeginner;
  String get kidsEasy;

  // Game Mode Descriptions
  String get newToSudoku;
  String get gentleChallenge;
  String get gettingSerious;
  String get realChallenge;
  String get onlyForMasters;
  String get perfectForFirstTime;
  String get bitMoreChallenging;

  // Statistics
  String get statistics;
  String get viewProgress;
  String get gamesWon;
  String get streak;
  String get bestTime;
  String get totalGames;
  String get winRate;
  String get averageTime;
  String get fastestSolve;
  String get longestStreak;

  // Game Actions
  String get newGame;
  String get pause;
  String get resume;
  String get hint;
  String get undo;
  String get clear;
  String get settings;
  String get back;
  String get restart;
  String get quit;

  // Game States
  String get gameComplete;
  String get gamePaused;
  String get congratulations;
  String get wellDone;
  String get excellent;
  String get amazing;
  String get solvedIn;
  String get playAgain;
  String get nextLevel;

  // Settings
  String get theme;
  String get language;
  String get sound;
  String get vibration;
  String get autoSave;
  String get showTimer;
  String get showHints;
  String get darkMode;
  String get lightMode;
  String get systemMode;

  // Languages
  String get english;
  String get arabic;
  String get german;

  // Kids Mode Specific
  String get switchToAdult;
  String get funForKids;
  String get greatJob;
  String get keepGoing;
  String get youDidIt;
  String get tryAgain;

  // Dialogs
  String get confirmQuit;
  String get quitMessage;
  String get yes;
  String get no;
  String get cancel;
  String get ok;
  String get save;

  // Errors
  String get invalidMove;
  String get noHintsLeft;
  String get gameNotStarted;
  String get error;

  // Time
  String get seconds;
  String get minutes;
  String get hours;
  String get time;

  // Additional game elements
  String get level;
  String get hintsLeft;
  String get resetStatistics;
  String get resetStatisticsMessage;
  String get statisticsResetSuccess;
  String get restartGame;
  String get restartGameMessage;
  String get startOver;
  String get keepPlaying;
  String get home;
  String get version;
  String get developer;
  String get builtWithLove;
  String get rateUs;
  String get enjoyingGame;
  String get howToPlay;
  String get learnRules;
  String get basicRules;
  String get tips;
  String get fillGrid;
  String get eachRowNumbers;
  String get eachColumnNumbers;
  String get eachBoxNumbers;
  String get lookForCells;
  String get useNotes;
  String get startEasier;
  String get practiceRegularly;
  String get useTheme;
  String get switchToKidFriendly;
  String get rateNow;
  String get maybeLater;
  String get thankYou;
  String get appearance;
  String get gameplay;
  String get about;
  String get sudokuTitle;

  // Missing game controls and UI elements
  String get notes;
  String get redo;
  String get noHints;
  String get won;
  String get best;
  String get performanceByDifficulty;
  String get noteMode;
  String get hintsUsed;
  String get timeLabel;

  // Kids game messages
  String get letsStart;
  String get perfectWellDone;
  String get excellentChoice;
  String get youreOnFire;
  String get brilliantMove;
  String get outstanding;
  String get tryDifferentNumber;
  String get checkRowColumn;
  String get lookAtBox;
  String get thinkWhatFits;
  String get youreClose;
  String get amazingSolved;
  String get fantasticPerfect;
  String get wonderfulDidIt;
  String get brilliantOutstanding;
  String get perfectMaster;
  String get cellCleared;

  // Additional missing strings
  String get mistakes;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'de'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ar':
        return AppLocalizationsAr();
      case 'de':
        return AppLocalizationsDe();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}