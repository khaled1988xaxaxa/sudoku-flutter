import 'package:flutter/material.dart';

/// A specialized widget for displaying Sudoku numbers correctly
/// Uses direct Unicode code points to avoid font fallback issues
class SudokuNumberText extends StatelessWidget {
  final int number;
  final TextStyle? style;

  const SudokuNumberText({
    Key? key,
    required this.number,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use direct Unicode code points for digits to avoid font mapping issues
    String displayText;
    switch (number) {
      case 1:
        displayText = '\u0031';
        break; // Unicode for '1'
      case 2:
        displayText = '\u0032';
        break; // Unicode for '2'
      case 3:
        displayText = '\u0033';
        break; // Unicode for '3'
      case 4:
        displayText = '\u0034';
        break; // Unicode for '4'
      case 5:
        displayText = '\u0035';
        break; // Unicode for '5'
      case 6:
        displayText = '\u0036';
        break; // Unicode for '6'
      case 7:
        displayText = '\u0037';
        break; // Unicode for '7'
      case 8:
        displayText = '\u0038';
        break; // Unicode for '8'
      case 9:
        displayText = '\u0039';
        break; // Unicode for '9'
      default:
        displayText = String.fromCharCode(48 + number);
        break; // ASCII digits
    }

    return Text(
      displayText,
      style: (style ?? const TextStyle()).copyWith(
        fontFamily: 'monospace',
        fontFamilyFallback: const [
          'SF Pro Text', // iOS system font
          'Segoe UI', // Windows system font
          'Roboto', // Android system font
          'Arial', // Universal fallback
          'Helvetica', // Mac fallback
          'sans-serif', // Generic fallback
        ],
        fontFeatures: const [
          FontFeature.tabularFigures(), // Ensure consistent digit spacing
          FontFeature.liningFigures(), // Use lining figures for numbers
        ],
      ),
    );
  }
}

/// Alternative widget using Container with number display
class RobustNumberDisplay extends StatelessWidget {
  final int number;
  final TextStyle? style;

  const RobustNumberDisplay({
    Key? key,
    required this.number,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If all else fails, use a simple container with hardcoded number shapes
    if (number < 1 || number > 9) {
      return const SizedBox.shrink();
    }

    // Create a custom painter for the number if needed
    return CustomPaint(
      size: Size(
        style?.fontSize ?? 20,
        style?.fontSize ?? 20,
      ),
      painter: NumberPainter(
        number: number,
        color: style?.color ?? Colors.black,
        fontSize: style?.fontSize ?? 20,
      ),
    );
  }
}

/// Custom painter to draw numbers directly
class NumberPainter extends CustomPainter {
  final int number;
  final Color color;
  final double fontSize;

  NumberPainter({
    required this.number,
    required this.color,
    required this.fontSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final scale = fontSize / 20; // Scale based on font size

    // Draw the number shape directly
    switch (number) {
      case 1:
        _drawOne(canvas, center, scale, paint);
        break;
      case 2:
        _drawTwo(canvas, center, scale, paint);
        break;
      case 3:
        _drawThree(canvas, center, scale, paint);
        break;
      case 4:
        _drawFour(canvas, center, scale, paint);
        break;
      case 5:
        _drawFive(canvas, center, scale, paint);
        break;
      case 6:
        _drawSix(canvas, center, scale, paint);
        break;
      case 7:
        _drawSeven(canvas, center, scale, paint);
        break;
      case 8:
        _drawEight(canvas, center, scale, paint);
        break;
      case 9:
        _drawNine(canvas, center, scale, paint);
        break;
    }
  }

  void _drawOne(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - 8 * scale);
    path.lineTo(center.dx, center.dy + 8 * scale);
    canvas.drawPath(path, paint);
  }

  void _drawTwo(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy);
    path.lineTo(center.dx - 6 * scale, center.dy + 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy + 6 * scale);
    canvas.drawPath(path, paint);
  }

  void _drawThree(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy);
    path.lineTo(center.dx, center.dy);
    path.moveTo(center.dx + 6 * scale, center.dy);
    path.lineTo(center.dx + 6 * scale, center.dy + 6 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy + 6 * scale);
    canvas.drawPath(path, paint);
  }

  void _drawFour(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy);
    path.lineTo(center.dx + 6 * scale, center.dy);
    path.moveTo(center.dx + 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy + 6 * scale);
    canvas.drawPath(path, paint);
  }

  void _drawFive(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx + 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy);
    path.lineTo(center.dx + 6 * scale, center.dy);
    path.lineTo(center.dx + 6 * scale, center.dy + 6 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy + 6 * scale);
    canvas.drawPath(path, paint);
  }

  void _drawSix(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx + 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy + 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy + 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy);
    path.lineTo(center.dx - 6 * scale, center.dy);
    canvas.drawPath(path, paint);
  }

  void _drawSeven(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy + 6 * scale);
    canvas.drawPath(path, paint);
  }

  void _drawEight(Canvas canvas, Offset center, double scale, Paint paint) {
    final rect1 = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 3 * scale),
      width: 12 * scale,
      height: 6 * scale,
    );
    final rect2 = Rect.fromCenter(
      center: Offset(center.dx, center.dy + 3 * scale),
      width: 12 * scale,
      height: 6 * scale,
    );
    canvas.drawRect(rect1, paint);
    canvas.drawRect(rect2, paint);
  }

  void _drawNine(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6 * scale, center.dy + 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy + 6 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy);
    path.lineTo(center.dx + 6 * scale, center.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// A wrapper widget to ensure text is displayed using only Latin characters
/// This solves the issue of Chinese characters appearing as fallbacks
class SafeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const SafeText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? DefaultTextStyle.of(context).style).copyWith(
        // Force the use of a font that doesn't have Chinese fallbacks
        fontFamily: 'Roboto', // Use Flutter's default Latin font
        fontFamilyFallback: const ['sans-serif'], // Only use Latin fallbacks
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
