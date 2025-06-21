import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sudoku_models.dart';
import '../utils/sudoku_generator.dart';
import '../widgets/completion_dialog.dart';
import '../main.dart'; // Import for navigatorKey
import 'package:provider/provider.dart';
import 'statistics_provider.dart';

class SudokuProvider extends ChangeNotifier {
  List<List<SudokuCell>> _grid = [];
  List<List<SudokuCell>> _originalGrid = [];
  List<SudokuMove> _moveHistory = [];
  int _currentMoveIndex = -1;
  
  Difficulty _currentDifficulty = Difficulty.medium;
  bool _isGameActive = false;
  bool _isGameComplete = false;
  bool _noteMode = false;
  int _selectedRow = -1;
  int _selectedCol = -1;
  int _hintsUsed = 0;
  int _mistakes = 0;
  
  Timer? _gameTimer;
  int _elapsedSeconds = 0;

  // Getters
  List<List<SudokuCell>> get grid => _grid;
  Difficulty get currentDifficulty => _currentDifficulty;
  bool get isGameActive => _isGameActive;
  bool get isGameComplete => _isGameComplete;
  bool get noteMode => _noteMode;
  int get selectedRow => _selectedRow;
  int get selectedCol => _selectedCol;
  int get hintsUsed => _hintsUsed;
  int get mistakes => _mistakes;
  int get elapsedSeconds => _elapsedSeconds;
  bool get canUndo => _currentMoveIndex >= 0;
  bool get canRedo => _currentMoveIndex < _moveHistory.length - 1;

  String get formattedTime {
    int hours = _elapsedSeconds ~/ 3600;
    int minutes = (_elapsedSeconds % 3600) ~/ 60;
    int seconds = _elapsedSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  void startNewGame(Difficulty difficulty) {
    _currentDifficulty = difficulty;
    _grid = SudokuGenerator.generatePuzzle(difficulty);
    _originalGrid = _deepCopyGrid(_grid);
    _moveHistory.clear();
    _currentMoveIndex = -1;
    _isGameActive = true;
    _isGameComplete = false;
    _selectedRow = -1;
    _selectedCol = -1;
    _hintsUsed = 0;
    _mistakes = 0;
    _elapsedSeconds = 0;
    _startTimer();
    notifyListeners();
  }

  void selectCell(int row, int col) {
    if (!_isGameActive || _isGameComplete) return;
    
    _clearHighlights();
    _selectedRow = row;
    _selectedCol = col;
    _highlightRelatedCells(row, col);
    notifyListeners();
  }

  void inputNumber(int number) {
    if (!_isGameActive || _selectedRow == -1 || _selectedCol == -1) return;
    
    SudokuCell cell = _grid[_selectedRow][_selectedCol];
    if (cell.isOriginal) return;

    if (_noteMode) {
      _toggleNote(number);
    } else {
      _placeNumber(number);
    }
  }

  void _placeNumber(int number) {
    SudokuCell cell = _grid[_selectedRow][_selectedCol];
    
    if (cell.value == number) {
      // Remove number if same number is placed
      _makeMove(_selectedRow, _selectedCol, 0, <int>{});
    } else {
      // Place new number
      _makeMove(_selectedRow, _selectedCol, number, <int>{});
      
      // Check if move is valid
      if (!_isValidMove(_selectedRow, _selectedCol, number)) {
        _mistakes++;
        cell.isError = true;
        // Remove error highlight after 1 second
        Timer(const Duration(seconds: 1), () {
          cell.isError = false;
          notifyListeners();
        });
      }
      
      // Check if game is complete
      if (_isGridComplete()) {
        _completeGame();
      }
    }
  }

  void _toggleNote(int number) {
    SudokuCell cell = _grid[_selectedRow][_selectedCol];
    
    if (cell.value != 0) return; // Can't add notes to filled cells
    
    Set<int> newNotes = Set<int>.from(cell.notes);
    if (newNotes.contains(number)) {
      newNotes.remove(number);
    } else {
      newNotes.add(number);
    }
    
    _makeMove(_selectedRow, _selectedCol, cell.value, newNotes);
  }

  void _makeMove(int row, int col, int newValue, Set<int> newNotes) {
    SudokuCell cell = _grid[row][col];
    
    // Create move for undo/redo
    SudokuMove move = SudokuMove(
      row: row,
      col: col,
      oldValue: cell.value,
      newValue: newValue,
      oldNotes: Set<int>.from(cell.notes),
      newNotes: Set<int>.from(newNotes),
    );
    
    // Remove any moves after current position
    if (_currentMoveIndex < _moveHistory.length - 1) {
      _moveHistory.removeRange(_currentMoveIndex + 1, _moveHistory.length);
    }
    
    // Add new move
    _moveHistory.add(move);
    _currentMoveIndex++;
    
    // Apply move
    cell.value = newValue;
    cell.notes = newNotes;
    
    notifyListeners();
  }

  void undo() {
    if (!canUndo) return;
    
    SudokuMove move = _moveHistory[_currentMoveIndex];
    SudokuCell cell = _grid[move.row][move.col];
    
    cell.value = move.oldValue;
    cell.notes = Set<int>.from(move.oldNotes);
    cell.isError = false;
    
    _currentMoveIndex--;
    notifyListeners();
  }

  void redo() {
    if (!canRedo) return;
    
    _currentMoveIndex++;
    SudokuMove move = _moveHistory[_currentMoveIndex];
    SudokuCell cell = _grid[move.row][move.col];
    
    cell.value = move.newValue;
    cell.notes = Set<int>.from(move.newNotes);
    
    notifyListeners();
  }

  void getHint() {
    if (!_isGameActive || _isGameComplete) return;
    
    // Find an empty cell with the fewest possibilities
    int bestRow = -1, bestCol = -1;
    int fewestOptions = 10;
    
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (_grid[row][col].isEmpty) {
          List<int> possible = SudokuGenerator.getPossibleValues(_grid, row, col);
          if (possible.length < fewestOptions) {
            fewestOptions = possible.length;
            bestRow = row;
            bestCol = col;
          }
        }
      }
    }
    
    if (bestRow != -1 && bestCol != -1) {
      List<int> possible = SudokuGenerator.getPossibleValues(_grid, bestRow, bestCol);
      if (possible.isNotEmpty) {
        selectCell(bestRow, bestCol);
        _placeNumber(possible.first);
        _hintsUsed++;
      }
    }
  }

  void toggleNoteMode() {
    _noteMode = !_noteMode;
    notifyListeners();
  }

  void clearCell() {
    if (!_isGameActive || _selectedRow == -1 || _selectedCol == -1) return;
    
    SudokuCell cell = _grid[_selectedRow][_selectedCol];
    if (cell.isOriginal) return;
    
    if (cell.value != 0) {
      _makeMove(_selectedRow, _selectedCol, 0, cell.notes);
    } else if (cell.notes.isNotEmpty) {
      _makeMove(_selectedRow, _selectedCol, 0, <int>{});
    }
  }

  void pauseGame() {
    _stopTimer();
    _isGameActive = false;
    notifyListeners();
  }

  void resumeGame() {
    _startTimer();
    _isGameActive = true;
    notifyListeners();
  }

  void resetGame() {
    _grid = _deepCopyGrid(_originalGrid);
    _moveHistory.clear();
    _currentMoveIndex = -1;
    _selectedRow = -1;
    _selectedCol = -1;
    _hintsUsed = 0;
    _mistakes = 0;
    _elapsedSeconds = 0;
    _isGameComplete = false;
    _clearHighlights();
    _startTimer();
    notifyListeners();
  }

  // Private methods
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

  void _completeGame() {
    _stopTimer();
    _isGameComplete = true;
    _isGameActive = false;
    _clearHighlights();

    // Calculate score
    int baseScore = 1000;
    int timeDeduction = _elapsedSeconds;
    int hintsDeduction = _hintsUsed * 50;
    int mistakesDeduction = _mistakes * 30;
    int score = baseScore - timeDeduction - hintsDeduction - mistakesDeduction;
    score = score < 0 ? 0 : score;

    // Update statistics using StatisticsProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        // Show completion dialog
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            final statsProvider = Provider.of<StatisticsProvider>(context, listen: false);

            // Update game statistics
            statsProvider.recordGame(
              difficulty: _currentDifficulty,
              timeInSeconds: _elapsedSeconds,
              completed: true,
              hintsUsed: _hintsUsed,
              mistakes: _mistakes,
            );

            return CompletionDialog(
              time: formattedTime,
              hintsUsed: _hintsUsed,
              mistakes: _mistakes,
              score: score,
              onPlayAgain: () {
                Navigator.of(context).pop();
                startNewGame(_currentDifficulty);
              },
              onGoHome: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
            );
          },
        );
      }
    });

    notifyListeners();
  }

  bool _isGridComplete() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (_grid[row][col].isEmpty) return false;
      }
    }
    return SudokuGenerator.isValidGrid(_grid);
  }

  bool _isValidMove(int row, int col, int number) {
    // Temporarily place the number
    int originalValue = _grid[row][col].value;
    _grid[row][col].value = number;
    
    bool isValid = true;
    
    // Check row
    for (int c = 0; c < 9; c++) {
      if (c != col && _grid[row][c].value == number) {
        isValid = false;
        break;
      }
    }
    
    // Check column
    if (isValid) {
      for (int r = 0; r < 9; r++) {
        if (r != row && _grid[r][col].value == number) {
          isValid = false;
          break;
        }
      }
    }
    
    // Check 3x3 box
    if (isValid) {
      int boxRow = (row ~/ 3) * 3;
      int boxCol = (col ~/ 3) * 3;
      for (int r = boxRow; r < boxRow + 3; r++) {
        for (int c = boxCol; c < boxCol + 3; c++) {
          if ((r != row || c != col) && _grid[r][c].value == number) {
            isValid = false;
            break;
          }
        }
        if (!isValid) break;
      }
    }
    
    // Restore original value
    _grid[row][col].value = originalValue;
    
    return isValid;
  }

  void _clearHighlights() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        _grid[row][col].isHighlighted = false;
      }
    }
  }

  void _highlightRelatedCells(int selectedRow, int selectedCol) {
    int selectedValue = _grid[selectedRow][selectedCol].value;
    
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        // Highlight same row, column, or box
        bool sameRow = row == selectedRow;
        bool sameCol = col == selectedCol;
        bool sameBox = (row ~/ 3) == (selectedRow ~/ 3) && (col ~/ 3) == (selectedCol ~/ 3);
        bool sameValue = selectedValue != 0 && _grid[row][col].value == selectedValue;
        
        _grid[row][col].isHighlighted = sameRow || sameCol || sameBox || sameValue;
      }
    }
    
    // Don't highlight the selected cell itself
    _grid[selectedRow][selectedCol].isHighlighted = false;
  }

  List<List<SudokuCell>> _deepCopyGrid(List<List<SudokuCell>> original) {
    return List.generate(
      9,
      (row) => List.generate(9, (col) => original[row][col].copy()),
    );
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
