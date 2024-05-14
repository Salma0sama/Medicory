import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';

class CustomDropdownButton extends StatelessWidget {
  final AddDropdownButton addDropdownButton;

  const CustomDropdownButton({super.key, required this.addDropdownButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            addDropdownButton.label,
            style: TextStyle(
              fontSize: 19,
              color: Colors.blue, // Customize the label color if needed
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: SizedBox(
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue, width: 1.2),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color:
                            Colors.blue, // Customize the icon color if needed
                      ),
                    ),
                    hint: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(addDropdownButton.hint),
                    ),
                    underline: SizedBox(),
                    value: addDropdownButton.value,
                    onChanged: addDropdownButton.onChanged,
                    items: addDropdownButton.items.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            valueItem,
                            style: TextStyle(
                                color: Colors
                                    .blue), // Customize the item text color if needed
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
