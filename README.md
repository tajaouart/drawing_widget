
Light widget to make some drawing.


<img src="https://raw.githubusercontent.com/tajaouart/drawing_widget/main/drawing_widget.gif" height="600"/>

## Features

* Drawing & displaying mode.
* Change color.
* Change stroke value.
* Adaptative size.


## Usage

Change drawing property to ether start drawing or display a drawing.



```dart

final _drawing = Drawing(
  strokeColor: Colors.black,
  strokeValue: 2,
  isDrawing: true,
);

DrawingWidget(
 drawing: _drawing,
 onUpdate: (value) {
 points = value;
 },
)
```

## Additional information

Don't hesitate to contribute or to contact me if needed.
