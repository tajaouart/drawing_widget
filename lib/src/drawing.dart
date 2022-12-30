import 'package:drawing_widget/src/points.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Drawing {
  Drawing({
    List<List<Point>>? points,
    this.width = 0,
    this.height = 0,
    this.stroke = 2,
    this.color = Colors.black,
    String? id,
  }) {
    this.id = id ?? const Uuid().v1();
    this.points = points ?? [];
  }

  late final String id;

  List<List<Point>> points = List.empty(growable: true);
  double width = 0;
  double height = 0;
  double stroke = 2;
  Color color = Colors.black;
}
