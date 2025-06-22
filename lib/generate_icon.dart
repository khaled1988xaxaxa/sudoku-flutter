import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create a temporary directory to save the icon
  final directory = await getTemporaryDirectory();
  final iconPath = '${directory.path}/app_icon.png';
  
  // Generate the icon
  await generateAppIcon(iconPath, size: 1024);
  
  print('App icon generated at: $iconPath');
  exit(0);
}

Future<void> generateAppIcon(String outputPath, {required int size}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint();
  
  // Canvas size
  final rect = Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble());
  
  // Draw background
  paint.color = const Color(0xFF3F51B5); // Indigo
  canvas.drawRect(rect, paint);
  
  // Draw Sudoku grid
  paint.color = Colors.white;
  paint.style = PaintingStyle.stroke;
  paint.strokeWidth = size / 40;
  
  // Grid size and padding
  final gridPadding = size * 0.15;
  final gridSize = size - (gridPadding * 2);
  final cellSize = gridSize / 9;
  
  // Draw the grid
  for (int i = 0; i <= 9; i++) {
    // Horizontal lines
    final y = gridPadding + (i * cellSize);
    final strokeWidth = (i % 3 == 0) ? size / 25 : size / 80;
    paint.strokeWidth = strokeWidth;
    
    canvas.drawLine(
      Offset(gridPadding, y), 
      Offset(gridPadding + gridSize, y), 
      paint
    );
    
    // Vertical lines
    final x = gridPadding + (i * cellSize);
    paint.strokeWidth = strokeWidth;
    
    canvas.drawLine(
      Offset(x, gridPadding), 
      Offset(x, gridPadding + gridSize), 
      paint
    );
  }
  
  // Draw some numbers
  final textStyle = TextStyle(
    color: Colors.white,
    fontSize: cellSize * 0.7,
    fontWeight: FontWeight.bold,
  );
  
  final numberPositions = [
    [1, 2, 5],
    [4, 7, 6],
    [8, 3, 9],
  ];
  
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      if (numberPositions[row][col] > 0) {
        final number = numberPositions[row][col].toString();
        final textPainter = TextPainter(
          text: TextSpan(text: number, style: textStyle),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        
        final x = gridPadding + (col * 3 * cellSize) + cellSize + (cellSize - textPainter.width) / 2;
        final y = gridPadding + (row * 3 * cellSize) + cellSize + (cellSize - textPainter.height) / 2;
        
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }
  
  // Convert to an image
  final picture = recorder.endRecording();
  final img = await picture.toImage(size, size);
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();
  
  // Save to file
  final file = File(outputPath);
  await file.writeAsBytes(buffer);
}