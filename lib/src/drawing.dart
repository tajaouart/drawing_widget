import 'package:drawing_widget/src/points.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Holds some parameters for, the [drawingWidget]
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

  /// id to provide easy comparison
  late final String id;

  /// data of the drawing/shape
  /// representing the list of paths which are themselves are lists of points
  List<List<Point>> points = List<List<Point>>.empty(growable: true);

  /// [width] should not be modified as it hols the original aspectRatio of the drawing
  double width = 0;

  /// [height] should not be modified as it hols the original aspectRatio of the drawing
  double height = 0;

  /// [stroke] of the drawing line
  double stroke = 2;

  /// [color] of the drawing line
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
