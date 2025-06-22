import 'package:flutter/material.dart';

/// A specialized widget for displaying Sudoku numbers correctly
/// Always uses Western Arabic numerals (0-9) regardless of locale
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
    // Always use standard Western Arabic numerals
    return Text(
      number.toString(),
      style: (style ?? const TextStyle()).copyWith(
        fontFamily: 'Roboto',
        fontFamilyFallback: const [
          'Arial',
          'Helvetica',
          'sans-serif',
        ],
        // Force the use of Western Arabic numerals
        locale: const Locale('en', 'US'),
      ),
      // Ensure text direction is left-to-right for numbers
      textDirection: TextDirection.ltr,
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

/// A bulletproof widget for displaying Sudoku numbers in Western format
/// This completely bypasses any locale-based number formatting
class ForceWesternNumberText extends StatelessWidget {
  final int number;
  final TextStyle? style;

  const ForceWesternNumberText({
    Key? key,
    required this.number,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map numbers to explicit Western characters to bypass any locale formatting
    const Map<int, String> westernNumbers = {
      0: '0',
      1: '1',
      2: '2',
      3: '3',
      4: '4',
      5: '5',
      6: '6',
      7: '7',
      8: '8',
      9: '9',
    };

    return Localizations.override(
      context: context,
      locale: const Locale('en', 'US'),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          westernNumbers[number] ?? number.toString(),
          style: (style ?? const TextStyle()).copyWith(
            fontFamily: 'Roboto',
            fontFamilyFallback: const ['Arial', 'Helvetica', 'sans-serif'],
          ),
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}

/// A widget that draws numbers using custom painting to avoid any font/locale issues
class PaintedNumberWidget extends StatelessWidget {
  final int number;
  final Color color;
  final double size;
  final FontWeight fontWeight;

  const PaintedNumberWidget({
    Key? key,
    required this.number,
    this.color = Colors.black,
    this.size = 16.0,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: NumberCustomPainter(
        number: number,
        color: color,
        size: size,
        fontWeight: fontWeight,
      ),
    );
  }
}

/// Custom painter that draws numbers using paths to completely avoid text rendering
class NumberCustomPainter extends CustomPainter {
  final int number;
  final Color color;
  final double size;
  final FontWeight fontWeight;

  NumberCustomPainter({
    required this.number,
    required this.color,
    required this.size,
    required this.fontWeight,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = fontWeight == FontWeight.bold ? 2.5 : 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final scale = size / 20;

    switch (number) {
      case 1:
        _draw1(canvas, center, scale, paint);
        break;
      case 2:
        _draw2(canvas, center, scale, paint);
        break;
      case 3:
        _draw3(canvas, center, scale, paint);
        break;
      case 4:
        _draw4(canvas, center, scale, paint);
        break;
      case 5:
        _draw5(canvas, center, scale, paint);
        break;
      case 6:
        _draw6(canvas, center, scale, paint);
        break;
      case 7:
        _draw7(canvas, center, scale, paint);
        break;
      case 8:
        _draw8(canvas, center, scale, paint);
        break;
      case 9:
        _draw9(canvas, center, scale, paint);
        break;
    }
  }

  void _draw1(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - 8 * scale);
    path.lineTo(center.dx, center.dy + 8 * scale);
    path.moveTo(center.dx - 3 * scale, center.dy - 6 * scale);
    path.lineTo(center.dx, center.dy - 8 * scale);
    canvas.drawPath(path, paint);
  }

  void _draw2(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6 * scale, center.dy - 4 * scale);
    path.quadraticBezierTo(center.dx - 6 * scale, center.dy - 8 * scale, center.dx, center.dy - 8 * scale);
    path.quadraticBezierTo(center.dx + 6 * scale, center.dy - 8 * scale, center.dx + 6 * scale, center.dy - 4 * scale);
    path.quadraticBezierTo(center.dx + 6 * scale, center.dy, center.dx, center.dy);
    path.lineTo(center.dx - 6 * scale, center.dy + 8 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy + 8 * scale);
    canvas.drawPath(path, paint);
  }

  void _draw3(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6 * scale, center.dy - 8 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy - 8 * scale);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy - 8 * scale, center.dx + 8 * scale, center.dy - 4 * scale);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy, center.dx + 4 * scale, center.dy);
    path.lineTo(center.dx + 6 * scale, center.dy);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy, center.dx + 8 * scale, center.dy + 4 * scale);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy + 8 * scale, center.dx + 6 * scale, center.dy + 8 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy + 8 * scale);
    canvas.drawPath(path, paint);
  }

  void _draw4(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6 * scale, center.dy - 8 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy + 2 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy + 2 * scale);
    path.moveTo(center.dx + 6 * scale, center.dy - 8 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy + 8 * scale);
    canvas.drawPath(path, paint);
  }

  void _draw5(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx + 6 * scale, center.dy - 8 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy - 8 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy);
    path.lineTo(center.dx + 4 * scale, center.dy);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy, center.dx + 8 * scale, center.dy + 4 * scale);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy + 8 * scale, center.dx + 4 * scale, center.dy + 8 * scale);
    path.lineTo(center.dx - 6 * scale, center.dy + 8 * scale);
    canvas.drawPath(path, paint);
  }

  void _draw6(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx + 4 * scale, center.dy - 8 * scale);
    path.quadraticBezierTo(center.dx - 8 * scale, center.dy - 8 * scale, center.dx - 8 * scale, center.dy);
    path.quadraticBezierTo(center.dx - 8 * scale, center.dy + 8 * scale, center.dx + 4 * scale, center.dy + 8 * scale);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy + 8 * scale, center.dx + 8 * scale, center.dy + 4 * scale);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy, center.dx + 4 * scale, center.dy);
    path.lineTo(center.dx - 8 * scale, center.dy);
    canvas.drawPath(path, paint);
  }

  void _draw7(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx - 6 * scale, center.dy - 8 * scale);
    path.lineTo(center.dx + 6 * scale, center.dy - 8 * scale);
    path.lineTo(center.dx + 2 * scale, center.dy + 8 * scale);
    canvas.drawPath(path, paint);
  }

  void _draw8(Canvas canvas, Offset center, double scale, Paint paint) {
    final path1 = Path();
    path1.addOval(Rect.fromCenter(center: Offset(center.dx, center.dy - 4 * scale), width: 12 * scale, height: 6 * scale));
    final path2 = Path();
    path2.addOval(Rect.fromCenter(center: Offset(center.dx, center.dy + 4 * scale), width: 12 * scale, height: 6 * scale));
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  void _draw9(Canvas canvas, Offset center, double scale, Paint paint) {
    final path = Path();
    path.moveTo(center.dx + 8 * scale, center.dy);
    path.lineTo(center.dx - 4 * scale, center.dy);
    path.quadraticBezierTo(center.dx - 8 * scale, center.dy, center.dx - 8 * scale, center.dy - 4 * scale);
    path.quadraticBezierTo(center.dx - 8 * scale, center.dy - 8 * scale, center.dx - 4 * scale, center.dy - 8 * scale);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy - 8 * scale, center.dx + 8 * scale, center.dy);
    path.quadraticBezierTo(center.dx + 8 * scale, center.dy + 8 * scale, center.dx - 4 * scale, center.dy + 8 * scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
