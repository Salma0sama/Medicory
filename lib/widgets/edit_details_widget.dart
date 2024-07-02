// import 'package:flutter/material.dart';
// import 'package:medicory/widgets/constants.dart';

// class EditDetails extends StatelessWidget {
//   const EditDetails({
//     Key? key,
//     required this.label,
//     required this.controller,
//     required this.onchange,
//     this.readonly,
//     required this.hintText,
//   }) : super(key: key);

//   final String label;
//   final String hintText;
//   final TextEditingController controller;
//   final Function(dynamic) onchange;
//   final bool? readonly;

//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 12),
//         child: Row(
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 19,
//                 color: kPrimaryColor,
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 16),
//                 child: SizedBox(
//                   height: 50,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.blue, width: 1.2),
//                     ),
//                     child: TextField(
//                       readOnly: readonly ?? false,
//                       onChanged: onchange,
//                       controller: controller,
//                       decoration: InputDecoration(
//                         hintText: hintText,
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:medicory/widgets/constants.dart';

class EditDetails extends StatelessWidget {
  const EditDetails({
    Key? key,
    required this.label,
    required this.controller,
    required this.onchange,
    this.readonly,
    required this.hintText,
  }) : super(key: key);

  final String label;
  final String hintText;
  final TextEditingController controller;
  final Function(dynamic) onchange;
  final bool? readonly;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          children: [
            SizedBox(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor,
                ),
              ),
            ),
            // Text(
            //   ":",
            //   style: TextStyle(
            //     fontSize: 19,
            //     color: kPrimaryColor,
            //   ),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SizedBox(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue, width: 1.2),
                    ),
                    child: TextField(
                      readOnly: readonly ?? false,
                      onChanged: onchange,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
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
