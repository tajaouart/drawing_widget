// Copyright 2022 tajaouart.com. All rights reserved.
// Use of this source code is governed by an Apache License 2.0 that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'drawing.dart';
import 'points.dart';
import 'package:collection/collection.dart';

class DrawingWidget extends StatefulWidget {
  const DrawingWidget({
    required this.drawing,
    required this.height,
    required this.width,
    this.removeSidesPadding = false,
    this.isDrawing = false,
    this.onUpdate,
    Key? key,
  }) : super(key: key);

  final double height;
  final double width;
  final bool isDrawing;
  final Drawing drawing;
  final bool removeSidesPadding;
  final Function(List<List<Point>>)? onUpdate;

  @override
  State<DrawingWidget> createState() => _DrawingWidgetState();
}

class _DrawingWidgetState extends State<DrawingWidget> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DrawPainter(
                  removeSidesPadding: widget.removeSidesPadding,
                  isDrawing: widget.isDrawing,
                  drawing: widget.drawing,
                  height: widget.height,
                  width: widget.width,
                ),
                child: Container(),
              ),
            ),
            if (widget.isDrawing)
              Positioned.fill(
                child: GestureDetector(
                  onHorizontalDragEnd: _onDragEnd,
                  onVerticalDragEnd: _onDragEnd,
                  onHorizontalDragUpdate: _onDragUpdate,
                  onVerticalDragUpdate: _onDragUpdate,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    debugPrint('++++++ $details');
    var mouseX = details.localPosition.dx;
    var mouseY = details.localPosition.dy;

    if (widget.drawing.points.isEmpty) {
      widget.drawing.points.add([]);
    }
    setState(() {
      widget.drawing.points.last.add(Point(mouseX.toInt(), mouseY.toInt()));
    });
  }

  void _onDragEnd(DragEndDetails _) {
    debugPrint('++++++ end');
    widget.drawing.points.add([]);
    widget.onUpdate?.call(widget.drawing.points);
  }
}

class _DrawPainter extends CustomPainter {
  _DrawPainter({
    required this.isDrawing,
    required this.drawing,
    required this.width,
    required this.height,
    required this.removeSidesPadding,
  });

  final bool isDrawing;
  final Drawing drawing;
  final double width;
  final double height;
  final bool removeSidesPadding;

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('++++++ ${drawing.color}');
    final pointsList = drawing.points.expand((element) => element).toList();
    final xList = pointsList.map((e) => e.x).toList();
    final yList = pointsList.map((e) => e.y).toList();
    if (xList.isEmpty) {
      return;
    }

    if (isDrawing) {
      if (removeSidesPadding) {
        drawing.width = (xList.max - xList.min).toDouble();
        drawing.height = (yList.max - yList.min).toDouble();
      } else {
        drawing.width = width;
        drawing.height = height;
      }
    }

    final scaleWidth = isDrawing ? 1.0 : width / drawing.width;
    final scaleHeight = isDrawing ? 1.0 : height / drawing.height;

    Paint paint = Paint()
      ..color = drawing.color
      ..strokeWidth = drawing.stroke
      ..style = PaintingStyle.stroke;

    for (final path in drawing.points) {
      final p = Path();
      if (path.isNotEmpty) {
        p.moveTo((path.first.x * scaleWidth), (path.first.y * scaleHeight));
      }

      for (final point in path) {
        p.lineTo((point.x * scaleWidth), (point.y * scaleHeight));
      }
      canvas.drawPath(p, paint);
    }
  }

  @override
  bool shouldRepaint(_DrawPainter oldDelegate) {
    return true;
  }
}
