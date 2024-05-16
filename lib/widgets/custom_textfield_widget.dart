import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/widgets/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key, required this.addTextField})
      : super(key: key);
  final AddTextField addTextField;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Text(
              addTextField.Label,
              style: TextStyle(
                fontSize: 19,
                color: kPrimaryColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kPrimaryColor, width: 1.2),
                    ),
                    child: TextField(
                      onChanged: addTextField.onchange,
                      keyboardType:
                          addTextField.keyboardType ?? TextInputType.text,
                      decoration: InputDecoration(
                        hintText: addTextField.hintText,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
