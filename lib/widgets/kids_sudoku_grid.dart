import 'package:flutter/material.dart';
import '../models/sudoku_models.dart';
import '../utils/text_utils.dart';

class KidsSudokuGrid extends StatelessWidget {
  final List<List<SudokuCell>> grid;
  final int selectedRow;
  final int selectedCol;
  final Function(int row, int col) onCellTap;
  final bool isGameActive;

  const KidsSudokuGrid({
    super.key,
    required this.grid,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
    required this.isGameActive,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the size of the grid (4x4 for beginner, 9x9 for others)
    final gridSize = grid.isNotEmpty ? grid.length : 4;
    final boxSize = (gridSize == 4) ? 2 : 3; // 2x2 boxes for 4x4 grid, 3x3 boxes for 9x9

    print("KidsSudokuGrid build: gridSize=$gridSize, isGameActive=$isGameActive, grid.isEmpty=${grid.isEmpty}");

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.purple, width: 4),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
              childAspectRatio: 1.0,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
            ),
            itemCount: gridSize * gridSize,
            itemBuilder: (context, index) {
              final row = index ~/ gridSize;
              final col = index % gridSize;
              return _buildKidsCell(context, row, col, gridSize, boxSize);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildKidsCell(BuildContext context, int row, int col, int gridSize, int boxSize) {
    // Safety check to prevent range errors
    if (grid.isEmpty || row >= grid.length || col >= grid[0].length) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
      );
    }

    final cell = grid[row][col];
    final isSelected = selectedRow == row && selectedCol == col;
    final isHighlighted = cell.isHighlighted;

    // Define better colors for kids mode
    Color backgroundColor;
    if (isSelected) {
      backgroundColor = const Color(0xFFFFEB3B).withOpacity(0.8); // Bright yellow
    } else if (isHighlighted) {
      backgroundColor = const Color(0xFF4ECDC4).withOpacity(0.3); // Teal
    } else if (cell.isOriginal) {
      backgroundColor = const Color(0xFFF8BBD0).withOpacity(0.5); // Light pink
    } else {
      backgroundColor = Colors.white;
    }

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: () {
          print("Cell tap detected: row=$row, col=$col, isGameActive=$isGameActive");
          if (isGameActive) {
            print("Calling onCellTap callback");
            onCellTap(row, col);
          } else {
            print("Game not active, ignoring tap");
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade400, // Slightly darker borders
              width: 1.0,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.orange.withOpacity(0.5),
                blurRadius: 6,
                spreadRadius: 2,
              )
            ] : null,
          ),
          child: Center(
            child: cell.value != 0
                ? SudokuNumberText(
                    number: cell.value,
                    style: TextStyle(
                      fontSize: gridSize == 4
                          ? 36  // Larger font for 4x4 grid
                          : 22, // Good size font for 9x9 grid
                      fontWeight: FontWeight.bold,
                      color: cell.isOriginal 
                          ? const Color(0xFF5E35B1)  // Deep purple for given numbers
                          : const Color(0xFF4CAF50),  // Green for user input
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(1, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  )
                : isSelected
                    ? Icon(
                        Icons.add_circle_outline,
                        color: Colors.orange,
                        size: gridSize == 4 ? 30 : 20,
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                      ),
          ),
        ),
      ),
    );
  }
}