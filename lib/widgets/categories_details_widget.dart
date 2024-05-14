import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/widgets/constants.dart';

class Categories extends StatefulWidget {
  const Categories({super.key, required this.categories});
  final ButtonDetails categories;

  @override
  State<Categories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return widget.categories.Navigation();
                    },
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: kPrimaryColor,
            minimumSize: const Size(200, 50),
          ),
          child: Text(
            widget.categories.Text,
            style: TextStyle(
              color: kTextColor,
              fontSize: 19,
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
