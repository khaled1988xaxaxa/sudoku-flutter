import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/sudoku_models.dart';
import '../utils/sudoku_generator.dart';

class KidsProvider extends ChangeNotifier {
  List<List<SudokuCell>> _grid = [];
  List<List<SudokuCell>> _originalGrid = [];
  
  Difficulty _currentDifficulty = Difficulty.kidsBeginner;
  bool _isGameActive = false;
  bool _isGameComplete = false;
  int _selectedRow = -1;
  int _selectedCol = -1;
  int _hintsUsed = 0;
  int _hintsRemaining = 5;
  
  Timer? _gameTimer;
  int _elapsedSeconds = 0;
  String _encouragementMessage = '';

  // Getters
  List<List<SudokuCell>> get grid => _grid;
  Difficulty get currentDifficulty => _currentDifficulty;
  bool get isGameActive => _isGameActive;
  bool get isGameComplete => _isGameComplete;
  int get selectedRow => _selectedRow;
  int get selectedCol => _selectedCol;
  int get hintsUsed => _hintsUsed;
  int get hintsRemaining => _hintsRemaining;
  int get elapsedSeconds => _elapsedSeconds;
  String get encouragementMessage => _encouragementMessage;

  String get formattedTime {
    int minutes = _elapsedSeconds ~/ 60;
    int seconds = _elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startNewKidsGame(Difficulty difficulty) {
    _currentDifficulty = difficulty;

    // Create the grid with the correct size
    if (difficulty == Difficulty.kidsBeginner) {
      // Ensure we're initializing a 4x4 grid for beginners
      _grid = List.generate(
        4,
        (row) => List.generate(4, (col) => SudokuCell(value: 0)),
      );
    } else {
      // For non-beginners, use a 9x9 grid
      _grid = List.generate(
        9,
        (row) => List.generate(9, (col) => SudokuCell(value: 0)),
      );
    }

    // Generate the puzzle after ensuring the grid is properly initialized
    _grid = _generateKidsPuzzle(difficulty);

    _originalGrid = _deepCopyGrid(_grid);
    
    // Ensure game is active BEFORE other initialization
    _isGameActive = true;
    _isGameComplete = false;
    _selectedRow = -1;
    _selectedCol = -1;
    _hintsUsed = 0;
    _hintsRemaining = difficulty == Difficulty.kidsBeginner ? 5 : 3;
    _elapsedSeconds = 0;
    _encouragementMessage = _getRandomEncouragement();
    
    _startTimer();
    
    // Debug logging to verify game state
    print("Kids game started - isGameActive: $_isGameActive, grid size: ${_grid.length}x${_grid.isNotEmpty ? _grid[0].length : 0}");
    
    notifyListeners();
  }

  void selectKidsCell(int row, int col) {
    print("selectKidsCell called: row=$row, col=$col, isGameActive=$_isGameActive, isGameComplete=$_isGameComplete");
    
    if (!_isGameActive || _isGameComplete) {
      print("Cannot select cell - game not active or complete");
      return;
    }
    
    // Validate row and col are within bounds
    if (row < 0 || row >= _grid.length || col < 0 || col >= _grid[0].length) {
      print("Cell selection out of bounds: row=$row, col=$col, grid size=${_grid.length}x${_grid.isNotEmpty ? _grid[0].length : 0}");
      return;
    }
    
    _clearHighlights();
    _selectedRow = row;
    _selectedCol = col;
    _highlightKidsRelatedCells(row, col);
    
    print("Cell selected successfully: row=$_selectedRow, col=$_selectedCol");
    notifyListeners();
  }

  void inputKidsNumber(int number) {
    if (!_isGameActive || _selectedRow == -1 || _selectedCol == -1) {
      print("Cannot input number: game not active or no cell selected");
      return;
    }
    
    SudokuCell cell = _grid[_selectedRow][_selectedCol];
    if (cell.isOriginal) {
      print("Cannot modify original cell");
      return;
    }

    // Place new number (even if same, this toggles it on/off)
    if (cell.value == number) {
      // Remove number if same number is placed
      cell.value = 0;
      print("Removed number $number from cell [$_selectedRow,$_selectedCol]");
    } else {
      // Place new number
      cell.value = number;
      print("Placed number $number in cell [$_selectedRow,$_selectedCol]");
      
      // Check if move is valid and give feedback
      if (_isValidKidsMove(_selectedRow, _selectedCol, number)) {
        _encouragementMessage = _getPositiveFeedback();
        _showTemporaryMessage();
        
        // Check if game is complete
        if (_isKidsGridComplete()) {
          _completeKidsGame();
        }
      } else {
        _encouragementMessage = _getHelpfulHint();
        _showTemporaryMessage();
        // In kids mode, we don't mark it as error, just give a hint
      }
    }
    
    notifyListeners();
  }

  // Kids-specific puzzle generation (simpler patterns)
  List<List<SudokuCell>> _generateKidsPuzzle(Difficulty difficulty) {
    int gridSize = difficulty == Difficulty.kidsBeginner ? 4 : 9;

    // Create an empty grid of the proper size
    List<List<SudokuCell>> grid = List.generate(
      gridSize,
      (row) => List.generate(gridSize, (col) => SudokuCell(value: 0)),
    );

    // Generate a simple pattern-based puzzle for kids
    if (difficulty == Difficulty.kidsBeginner) {
      _generateKidsBeginnerPuzzle(grid);
    } else {
      _generateKidsEasyPuzzle(grid);
    }

    // Debug output to ensure grid is not empty
    print("Generated grid size: ${grid.length}x${grid[0].length}");
    for (var row in grid) {
      print(row.map((cell) => cell.value).toList());
    }

    return grid;
  }

  void _generateKidsBeginnerPuzzle(List<List<SudokuCell>> grid) {
    // Ensure we're working with a 4x4 grid
    if (grid.length != 4) {
      print("Error: Grid size is not 4x4. Actual size: ${grid.length}x${grid[0].length}");
      return; // Exit if grid size is not 4x4
    }

    // Create manually verified solvable 4x4 patterns
    final List<List<List<int>>> patterns = [
      // Pattern 1 - Solution: [1,3,4,2], [2,4,1,3], [3,1,2,4], [4,2,3,1]
      [
        [1, 0, 0, 2],
        [0, 4, 1, 0],
        [3, 0, 2, 0],
        [0, 2, 0, 1],
      ],

      // Pattern 2 - Solution: [1,2,3,4], [3,4,2,1], [2,1,4,3], [4,3,1,2]
      [
        [0, 2, 3, 0],
        [3, 4, 0, 0],
        [2, 0, 4, 0],
        [0, 0, 1, 2],
      ],

      // Pattern 3 - Solution: [2,4,1,3], [1,3,4,2], [4,2,3,1], [3,1,2,4]
      [
        [2, 4, 0, 0],
        [0, 3, 0, 2],
        [4, 0, 3, 0],
        [0, 0, 2, 4],
      ],
    ];

    // For testing, use a pattern with known solution - comment out in production
    // This is the solution for the first pattern: [1,3,4,2], [2,4,1,3], [3,1,2,4], [4,2,3,1]

    // Randomly select a pattern
    final pattern = patterns[Random().nextInt(patterns.length)];

    print("Selected pattern with solution:");

    // Fill in the grid with the selected pattern
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (pattern[row][col] != 0) {
          grid[row][col] = SudokuCell(
            value: pattern[row][col],
            isOriginal: true,
          );
        } else {
          grid[row][col] = SudokuCell(value: 0, isOriginal: false);
        }
      }
    }
  }

  void _generateKidsEasyPuzzle(List<List<SudokuCell>> grid) {
    // Create kid-friendly patterns for easy puzzles with fewer prefilled numbers
    final patterns = [
      // Pattern 1 - Simplified with fewer numbers to make cells less crowded
      [
        [5, 0, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 0, 5, 0, 0, 0],
        [0, 9, 0, 0, 0, 0, 0, 6, 0],
        [8, 0, 0, 0, 6, 0, 0, 0, 3],
        [4, 0, 0, 8, 0, 3, 0, 0, 1],
        [0, 0, 0, 0, 2, 0, 0, 0, 6],
        [0, 6, 0, 0, 0, 0, 2, 0, 0],
        [0, 0, 0, 4, 1, 0, 0, 0, 5],
        [0, 0, 0, 0, 8, 0, 0, 7, 0],
      ],
      // Pattern 2 - Easier version with fewer initial numbers
      [
        [0, 0, 3, 0, 0, 8, 0, 0, 1],
        [0, 0, 0, 0, 9, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 5, 0],
        [9, 0, 0, 0, 0, 0, 2, 0, 0],
        [0, 0, 0, 0, 0, 7, 0, 0, 0],
        [0, 0, 2, 0, 0, 0, 0, 3, 0],
        [5, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 4, 0, 2, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 7, 0, 0, 0, 3],
      ],
      // Pattern 3 - Simplified for kids
      [
        [7, 0, 0, 0, 0, 0, 8, 0, 0],
        [0, 0, 0, 3, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 5],
        [0, 4, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 6, 0, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 2, 0],
        [0, 1, 0, 0, 0, 0, 0, 0, 0],
        [9, 0, 0, 0, 5, 0, 0, 0, 0],
        [0, 0, 3, 0, 0, 0, 0, 0, 7],
      ],
    ];

    // Randomly select a pattern
    List<List<int>> pattern = patterns[Random().nextInt(patterns.length)];
    
    // Fill in the grid with the selected pattern
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (pattern[row][col] != 0) {
          grid[row][col] = SudokuCell(
            value: pattern[row][col],
            isOriginal: true,
          );
        }
      }
    }
  }

  // Helper method to find possible values for a cell in kids mode
  List<int> _getPossibleKidsValues(int row, int col, [List<List<SudokuCell>>? customGrid]) {
    final gridToUse = customGrid ?? _grid;
    final gridSize = gridToUse.length;
    final boxSize = gridSize == 4 ? 2 : 3; // Box size is 2x2 for 4x4 grid, 3x3 for 9x9

    // Create a set of all possible values based on grid size
    Set<int> possibleValues = Set.from(List.generate(gridSize, (i) => i + 1));

    // Remove values present in the same row
    for (int c = 0; c < gridSize; c++) {
      if (gridToUse[row][c].value != 0) {
        possibleValues.remove(gridToUse[row][c].value);
      }
    }

    // Remove values present in the same column
    for (int r = 0; r < gridSize; r++) {
      if (gridToUse[r][col].value != 0) {
        possibleValues.remove(gridToUse[r][col].value);
      }
    }

    // Remove values present in the same box
    int boxRow = (row ~/ boxSize) * boxSize;
    int boxCol = (col ~/ boxSize) * boxSize;

    for (int r = boxRow; r < boxRow + boxSize; r++) {
      for (int c = boxCol; c < boxCol + boxSize; c++) {
        if (gridToUse[r][c].value != 0) {
          possibleValues.remove(gridToUse[r][c].value);
        }
      }
    }

    return possibleValues.toList();
  }

  // Check if placing a number is valid in kids mode
  bool _isValidKidsMove(int row, int col, int value) {
    final gridSize = _grid.length;
    final boxSize = gridSize == 4 ? 2 : 3;

    // Make sure the value is within the valid range for the grid size
    if (value < 1 || value > gridSize) {
      return false;
    }

    // Check row
    for (int c = 0; c < gridSize; c++) {
      if (c != col && _grid[row][c].value == value) {
        return false;
      }
    }

    // Check column
    for (int r = 0; r < gridSize; r++) {
      if (r != row && _grid[r][col].value == value) {
        return false;
      }
    }

    // Check box
    int boxRow = (row ~/ boxSize) * boxSize;
    int boxCol = (col ~/ boxSize) * boxSize;

    for (int r = boxRow; r < boxRow + boxSize; r++) {
      for (int c = boxCol; c < boxCol + boxSize; c++) {
        if ((r != row || c != col) && _grid[r][c].value == value) {
          return false;
        }
      }
    }

    return true;
  }

  // Check if the kids grid is fully filled and valid
  bool _isKidsGridComplete() {
    final gridSize = _grid.length;

    // Check if all cells are filled
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (_grid[row][col].value == 0) {
          return false;
        }
      }
    }

    // Check if all moves are valid
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (!_isValidKidsMove(row, col, _grid[row][col].value)) {
          return false;
        }
      }
    }

    return true;
  }

  void _completeKidsGame() {
    _stopTimer();
    _isGameComplete = true;
    _isGameActive = false;
    _encouragementMessage = _getCompletionMessage();
    _clearHighlights();
    notifyListeners();
  }

  void _highlightKidsRelatedCells(int row, int col) {
    final gridSize = _grid.length;
    final boxSize = gridSize == 4 ? 2 : 3;

    // Calculate the box start coordinates
    int boxRow = (row ~/ boxSize) * boxSize;
    int boxCol = (col ~/ boxSize) * boxSize;

    // Highlight cells in the same row, column, and box
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        bool isInSameRow = r == row;
        bool isInSameCol = c == col;
        bool isInSameBox = (r >= boxRow && r < boxRow + boxSize && c >= boxCol && c < boxCol + boxSize);

        _grid[r][c].isHighlighted = isInSameRow || isInSameCol || isInSameBox;
      }
    }
  }

  void _clearHighlights() {
    final gridSize = _grid.length;
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        _grid[r][c].isHighlighted = false;
      }
    }
  }

  // When checking hint cells, consider the grid size
  void getKidsHint() {
    if (!_isGameActive || _isGameComplete || _hintsRemaining <= 0) return;

    // Find the best cell to hint
    List<List<int>> candidates = [];

    final gridSize = _grid.length;

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (_grid[row][col].isEmpty) {
          List<int> possible = _getPossibleKidsValues(row, col);
          if (possible.length == 1) {
            // Perfect hint - only one possibility
            candidates.add([row, col, possible.first, 1]);
          } else if (possible.length <= 3) {
            // Good hint - few possibilities
            candidates.add([row, col, possible.first, possible.length]);
          }
        }
      }
    }

    if (candidates.isNotEmpty) {
      // Sort by fewest possibilities first
      candidates.sort((a, b) => a[3].compareTo(b[3]));

      int hintRow = candidates.first[0];
      int hintCol = candidates.first[1];
      int hintValue = candidates.first[2];

      selectKidsCell(hintRow, hintCol);
      _grid[hintRow][hintCol].value = hintValue;
      _hintsUsed++;
      _hintsRemaining--;

      _encouragementMessage = '🎯 Magic hint! Number $hintValue goes in row ${hintRow + 1}, column ${hintCol + 1}! ✨';
      _showTemporaryMessage();

      // Check if game is complete after hint
      if (_isKidsGridComplete()) {
        _completeKidsGame();
      }

      notifyListeners();
    }
  }

  void clearKidsCell() {
    if (!_isGameActive || _selectedRow == -1 || _selectedCol == -1) return;

    SudokuCell cell = _grid[_selectedRow][_selectedCol];
    if (cell.isOriginal) return;

    cell.value = 0;
    _encouragementMessage = 'Cell cleared! Try again! 🌟';
    _showTemporaryMessage();
    notifyListeners();
  }

  void resetKidsGame() {
    _grid = _deepCopyGrid(_originalGrid);
    _selectedRow = -1;
    _selectedCol = -1;
    _hintsUsed = 0;
    _hintsRemaining = _currentDifficulty == Difficulty.kidsBeginner ? 5 : 3;
    _elapsedSeconds = 0;
    _isGameComplete = false;
    // Ensure game is active after reset
    _isGameActive = true;
    _encouragementMessage = _getRandomEncouragement();
    _clearHighlights();
    _startTimer();
    
    print("Kids game reset - isGameActive: $_isGameActive");
    notifyListeners();
  }

  // Messages and Timer
  String _getRandomEncouragement() {
    final messages = [
      "Let's solve this puzzle together! 🌟",
      "You're doing great! Keep going! 🎯",
      "Every number has its perfect place! 🔢",
      "Think like a detective! 🕵️",
      "You're a puzzle master! 🧩",
    ];
    return messages[Random().nextInt(messages.length)];
  }

  String _getPositiveFeedback() {
    final messages = [
      "Perfect! Well done! ⭐",
      "Excellent choice! 🎉",
      "You're on fire! 🔥",
      "Brilliant move! 💫",
      "Outstanding! 🌟",
    ];
    return messages[Random().nextInt(messages.length)];
  }

  String _getHelpfulHint() {
    final messages = [
      "Hmm, try a different number! 🤔",
      "Check the row and column! 👀",
      "Look at the box too! 📦",
      "Think about what fits! 💭",
      "You're so close! Try again! 🎯",
    ];
    return messages[Random().nextInt(messages.length)];
  }

  String _getCompletionMessage() {
    final messages = [
      "🎉 AMAZING! You solved it! You're a Sudoku superstar! 🌟",
      "🏆 FANTASTIC! Perfect puzzle solving! You rock! 🎸",
      "🎊 WONDERFUL! You did it! Time to celebrate! 🎈",
      "⭐ BRILLIANT! Outstanding work! You're incredible! 💎",
      "🎯 PERFECT! Master puzzle solver! You're the best! 👑",
    ];
    return messages[Random().nextInt(messages.length)];
  }

  void _showTemporaryMessage() {
    Timer(const Duration(seconds: 3), () {
      _encouragementMessage = '';
      notifyListeners();
    });
  }

  void _startTimer() {
    _stopTimer();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }

  void _stopTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }

  List<List<SudokuCell>> _deepCopyGrid(List<List<SudokuCell>> original) {
    return List.generate(
      original.length, // Use original grid's size instead of hardcoding to 9
      (row) => List.generate(original[0].length, (col) => original[row][col].copy()),
    );
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
