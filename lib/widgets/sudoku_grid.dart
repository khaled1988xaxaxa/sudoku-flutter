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
        margin: const EdgeInsets.all(4), // Add margin to make grid more prominent
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3), // Slightly thicker border
          borderRadius: BorderRadius.circular(12), // Increased border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
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

    Color backgroundColor;
    if (isSelected) {
      backgroundColor = Theme.of(context).primaryColor.withOpacity(0.5);
    } else if (isError) {
      backgroundColor = Colors.red.withOpacity(0.3);
    } else if (isHighlighted) {
      backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
    } else if (cell.isOriginal) {
      backgroundColor = Colors.grey.withOpacity(0.1);
    } else {
      backgroundColor = Colors.transparent;
    }

    return GestureDetector(
      onTap: isGameActive ? () => onCellTap(row, col) : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            right: BorderSide(
              color: (col + 1) % 3 == 0 ? Colors.black : Colors.grey,
              width: (col + 1) % 3 == 0 ? 2 : 0.5,
            ),
            bottom: BorderSide(
              color: (row + 1) % 3 == 0 ? Colors.black : Colors.grey,
              width: (row + 1) % 3 == 0 ? 2 : 0.5,
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
                    color: cell.isOriginal 
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