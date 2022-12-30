import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drawing_widget/drawing_widget.dart';

void main() {
  testWidgets('Test pump widget', (tester) async {
    final drawing = Drawing();

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 100,
          height: 200,
          child: DrawingWidget(
            drawing: drawing,
            height: 200,
            width: 100,
          ),
        ),
      ),
    );

    expect(drawing.points.isEmpty, true);
  });

  testWidgets('Test drawing in drawing mode > isDrawing : true', (tester) async {
    final drawing = Drawing();

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 100,
          height: 200,
          child: DrawingWidget(
            drawing: drawing,
            height: 200,
            width: 100,
            isDrawing: true,
          ),
        ),
      ),
    );

    await tester.drag(find.byType(DrawingWidget), const Offset(50.0, 50.0));

    expect(drawing.points.isNotEmpty, true);
  });

  testWidgets('Test drawing in display mode > isDrawing : false', (tester) async {
    final drawing = Drawing();

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 100,
          height: 200,
          child: DrawingWidget(
            drawing: drawing,
            height: 200,
            width: 100,
            isDrawing: false,
          ),
        ),
      ),
    );

    await tester.drag(find.byType(DrawingWidget), const Offset(50.0, 50.0));

    expect(drawing.points.isEmpty, true);
  });


  testWidgets('Test drawing two paths', (tester) async {
    final drawing = Drawing();

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 100,
          height: 200,
          child: DrawingWidget(
            drawing: drawing,
            height: 200,
            width: 100,
            isDrawing: true,
          ),
        ),
      ),
    );

    await tester.drag(find.byType(DrawingWidget), const Offset(50.0, 50.0));
    await tester.drag(find.byType(DrawingWidget), const Offset(50.0, 50.0));

    expect(drawing.points[0].isNotEmpty, true);
    expect(drawing.points[1].isNotEmpty, true);
  });

}


