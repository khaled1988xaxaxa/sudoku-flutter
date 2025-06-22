import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CompletionDialog extends StatelessWidget {
  final String time;
  final int mistakes;
  final int hintsUsed;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  const CompletionDialog({
    super.key,
    required this.time,
    required this.mistakes,
    required this.hintsUsed,
    required this.onPlayAgain,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.celebration,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.congratulations,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.wellDone,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.timer, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.time,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.error_outline, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 4),
                    Text(
                      mistakes.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.mistakes,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 4),
                    Text(
                      hintsUsed.toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.hintsUsed,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onGoHome,
                    child: Text(l10n.home),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPlayAgain,
                    child: Text(l10n.playAgain),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}