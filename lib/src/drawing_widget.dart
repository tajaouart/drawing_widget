// Copyright 2022 tajaouart.com. All rights reserved.
// Use of this source code is governed by an Apache License 2.0 that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'drawing.dart';
import 'points.dart';
import 'package:collection/collection.dart';

/// Drawing widget for both drawing and displaying mode
class DrawingWidget extends StatefulWidget {
  const DrawingWidget({
    required this.drawing,
    required this.height,
    required this.width,
    this.removeSidesPadding = false,
    this.backgroundColor = Colors.black12,
    this.isDrawing = false,
    this.onUpdate,
    this.clipBehavior = Clip.antiAlias,
    Key? key,
  }) : super(key: key);

  /// [height] desired height of the drawing view
  final double height;

  /// [width] desired width of the drawing view
  final double width;

  /// [isDrawing] specify wether it's in drawing or displaying mode
  final bool isDrawing;

  /// [drawing] drawing object holding some properties
  /// the drawing and the sides
  final Drawing drawing;

  /// [backgroundColor] of the drawing scene
  final Color backgroundColor;

  /// [removeSidesPadding] specify uf you wish to remove the left space between
  final bool removeSidesPadding;

  /// [clipBehavior] enable or not drawing outside boundaries
  final Clip clipBehavior;

  /// [onUpdate] called each time a line has been drawn
  final Function(List<List<Point>>)? onUpdate;

  @override
  State<DrawingWidget> createState() => _DrawingWidgetState();
}

class _DrawingWidgetState extends State<DrawingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: ClipRRect(
        clipBehavior: widget.clipBehavior,
        child: RepaintBoundary(
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
      ),
    );
  }

  /// called whenever the user tries to draw
  /// it creates a new path
  void _onDragUpdate(DragUpdateDetails details) {
    var mouseX = details.localPosition.dx;
    var mouseY = details.localPosition.dy;

    if (widget.drawing.points.isEmpty) {
      widget.drawing.points.add(List.empty(growable: true));
    }
    setState(() {
      widget.drawing.points.last.add(Point(mouseX.toInt(), mouseY.toInt()));
    });
  }

  /// once the user stops drawing we close the current path
  void _onDragEnd(DragEndDetails _) {
    widget.drawing.points.add(List.empty(growable: true));
    widget.onUpdate?.call(widget.drawing.points);
  }
}

/// Drawing content
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
    final pointsList = drawing.points.expand((element) => element).toList();
    final xList = pointsList.map((e) => e.x).toList();
    final yList = pointsList.map((e) => e.y).toList();
    if (xList.isEmpty) {
      return;
    }

    if (isDrawing) {
      // once the drawing ends and the width and the height of the drawn shape
      // are assigned they should not be modified
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
