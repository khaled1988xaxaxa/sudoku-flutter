import 'package:flutter/material.dart';
import '../models/sudoku_models.dart';

class KidsNumberPad extends StatelessWidget {
  final Function(int) onNumberTap;
  final bool isGameActive;
  final Difficulty difficulty;

  const KidsNumberPad({
    super.key,
    required this.onNumberTap,
    required this.isGameActive,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the maximum number based on difficulty
    final maxNumber = difficulty == Difficulty.kidsBeginner ? 4 : 9;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 1; i <= maxNumber; i++) ...[
              _buildKidsNumberButton(context, i),
              if (i < maxNumber) const SizedBox(width: 10),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildKidsNumberButton(BuildContext context, int number) {
    final colors = [
      const Color(0xFFFF6B6B), // Red
      const Color(0xFF4ECDC4), // Teal
      const Color(0xFFFFEB3B), // Yellow
      const Color(0xFF4CAF50), // Green
      const Color(0xFF2196F3), // Blue
      const Color(0xFF9C27B0), // Purple
      const Color(0xFFFF9800), // Orange
      const Color(0xFFE91E63), // Pink
      const Color(0xFF00BCD4), // Cyan
    ];

    return GestureDetector(
      onTap: isGameActive ? () => onNumberTap(number) : null,
      child: AnimatedContainer(
        width: 45,
        height: 45,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: colors[number - 1],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colors[number - 1].withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}