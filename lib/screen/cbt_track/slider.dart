import 'package:flutter/material.dart';

class sliders extends StatefulWidget {
  const sliders({super.key});

  @override
  State<sliders> createState() => _slidersState();
}

class _slidersState extends State<sliders> {
  double _value1 = 0.0;
  double _value2 = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slider Screen'),
      ),
      body: Column(children: [
        slide(_value1, (value) {
          setState(() {
            _value1 = value;
          });
        }),
        slide(_value2, (value) {
          setState(() {
            _value2 = value;
          });
        })
      ]),
    );
  }

  Slider slide(double _value, ValueChanged onchanged) {
    return Slider(
        value: _value,
        label: _value.toString(),
        min: 0.0,
        max: 100.0,
        divisions: 10,
        activeColor: Colors.green,
        inactiveColor: Colors.orange,
        onChanged: onchanged);
  }
}
