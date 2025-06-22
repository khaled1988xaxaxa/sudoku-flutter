import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sudoku_provider.dart';
import '../providers/statistics_provider.dart';
import '../models/sudoku_models.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_pad.dart';
import '../widgets/game_controls.dart';
import '../widgets/completion_dialog.dart';

class SudokuGameScreen extends StatefulWidget {
  const SudokuGameScreen({super.key});

  @override
  State<SudokuGameScreen> createState() => _SudokuGameScreenState();
}

class _SudokuGameScreenState extends State<SudokuGameScreen> {
  late Difficulty difficulty;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      difficulty = ModalRoute.of(context)?.settings.arguments as Difficulty? ?? Difficulty.medium;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<SudokuProvider>(context, listen: false).startNewGame(difficulty);
      });
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SudokuProvider, StatisticsProvider>(
      builder: (context, sudokuProvider, statsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${difficulty.displayName} Sudoku'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _showRestartDialog(context, sudokuProvider),
              ),
              IconButton(
                icon: Icon(sudokuProvider.isGameActive ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (sudokuProvider.isGameActive) {
                    sudokuProvider.pauseGame();
                  } else {
                    sudokuProvider.resumeGame();
                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Game Info Bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(
                      context,
                      icon: Icons.timer,
                      label: 'Time',
                      value: sudokuProvider.formattedTime,
                    ),
                    _buildInfoItem(
                      context,
                      icon: Icons.lightbulb,
                      label: 'Hints',
                      value: sudokuProvider.hintsUsed.toString(),
                    ),
                    _buildInfoItem(
                      context,
                      icon: Icons.error,
                      label: 'Mistakes',
                      value: sudokuProvider.mistakes.toString(),
                    ),
                  ],
                ),
              ),

              // Sudoku Grid
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: SudokuGrid(
                    grid: sudokuProvider.grid,
                    selectedRow: sudokuProvider.selectedRow,
                    selectedCol: sudokuProvider.selectedCol,
                    onCellTap: sudokuProvider.selectCell,
                    isGameActive: sudokuProvider.isGameActive,
                  ),
                ),
              ),

              // Game Controls
              GameControls(
                canUndo: sudokuProvider.canUndo,
                canRedo: sudokuProvider.canRedo,
                noteMode: sudokuProvider.noteMode,
                onUndo: sudokuProvider.undo,
                onRedo: sudokuProvider.redo,
                onToggleNotes: sudokuProvider.toggleNoteMode,
                onHint: () {
                  sudokuProvider.getHint();
                  statsProvider.recordHintUsed();
                },
                onClear: sudokuProvider.clearCell,
                areHintsAvailable: sudokuProvider.areHintsAvailable,
                difficulty: difficulty,
              ),

              // Number Pad
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: NumberPad(
                  onNumberTap: sudokuProvider.inputNumber,
                  isGameActive: sudokuProvider.isGameActive,
                  noteMode: sudokuProvider.noteMode,
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showRestartDialog(BuildContext context, SudokuProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Restart Game'),
          content: const Text('Are you sure you want to restart? Your current progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                provider.resetGame();
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }
}