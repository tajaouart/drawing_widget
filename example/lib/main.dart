import 'package:drawing_widget/drawing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Drawing Widget Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double drawingWidth = 200;
  double drawingHeight = 200;
  bool isDrawing = true;
  Drawing drawing = Drawing();
  bool clipRRect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: DrawingWidget(
                drawing: drawing,
                isDrawing: isDrawing,
                width: drawingWidth,
                height: drawingHeight,
                removeSidesPadding: false,
                clipBehavior: clipRRect ? Clip.antiAlias : Clip.none,
                onUpdate: (drawingObject) {
                  // do some job
                },
              ),
            ),
            // Parameters widgets
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (!isDrawing)
                    Row(
                      children: [
                        const Text(('Width : ')),
                        Expanded(
                          child: Slider(
                            value: drawingWidth,
                            min: 20,
                            max: 300,
                            onChanged: (value) {
                              setState(() {
                                drawingWidth = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  if (!isDrawing)
                    Row(
                      children: [
                        const Text(('Height : ')),
                        Expanded(
                          child: Slider(
                            value: drawingHeight,
                            min: 20,
                            max: 300,
                            onChanged: (value) {
                              setState(() {
                                drawingHeight = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      const Text(('Stroke : ')),
                      Expanded(
                        child: Slider(
                          value: drawing.stroke,
                          min: 1,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              drawing.stroke = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(('Height : ')),
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () async {
                            final color =
                                await _showColorDialogue(drawing.color);

                            setState(() {
                              drawing.color = color;
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: drawing.color,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(('ClipRRect : ')),
                      Switch(
                        value: clipRRect,
                        onChanged: (value) {
                          setState(() {
                            clipRRect = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (isDrawing) {
              isDrawing = false;
            } else {
              drawing = Drawing();
              drawingWidth = 300;
              drawingHeight = 300;
              isDrawing = true;
            }
          });
        },
        child: Icon(
          isDrawing ? Icons.pause_rounded : Icons.play_arrow_rounded,
        ),
      ),
    );
  }

  Future<Color> _showColorDialogue(Color defaultColor) async {
    var c = defaultColor;

    await showDialog<Color>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: c,
              onColorChanged: (Color color) {
                c = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <TextButton>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return c;
  }
}
