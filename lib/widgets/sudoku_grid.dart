import 'package:flutter/material.dart';
import '../models/sudoku_models.dart';
import '../utils/text_utils.dart';

class SudokuGrid extends StatelessWidget {
  final List<List<SudokuCell>> grid;
  final int selectedRow;
  final int selectedCol;
  final Function(int row, int col) onCellTap;
  final bool isGameActive;

  const SudokuGrid({
    super.key,
    required this.grid,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
    required this.isGameActive,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2), // Thinner black border
          borderRadius: BorderRadius.circular(8), // Smaller border radius to match image
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Column(
            children: List.generate(9, (row) {
              return Expanded(
                child: Row(
                  children: List.generate(9, (col) {
                    return Expanded(
                      child: _buildCell(context, row, col),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(BuildContext context, int row, int col) {
    final cell = grid[row][col];
    final isSelected = selectedRow == row && selectedCol == col;
    final isHighlighted = cell.isHighlighted;
    final isError = cell.isError;
    final isConflict = cell.isConflict;

    // Updated colors to match the screenshot exactly
    Color backgroundColor;
    if (isSelected) {
      backgroundColor = const Color(0xFFFFFFC0); // Pale yellow from screenshot
    } else if (isError) {
      backgroundColor = Colors.red.withOpacity(0.3);
    } else if (isConflict) {
      backgroundColor = Colors.orange.withOpacity(0.3); // Highlight conflicting cells
    } else if (isHighlighted) {
      backgroundColor = const Color(0xFFD6EAF8); // Light blue from screenshot
    } else if (cell.isOriginal) {
      backgroundColor = const Color(0xFFF0F0F0); // Light gray for prefilled cells
    } else {
      backgroundColor = Colors.white;
    }

    return GestureDetector(
      onTap: isGameActive ? () => onCellTap(row, col) : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            right: BorderSide(
              color: (col + 1) % 3 == 0 ? Colors.black : Colors.grey.shade300,
              width: (col + 1) % 3 == 0 ? 2 : 0.8,
            ),
            bottom: BorderSide(
              color: (row + 1) % 3 == 0 ? Colors.black : Colors.grey.shade300,
              width: (row + 1) % 3 == 0 ? 2 : 0.8,
            ),
          ),
        ),
        child: Center(
          child: cell.value != 0
              ? SudokuNumberText(
                  number: cell.value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: cell.isOriginal ? FontWeight.bold : FontWeight.normal,
                    color: isConflict 
                        ? Colors.red  // Red text for conflicting cells
                        : cell.isOriginal 
                            ? Colors.black 
                            : Theme.of(context).primaryColor,
                  ),
                )
              : cell.notes.isNotEmpty
                  ? _buildNotes(context, cell.notes)
                  : null,
        ),
      ),
    );
  }

  Widget _buildNotes(BuildContext context, Set<int> notes) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        int number = index + 1;
        bool hasNote = notes.contains(number);
        
        return Center(
          child: hasNote
              ? Text(
                  number.toString(),
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.grey[600],
                  ),
                )
              : null,
        );
      },
    );
  }
}