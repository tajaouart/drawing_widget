/// [Point] represents the all the drawing steps which gives the desired path
/// created by the user while drawing
class Point {
  int x = 0;
  int y = 0;

  Point(this.x, this.y);

  @override
  String toString() {
    return 'Point{x: $x, y: $y}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
