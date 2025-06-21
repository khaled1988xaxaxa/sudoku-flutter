import 'package:flutter/material.dart';

/// A more aggressive approach to prevent Chinese characters from appearing in the app
class ChineseCharacterFilter {
  // These are the specific Chinese characters we've seen in the screenshot
  static const List<String> chineseCharactersToRemove = [
    '洗', // Stats icon
    '浮', // Streak icon
    '悦', // Best Time icon
    '瞬', // Difficulty level icon
    '嫌', // Settings icon
    '燃', // Right corner icon
  ];

  /// Filters out the Chinese characters from the given text
  static String filter(String text) {
    String filtered = text;
    for (final char in chineseCharactersToRemove) {
      filtered = filtered.replaceAll(char, '');
    }
    return filtered;
  }
}

/// A text widget that ensures no Chinese characters are displayed
class CleanText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CleanText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter any Chinese characters from the text
    final filteredText = ChineseCharacterFilter.filter(text);

    return Text(
      filteredText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
