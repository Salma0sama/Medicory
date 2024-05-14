import 'package:flutter/material.dart';

class BuildDivider extends StatelessWidget {
  const BuildDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Color.fromARGB(143, 33, 149, 243),
      thickness: 1.2,
      indent: 10,
      endIndent: 10,
      height: 20,
    );
  }
}
