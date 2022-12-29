
Light widget make some drawing.


<img src="" height="600"/>

## Features

* Drawing & display mode.
* Change color.
* Change stroke value.
* Adaptative size.


## Usage

Change drawing value to ether start drawing or display a drawing.



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
