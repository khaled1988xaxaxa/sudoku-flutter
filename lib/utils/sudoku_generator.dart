import 'dart:math';
import '../models/sudoku_models.dart';

class SolutionCounter {
  int count = 0;
}

class SudokuGenerator {
  static final Random _random = Random();

  static List<List<SudokuCell>> generatePuzzle(Difficulty difficulty) {
    // Generate a complete valid Sudoku grid
    List<List<int>> completeGrid = _generateCompleteGrid();
    
    // Create SudokuCell grid from complete grid
    List<List<SudokuCell>> cellGrid = List.generate(
      9,
      (row) => List.generate(
        9,
        (col) => SudokuCell(value: completeGrid[row][col], isOriginal: true),
      ),
    );

    // Remove cells based on difficulty
    _removeCells(cellGrid, difficulty.cellsToRemove);

    return cellGrid;
  }

  static List<List<int>> _generateCompleteGrid() {
    List<List<int>> grid = List.generate(9, (_) => List.filled(9, 0));
    _fillGrid(grid);
    return grid;
  }

  static bool _fillGrid(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          List<int> numbers = List.generate(9, (i) => i + 1);
          numbers.shuffle(_random);

          for (int num in numbers) {
            if (_isValidMove(grid, row, col, num)) {
              grid[row][col] = num;
              if (_fillGrid(grid)) {
                return true;
              }
              grid[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  static void _removeCells(List<List<SudokuCell>> grid, int cellsToRemove) {
    int removed = 0;
    List<List<int>> positions = [];
    
    // Create list of all positions
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        positions.add([row, col]);
      }
    }
    
    // Shuffle positions
    positions.shuffle(_random);
    
    // Remove cells
    for (List<int> pos in positions) {
      if (removed >= cellsToRemove) break;
      
      int row = pos[0];
      int col = pos[1];
      
      // Temporarily remove the cell
      int originalValue = grid[row][col].value;
      grid[row][col].value = 0;
      grid[row][col] = SudokuCell(value: 0, isOriginal: false);
      
      // Check if puzzle still has unique solution
      if (_hasUniqueSolution(grid)) {
        removed++;
      } else {
        // Restore the cell if removing it makes puzzle unsolvable
        grid[row][col] = SudokuCell(value: originalValue, isOriginal: true);
      }
    }
  }

  static bool _hasUniqueSolution(List<List<SudokuCell>> grid) {
    List<List<int>> intGrid = List.generate(
      9,
      (row) => List.generate(9, (col) => grid[row][col].value),
    );
    
    // Use a wrapper class to hold the solutions count
    SolutionCounter counter = SolutionCounter();
    _countSolutions(intGrid, counter);
    return counter.count == 1;
  }

  static void _countSolutions(List<List<int>> grid, SolutionCounter counter) {
    if (counter.count > 1) return; // Early termination

    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (_isValidMove(grid, row, col, num)) {
              grid[row][col] = num;
              _countSolutions(grid, counter);
              grid[row][col] = 0;
              if (counter.count > 1) return;
            }
          }
          return;
        }
      }
    }

    // Found a complete grid
    counter.count++;
  }


  static bool _isValidMove(List<List<int>> grid, int row, int col, int num) {
    // Check row
    for (int c = 0; c < 9; c++) {
      if (grid[row][c] == num) return false;
    }

    // Check column
    for (int r = 0; r < 9; r++) {
      if (grid[r][col] == num) return false;
    }

    // Check 3x3 box
    int boxRow = (row ~/ 3) * 3;
    int boxCol = (col ~/ 3) * 3;
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        if (grid[r][c] == num) return false;
      }
    }

    return true;
  }

  static List<int> getPossibleValues(List<List<SudokuCell>> grid, int row, int col) {
    List<int> possible = [];
    
    for (int num = 1; num <= 9; num++) {
      List<List<int>> intGrid = List.generate(
        9,
        (r) => List.generate(9, (c) => grid[r][c].value),
      );
      
      if (_isValidMove(intGrid, row, col, num)) {
        possible.add(num);
      }
    }
    
    return possible;
  }

  static bool isValidGrid(List<List<SudokuCell>> grid) {
    List<List<int>> intGrid = List.generate(
      9,
      (row) => List.generate(9, (col) => grid[row][col].value),
    );

    return _isValidCompleteGrid(intGrid);
  }

  static bool _isValidCompleteGrid(List<List<int>> grid) {
    // Check all rows, columns, and boxes
    for (int i = 0; i < 9; i++) {
      if (!_isValidUnit(_getRow(grid, i)) ||
          !_isValidUnit(_getColumn(grid, i)) ||
          !_isValidUnit(_getBox(grid, i))) {
        return false;
      }
    }
    return true;
  }

  static bool _isValidUnit(List<int> unit) {
    Set<int> seen = {};
    for (int num in unit) {
      if (num != 0) {
        if (seen.contains(num)) return false;
        seen.add(num);
      }
    }
    return true;
  }

  static List<int> _getRow(List<List<int>> grid, int row) {
    return grid[row];
  }

  static List<int> _getColumn(List<List<int>> grid, int col) {
    return List.generate(9, (row) => grid[row][col]);
  }

  static List<int> _getBox(List<List<int>> grid, int boxIndex) {
    int boxRow = (boxIndex ~/ 3) * 3;
    int boxCol = (boxIndex % 3) * 3;
    List<int> box = [];
    
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        box.add(grid[r][c]);
      }
    }
    
    return box;
  }
}