import 'package:flutter/material.dart';
import '../models/sudoku_models.dart';
import '../l10n/app_localizations.dart';

class GameControls extends StatelessWidget {
  final bool canUndo;
  final bool canRedo;
  final bool noteMode;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onToggleNotes;
  final VoidCallback onHint;
  final VoidCallback onClear;
  final bool areHintsAvailable;
  final Difficulty difficulty;

  const GameControls({
    super.key,
    required this.canUndo,
    required this.canRedo,
    required this.noteMode,
    required this.onUndo,
    required this.onRedo,
    required this.onToggleNotes,
    required this.onHint,
    required this.onClear,
    this.areHintsAvailable = true,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    // Check if hints are available based on difficulty
    final bool hintsEnabled = difficulty != Difficulty.expert;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            context,
            icon: Icons.undo,
            label: l10n.undo,
            onPressed: canUndo ? onUndo : null,
          ),
          _buildControlButton(
            context,
            icon: Icons.redo,
            label: l10n.redo,
            onPressed: canRedo ? onRedo : null,
          ),
          _buildControlButton(
            context,
            icon: noteMode ? Icons.edit : Icons.edit_outlined,
            label: l10n.notes,
            onPressed: onToggleNotes,
            isActive: noteMode,
          ),
          _buildControlButton(
            context,
            icon: Icons.lightbulb,
            label: hintsEnabled ? l10n.hint : l10n.noHints,
            onPressed: hintsEnabled ? onHint : null,
            isDisabled: !hintsEnabled,
          ),
          _buildControlButton(
            context,
            icon: Icons.clear,
            label: l10n.clear,
            onPressed: onClear,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isActive = false,
    bool isDisabled = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: isActive 
                ? Theme.of(context).primaryColor.withOpacity(0.2)
                : null,
            foregroundColor: isDisabled
                ? Colors.grey
                : isActive 
                    ? Theme.of(context).primaryColor
                    : null,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDisabled ? Colors.grey : null,
          ),
        ),
      ],
    );
  }
}