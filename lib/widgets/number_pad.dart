import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sudoku_provider.dart';

class NumberPad extends StatelessWidget {
  final Function(int) onNumberTap;
  final bool isGameActive;
  final bool noteMode;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.isGameActive,
    required this.noteMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (noteMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 16, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 4),
                  Text(
                    'Note Mode',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          // First row with numbers 1-5
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 5; i++) ...[
                _buildNumberButton(context, i),
                if (i < 5) const SizedBox(width: 10),
              ]
            ],
          ),
          const SizedBox(height: 10),
          // Second row with numbers 6-9
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 6; i <= 9; i++) ...[
                _buildNumberButton(context, i),
                if (i < 9) const SizedBox(width: 10),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberButton(BuildContext context, int number) {
    // Get count of this number in the grid
    final sudokuProvider = Provider.of<SudokuProvider>(context, listen: true);
    int count = _countNumberInGrid(sudokuProvider.grid, number);
    int maxCount = 9; // Maximum occurrences of any number in a valid Sudoku

    return SizedBox(
      width: 50, // Increased width
      height: 50, // Increased height
      child: Stack(
        children: [
          ElevatedButton(
            onPressed: isGameActive ? () => onNumberTap(number) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
              padding: EdgeInsets.zero,
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 22, // Larger font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Counter showing occurrences of this number
          Positioned(
            top: 3,
            right: 3,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: count >= maxCount
                    ? Colors.green.withOpacity(0.8)
                    : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count', // Just showing the count without the maximum
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: count >= maxCount ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to count occurrences of a number in the grid
  int _countNumberInGrid(List<List<dynamic>> grid, int number) {
    int count = 0;
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col].value == number) {
          count++;
        }
      }
    }
    return count;
  }
}