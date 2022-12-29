
Light widget make some drawing.


<img src="" height="600"/>

## Features

* Drawing & displaying mode.
* Change color.
* Change stroke value.
* Adaptative size.


## Usage

Change drawing property to ether start drawing or display a drawing.



```dart

final _points = [];

DrawingWidget(
 points: _points,
 strokeColor: Colors.black,
 strokeValue: 2,
 drawing: true,
 onUpdate: (value) {
 points = value;
 },
)
```

## Additional information

Don't hesitate to contribute or to contact me if needed.
