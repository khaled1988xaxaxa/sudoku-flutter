import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/kids_provider.dart';
import '../providers/statistics_provider.dart';
import '../models/sudoku_models.dart';
import '../widgets/kids_sudoku_grid.dart';
import '../widgets/kids_number_pad.dart';
import '../widgets/kids_celebration.dart';

class KidsGameScreen extends StatefulWidget {
  const KidsGameScreen({super.key});

  @override
  State<KidsGameScreen> createState() => _KidsGameScreenState();
}

class _KidsGameScreenState extends State<KidsGameScreen> {
  late Difficulty difficulty;
  bool _isInitialized = false;
  bool _hasShownCompletionDialog = false; // Add flag to track if dialog was shown
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      difficulty = ModalRoute.of(context)?.settings.arguments as Difficulty? ?? Difficulty.kidsBeginner;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<KidsProvider>(context, listen: false).startNewKidsGame(difficulty);
      });
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<KidsProvider, StatisticsProvider>(
      builder: (context, kidsProvider, statsProvider, child) {
        // Show celebration when game is complete and dialog hasn't been shown yet
        if (kidsProvider.isGameComplete && !_hasShownCompletionDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _confettiController.play();
            _showCompletionDialog(context, kidsProvider, statsProvider);
            _hasShownCompletionDialog = true; // Set flag to prevent multiple dialogs
          });
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFF4ECDC4),
                  Color(0xFFFFEB3B),
                  Color(0xFF4CAF50),
                ],
              ),
            ),
            child: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      _buildKidsHeader(context, kidsProvider),
                      // Remove the encouragement message from here to prevent layout shifts
                      _buildKidsInfoBar(context, kidsProvider),
                      Expanded(
                        flex: 5, // Increased from 3 to 5 for much larger grid
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced padding
                          child: KidsSudokuGrid(
                            grid: kidsProvider.grid,
                            selectedRow: kidsProvider.selectedRow,
                            selectedCol: kidsProvider.selectedCol,
                            onCellTap: kidsProvider.selectKidsCell,
                            isGameActive: kidsProvider.isGameActive,
                          ),
                        ),
                      ),
                      _buildKidsControls(context, kidsProvider, statsProvider),
                      Expanded(
                        flex: 1, // Reduced from 2 to 1 to give more space to the grid
                        child: KidsNumberPad(
                          onNumberTap: kidsProvider.inputKidsNumber,
                          isGameActive: kidsProvider.isGameActive,
                          difficulty: kidsProvider.currentDifficulty,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                // Encouragement message as overlay - positioned at top, doesn't affect layout
                if (kidsProvider.encouragementMessage.isNotEmpty)
                  Positioned(
                    top: 100, // Position below the header
                    left: 16,
                    right: 16,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        kidsProvider.encouragementMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                // Confetti overlay
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.yellow,
                      Colors.pink,
                      Colors.orange,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKidsHeader(BuildContext context, KidsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          Expanded(
            child: Text(
              '🌟 ${difficulty.displayName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _showKidsRestartDialog(context, provider),
            icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildKidsInfoBar(BuildContext context, KidsProvider provider) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildKidsInfoItem(
            icon: Icons.timer,
            label: 'Time',
            value: provider.formattedTime,
          ),
          _buildKidsInfoItem(
            icon: Icons.lightbulb,
            label: 'Hints Left',
            value: provider.hintsRemaining.toString(),
          ),
          _buildKidsInfoItem(
            icon: Icons.star,
            label: 'Level',
            value: difficulty == Difficulty.kidsBeginner ? '1' : '2',
          ),
        ],
      ),
    );
  }

  Widget _buildKidsInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildKidsControls(BuildContext context, KidsProvider provider, StatisticsProvider statsProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildKidsControlButton(
            icon: Icons.lightbulb,
            label: 'Hint',
            color: const Color(0xFFFFEB3B),
            onTap: provider.hintsRemaining > 0 ? () {
              provider.getKidsHint();
              statsProvider.recordHintUsed();
            } : null,
          ),
          _buildKidsControlButton(
            icon: Icons.clear,
            label: 'Clear',
            color: const Color(0xFFFF6B6B),
            onTap: provider.clearKidsCell,
          ),
          _buildKidsControlButton(
            icon: Icons.refresh,
            label: 'Reset',
            color: const Color(0xFF4ECDC4),
            onTap: () => _showKidsRestartDialog(context, provider),
          ),
        ],
      ),
    );
  }

  Widget _buildKidsControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: onTap != null ? color : Colors.grey,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, KidsProvider provider, StatisticsProvider statsProvider) {
    // Record the completion
    statsProvider.recordGame(
      difficulty: provider.currentDifficulty,
      timeInSeconds: provider.elapsedSeconds,
      completed: true,
      hintsUsed: provider.hintsUsed,
      mistakes: 0,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return KidsCelebration(
          message: provider.encouragementMessage,
          time: provider.formattedTime,
          hintsUsed: provider.hintsUsed,
          onPlayAgain: () {
            Navigator.pop(context);
            provider.startNewKidsGame(difficulty);
            setState(() {
              _hasShownCompletionDialog = false; // Reset flag when starting a new game
            });
          },
          onGoHome: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showKidsRestartDialog(BuildContext context, KidsProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('🔄 Start Over?'),
          content: const Text('Do you want to start a new puzzle? Your current progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep Playing'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                provider.resetKidsGame();
              },
              child: const Text('Start Over'),
            ),
          ],
        );
      },
    );
  }
}