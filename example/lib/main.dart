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
  double drawingWidth = 10;
  double drawingHeight = 10;
  bool isDrawing = true;
  Drawing drawing = Drawing();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black12,
              width: screenWidth,
              height: screenWidth,
              child: Center(
                child: DrawingWidget(
                  drawing: drawing,
                  isDrawing: isDrawing,
                  width: screenWidth * (drawingWidth / 10),
                  height: screenWidth * (drawingHeight / 10),
                  onUpdate: (drawingObject) {
                    /// TODO
                  },
                ),
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
                            min: 1,
                            max: 10,
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
                            min: 1,
                            max: 10,
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
              drawingWidth = 10;
              drawingHeight = 10;
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
