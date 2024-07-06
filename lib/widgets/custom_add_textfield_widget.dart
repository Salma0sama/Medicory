import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/widgets/constants.dart';

class CustomAddTextField extends StatefulWidget {
  const CustomAddTextField({Key? key, required this.addTextField})
      : super(key: key);
  final AddTextField addTextField;

  @override
  _CustomAddTextFieldState createState() => _CustomAddTextFieldState();
}

class _CustomAddTextFieldState extends State<CustomAddTextField> {
  late FocusNode _focusNode;
  late bool _isFocused;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _isFocused = false;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.addTextField.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isFocused ? kPrimaryColor : Colors.grey,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: widget.addTextField.prefixIcon(_isFocused),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextField(
                        controller: widget.addTextField.controller,
                        focusNode: _focusNode,
                        keyboardType: widget.addTextField.keyboardType ??
                            TextInputType.text,
                        decoration: InputDecoration(
                          hintText: widget.addTextField.hintText,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
