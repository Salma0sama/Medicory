// import 'package:flutter/material.dart';

// class CustomEditDropDownButton extends StatefulWidget {
//   const CustomEditDropDownButton({
//     Key? key,
//     required this.label,
//     required this.hint,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     required this.prefixIcon,
//   }) : super(key: key);

//   final String label;
//   final String hint;
//   final String value;
//   final List<String> items;
//   final ValueChanged<String> onChanged;
//   final Widget prefixIcon;

//   @override
//   _CustomEditDropDownButtonState createState() =>
//       _CustomEditDropDownButtonState();
// }

// class _CustomEditDropDownButtonState extends State<CustomEditDropDownButton> {
//   late String _selectedValue;

//   @override
//   void initState() {
//     super.initState();
//     _selectedValue = widget.value;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 16),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.blue, // Static border color
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
//       child: Row(
//         children: [
//           widget.prefixIcon, // Use prefixIcon to display icon
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   widget.label,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 Container(
//                   child: DropdownButtonHideUnderline(
//                     child: SizedBox(
//                       height: 35,
//                       child: DropdownButton<String>(
//                         isExpanded: true,
//                         dropdownColor: Colors.white,
//                         value: _selectedValue,
//                         icon: Icon(
//                           Icons.arrow_drop_down,
//                           color: Colors.blue,
//                         ),
//                         onChanged: (dynamic newValue) {
//                           setState(() {
//                             _selectedValue = newValue!;
//                             widget.onChanged(newValue!);
//                           });
//                         },
//                         items: widget.items.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 2),
//                               child: Text(value),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomEditDropDownButton extends StatefulWidget {
  const CustomEditDropDownButton({
    Key? key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.prefixIcon,
  }) : super(key: key);

  final String label;
  final String hint;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final Widget prefixIcon;

  @override
  _CustomEditDropDownButtonState createState() =>
      _CustomEditDropDownButtonState();
}

class _CustomEditDropDownButtonState extends State<CustomEditDropDownButton> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(CustomEditDropDownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue, // Static border color
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 8),
      child: Row(
        children: [
          widget.prefixIcon, // Use prefixIcon to display icon
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  child: DropdownButtonHideUnderline(
                    child: SizedBox(
                      height: 35,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        value: _selectedValue,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blue,
                        ),
                        onChanged: (dynamic newValue) {
                          setState(() {
                            _selectedValue = newValue!;
                            widget.onChanged(newValue!);
                          });
                        },
                        items: widget.items.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
