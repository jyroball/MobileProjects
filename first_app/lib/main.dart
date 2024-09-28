import 'package:flutter/material.dart';
import 'package:first_app/gradient_container.dart';

void main() {
  runApp(
      const MaterialApp(
      home: Scaffold(
        body: GradientContainer(color: [ 
                Colors.green,
                Color.fromRGBO(208, 173, 112, 1) 
                ]),
      ),
    ),
  );
}
