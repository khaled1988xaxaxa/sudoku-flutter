class SudokuCell {
  int value;
  final bool isOriginal;
  Set<int> notes;
  bool isHighlighted;
  bool isError;
  bool isConflict;

  SudokuCell({
    this.value = 0,
    this.isOriginal = false,
    Set<int>? notes,
    this.isHighlighted = false,
    this.isError = false,
    this.isConflict = false,
  }) : notes = notes ?? <int>{};

  SudokuCell copy() {
    return SudokuCell(
      value: value,
      isOriginal: isOriginal,
      notes: Set<int>.from(notes),
      isHighlighted: isHighlighted,
      isError: isError,
      isConflict: isConflict,
    );
  }

  bool get isEmpty => value == 0;
  bool get isNotEmpty => value != 0;
}

class SudokuMove {
  final int row;
  final int col;
  final int oldValue;
  final int newValue;
  final Set<int> oldNotes;
  final Set<int> newNotes;
  final DateTime timestamp;

  SudokuMove({
    required this.row,
    required this.col,
    required this.oldValue,
    required this.newValue,
    required this.oldNotes,
    required this.newNotes,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

enum Difficulty { beginner, easy, medium, hard, expert, kidsBeginner, kidsEasy }

extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.beginner:
        return 'Beginner';
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
      case Difficulty.expert:
        return 'Expert';
      case Difficulty.kidsBeginner:
        return 'Kids Beginner';
      case Difficulty.kidsEasy:
        return 'Kids Easy';
    }
  }

  int get cellsToRemove {
    switch (this) {
      case Difficulty.beginner:
        return 35;
      case Difficulty.easy:
        return 40;
      case Difficulty.medium:
        return 45;
      case Difficulty.hard:
        return 50;
      case Difficulty.expert:
        return 55;
      case Difficulty.kidsBeginner:
        return 25;
      case Difficulty.kidsEasy:
        return 30;
    }
  }

  bool get isKidsMode => this == Difficulty.kidsBeginner || this == Difficulty.kidsEasy;
}