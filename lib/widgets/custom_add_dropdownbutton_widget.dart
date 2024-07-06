import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';

class CustomDropdownButton extends StatefulWidget {
  final AddDropdownButton addDropdownButton;

  const CustomDropdownButton({super.key, required this.addDropdownButton});

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
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
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.addDropdownButton.label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: _isFocused ? Colors.blue : Colors.grey, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: Row(
                  children: [
                    if (widget.addDropdownButton.prefixIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: widget.addDropdownButton.prefixIcon!(_isFocused),
                      ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        focusNode: _focusNode,
                        isExpanded: true,
                        icon: Container(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: _isFocused ? Colors.blue : Colors.black,
                          ),
                        ),
                        hint: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(widget.addDropdownButton.hint),
                        ),
                        value: widget.addDropdownButton.value,
                        onChanged: (newValue) {
                          widget.addDropdownButton.onChanged(newValue);
                          setState(() {
                            _focusNode.unfocus();
                          });
                        },
                        items: widget.addDropdownButton.items.map((valueItem) {
                          return DropdownMenuItem<String>(
                            value: valueItem,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                valueItem,
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: InputBorder.none, // Remove underline
                          contentPadding: EdgeInsets.zero,
                        ),
                        menuMaxHeight: 48 *
                            6, // Set the maximum height of the dropdown menu
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
