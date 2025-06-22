import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sudoku_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/text_utils.dart';

class NumberPad extends StatelessWidget {
  final Function(int) onNumberTap;
  final VoidCallback onToggleNotes;
  final bool noteMode;
  final bool isGameActive;

  const NumberPad({
    super.key,
    required this.onNumberTap,
    required this.onToggleNotes,
    required this.noteMode,
    required this.isGameActive,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Note mode toggle button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isGameActive ? onToggleNotes : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: noteMode
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.surface,
                foregroundColor: noteMode
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(noteMode ? Icons.edit : Icons.edit_outlined),
                  const SizedBox(width: 8),
                  Text(l10n.noteMode),
                ],
              ),
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
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: PaintedNumberWidget(
                number: number,
                color: Colors.white,
                size: 22.0,
                fontWeight: FontWeight.bold,
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
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: count >= maxCount ? Colors.white : Colors.black,
                    fontFamily: 'Roboto',
                    locale: const Locale('en', 'US'),
                  ),
                  textDirection: TextDirection.ltr,
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