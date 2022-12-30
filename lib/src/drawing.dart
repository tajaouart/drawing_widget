import 'package:drawing_widget/src/points.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Holds some parameters for, the [drawingWidget]
/// [width] & [height] should not be modified as they hold the original
/// aspectRatio of the drawing
/// [stroke] of the drawing line
/// [color] of the drawing line
/// [points] data of the drawing/shape
/// representing the list of paths which are themselves are lists of points
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
    this.points = points ?? List.empty(growable: true);
  }

  late final String id;

  List<List<Point>> points = List<List<Point>>.empty(growable: true);
  double width = 0;
  double height = 0;
  double stroke = 2;
  Color color = Colors.black;

  @override
  String toString() {
    return 'Drawing{id: $id, points: $points, width: $width, height: $height, stroke: $stroke, color: $color}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Drawing &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          points == other.points &&
          width == other.width &&
          height == other.height &&
          stroke == other.stroke &&
          color == other.color;

  @override
  int get hashCode =>
      id.hashCode ^
      points.hashCode ^
      width.hashCode ^
      height.hashCode ^
      stroke.hashCode ^
      color.hashCode;
}
