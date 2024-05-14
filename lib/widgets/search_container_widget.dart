import 'package:flutter/material.dart';
import 'package:medicory/widgets/constants.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer(
      {Key? key,
      required this.id,
      required this.fullName,
      required this.containerColor});
  final int id;
  final String fullName;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        height: 80,
        color: containerColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '$id', // Corrected interpolation syntax
                style: TextStyle(
                  fontSize: 19,
                  color: kTextColor,
                ),
              ),
              VerticalDivider(
                color: Colors.white,
                thickness: 1.2,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$fullName', // Corrected interpolation syntax
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
