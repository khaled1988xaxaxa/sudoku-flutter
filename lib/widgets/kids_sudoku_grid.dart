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
          child: Stack(
            children: [
              // The main grid
              GridView.builder(
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
              // Overlay thick borders for box divisions
              _buildBoxBorders(gridSize, boxSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoxBorders(int gridSize, int boxSize) {
    return CustomPaint(
      size: Size.infinite,
      painter: BoxBorderPainter(gridSize: gridSize, boxSize: boxSize),
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

    return GestureDetector(
      onTap: isGameActive ? () => onCellTap(row, col) : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: Colors.grey.shade300, // Thin gray borders for all cells
            width: 0.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 1,
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
                  : null,
        ),
      ),
    );
  }
}

class BoxBorderPainter extends CustomPainter {
  final int gridSize;
  final int boxSize;

  BoxBorderPainter({
    required this.gridSize,
    required this.boxSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Draw vertical lines
    for (int i = 1; i < gridSize; i++) {
      if (i % boxSize == 0) {
        canvas.drawLine(
          Offset(i * size.width / gridSize, 0),
          Offset(i * size.width / gridSize, size.height),
          paint,
        );
      }
    }

    // Draw horizontal lines
    for (int i = 1; i < gridSize; i++) {
      if (i % boxSize == 0) {
        canvas.drawLine(
          Offset(0, i * size.height / gridSize),
          Offset(size.width, i * size.height / gridSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}