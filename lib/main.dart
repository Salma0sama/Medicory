import 'package:flutter/material.dart';
import 'package:medicory/views/lab_home_view.dart';

void main() {
  runApp(const Admin());
}

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LabHomeView(),
    );
  }
}
