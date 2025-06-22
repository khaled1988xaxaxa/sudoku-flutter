import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/theme_provider.dart';
import 'providers/sudoku_provider.dart';
import 'providers/kids_provider.dart';
import 'providers/statistics_provider.dart';
import 'providers/language_provider.dart';
import 'screens/custom_home_screen.dart'; // Use custom screen instead
import 'screens/sudoku_game_screen.dart';
import 'screens/kids_game_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/app_theme.dart';
import 'l10n/app_localizations.dart';

// Create a global navigator key for accessing context from providers
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SudokuProvider()),
        ChangeNotifierProvider(create: (_) => KidsProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            title: 'Sudoku Master',
            debugShowCheckedModeBanner: false,
            
            // Localization configuration
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            
            theme: AppTheme.lightTheme.copyWith(
              // Explicitly set text theme to use Roboto font
              textTheme: AppTheme.lightTheme.textTheme.apply(
                fontFamily: 'Roboto',
                fontFamilyFallback: ['Arial', 'Helvetica', 'sans-serif'],
              ),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              // Explicitly set text theme to use Roboto font
              textTheme: AppTheme.darkTheme.textTheme.apply(
                fontFamily: 'Roboto',
                fontFamilyFallback: ['Arial', 'Helvetica', 'sans-serif'],
              ),
            ),
            themeMode: themeProvider.themeMode,
            navigatorKey: navigatorKey,
            home: const CustomHomeScreen(),
            routes: {
              '/sudoku': (context) => const SudokuGameScreen(),
              '/kids': (context) => const KidsGameScreen(),
              '/statistics': (context) => const StatisticsScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}