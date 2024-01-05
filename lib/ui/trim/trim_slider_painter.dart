import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:video_editor/domain/entities/trim_style.dart';

class TrimSliderPainter extends CustomPainter {
  TrimSliderPainter(
    this.image,
    this.rect,
    this.position,
    this.style, {
    this.isTranslucent = false,
  });

  final Rect rect;
  final double position;
  final TrimSliderStyle style;
  final ui.Image image;
  final bool isTranslucent;

  Path createCShapePath(Rect rect, double radius) {
    Path path = Path();

    // Moves the starting point to the right edge of the rectangle
    path.moveTo(rect.right, rect.top);

    // Draws a line from the starting point to the top right corner of the rectangle
    path.lineTo(rect.left + radius, rect.top);

    // Draws an arc to the top left corner of the rectangle
    path.arcToPoint(
      Offset(rect.left, rect.top + radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // Draws a line from the top left corner to the bottom left corner
    path.lineTo(rect.left, rect.bottom - radius);

    // Draws an arc to the bottom left corner of the rectangle
    path.arcToPoint(
      Offset(rect.left + radius, rect.bottom),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // Draws a line from the bottom left corner to the bottom right corner
    path.lineTo(rect.right, rect.bottom);

    return path;
  }

  Path createInvertedCShapePath(Rect rect, double radius) {
    Path path = Path();

    // Moves the starting point to top left corner of the rectangle
    path.moveTo(rect.left, rect.top);

    // Draw line from top left to top right corner decrasing the radius
    path.lineTo(rect.right - radius, rect.top);

    // Draws an arc to the top right corner of the rectangle
    path.arcToPoint(
      Offset(rect.right, rect.top + radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );

    // Draws a line from the top right corner to the bottom right corner
    path.lineTo(rect.right, rect.bottom - radius);

    // Draws an arc to the bottom right corner of the rectangle
    path.arcToPoint(
      Offset(rect.right - radius, rect.bottom),
      radius: Radius.circular(radius),
      clockwise: true,
    );

    // Draws a line from the bottom right corner to the bottom left corner
    path.lineTo(rect.left, rect.bottom);

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) async {
    final Paint backgroundFill = Paint()
      ..color = isTranslucent
          ? Colors.black.withOpacity(.5)
          : const Color(0xffeef0f9);

    final Paint backgroundBorder = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xffd9deef)
      ..strokeWidth = 2.0;

    final progress = Paint()
      ..color = const Color(0xff3684F8)
      ..strokeWidth = style.positionLineWidth;

    final line = Paint()
      ..color = const Color(0xff989eb3)
      ..strokeWidth = style.lineWidth
      ..strokeCap = StrokeCap.square;

    final double halfLineWidth = style.lineWidth / 2;

    final double halfHeight = rect.height / 2;

    const backgroundRectRadius = 8.0;

    // Displays the progess line
    canvas.drawRect(
      Rect.fromPoints(
        Offset(position - halfLineWidth, 0.0),
        Offset(position + halfLineWidth, size.height),
      ),
      progress,
    );

    // Displays the left background
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(
          Offset.zero,
          rect.bottomLeft, // Bottom-left corner of the rectangle
        ),
        topLeft: const Radius.circular(backgroundRectRadius),
        bottomLeft: const Radius.circular(backgroundRectRadius),
      ),
      backgroundFill,
    );

    // Draws the border of left background
    canvas.drawPath(
      createCShapePath(
          Rect.fromPoints(
            Offset.zero,
            rect.bottomLeft, // Bottom-left corner of the rectangle
          ),
          backgroundRectRadius),
      backgroundBorder,
    );

    // Displays the right background
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromPoints(
          rect.topRight,
          Offset(size.width, size.height),
        ),
        topRight: const Radius.circular(backgroundRectRadius),
        bottomRight: const Radius.circular(backgroundRectRadius),
      ),
      backgroundFill,
    );

    // Draws the border of right background
    canvas.drawPath(
      createInvertedCShapePath(
          Rect.fromPoints(
            rect.topRight,
            Offset(size.width, size.height),
          ),
          backgroundRectRadius),
      backgroundBorder,
    );

    //TOP LINE
    canvas.drawLine(
      rect.topLeft,
      rect.topRight,
      line,
    );

    // BOTTOM LINE
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomRight,
      line,
    );

    // Left slider
    canvas.drawImage(
        image,
        Offset(
            rect.left - style.iconSize / 4, halfHeight - style.iconSize / 1.3),
        Paint());

    // Right slider
    canvas.drawImage(
      image,
      Offset(
          rect.right - style.iconSize / 4, halfHeight - style.iconSize / 1.3),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(TrimSliderPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TrimSliderPainter oldDelegate) => false;
}
