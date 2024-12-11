import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/screens/home_screen.dart';

void main(){
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:" Weather app",
      home: home_screen(),
    );
  }
}
