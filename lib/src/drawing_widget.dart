// Copyright 2022 tajaouart.com. All rights reserved.
// Use of this source code is governed by an Apache License 2.0 that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'points.dart';

class DrawingWidget extends StatefulWidget {
  const DrawingWidget({
    this.strokeColor = Colors.black,
    this.points = const [],
    this.drawing = false,
    this.strokeValue = 1,
    this.onUpdate,
    Key? key,
  }) : super(key: key);

  final List<List<Point>> points;
  final double strokeValue;
  final Color strokeColor;
  final bool drawing;
  final Function(List<List<Point>>)? onUpdate;

  @override
  State<DrawingWidget> createState() => _DrawingWidgetState();
}

class _DrawingWidgetState extends State<DrawingWidget> {
  var points = <List<Point>>[];

  @override
  void initState() {
    points = widget.points.toSet().toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth;
      final double maxHeight;
      if (constraints.maxWidth.toString() == 'NaN') {
        maxWidth = 0;
      } else {
        maxWidth = constraints.maxWidth;
      }

      if (constraints.maxWidth.toString() == 'NaN') {
        maxHeight = 0;
      } else {
        maxHeight = constraints.maxHeight;
      }

      return RepaintBoundary(
        child: ClipRRect(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: DrawPainter(
                    points,
                    color: widget.strokeColor,
                    strokeValue: widget.strokeValue,
                    drawing: widget.drawing,
                    height: maxHeight,
                    width: maxWidth,
                  ),
                  child: Container(),
                ),
              ),
              if (widget.drawing)
                Positioned.fill(
                  child: GestureDetector(
                    onHorizontalDragEnd: (_) {
                      points.add([]);
                      widget.onUpdate?.call(points);
                    },
                    onVerticalDragEnd: (_) {
                      points.add([]);
                      widget.onUpdate?.call(points);
                    },
                    onHorizontalDragUpdate: (details) {
                      var mouseX = details.localPosition.dx;
                      var mouseY = details.localPosition.dy;

                      if (mouseX > maxWidth || mouseX < 0) {
                        return;
                      }
                      if (mouseY > maxHeight || mouseX < 0) {
                        return;
                      }

                      if (points.isEmpty) {
                        points.add([]);
                      }
                      setState(() {
                        points.last.add(Point(mouseX.toInt(), mouseY.toInt()));
                      });
                    },
                    onVerticalDragUpdate: (details) {
                      var mouseX = details.localPosition.dx;
                      var mouseY = details.localPosition.dy;
                      if (points.isEmpty) {
                        points.add([]);
                      }
                      setState(() {
                        points.last.add(Point(mouseX.toInt(), mouseY.toInt()));
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class DrawPainter extends CustomPainter {
  DrawPainter(
      this.points, {
        required this.color,
        required this.strokeValue,
        this.drawing = false,
        required this.width,
        required this.height,
      });

  final List<List<Point>> points;
  final double strokeValue;
  final Color color;
  final bool drawing;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    final pointsList = points.expand((element) => element).toList();
    final xList = pointsList.map((e) => e.x).toList();
    if (xList.isEmpty) {
      return;
    }

    final scaleWidth = width / size.width;
    final scaleHeight = height / size.height;

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeValue
      ..style = PaintingStyle.stroke;

    for (final path in points) {
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
  bool shouldRepaint(DrawPainter oldDelegate) {
    return true;
  }
}
