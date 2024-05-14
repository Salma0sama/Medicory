// import 'package:flutter/material.dart';
// import 'package:medicory/models/general_model.dart';
// import 'package:medicory/widgets/build_divider_widget.dart';
// import 'package:medicory/widgets/build_row_widget.dart';

// class ShowDetails extends StatelessWidget {
//   const ShowDetails({
//     super.key,
//     required this.isLoading,
//     required this.rowData,
//   });

//   final bool isLoading;
//   final List<RowData> rowData;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           isLoading
//               ? Expanded(
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 )
//               : Expanded(
//                   child: ListView.builder(
//                     physics: BouncingScrollPhysics(),
//                     itemCount: rowData.length,
//                     itemBuilder: (context, index) {
//                       return Column(
//                         children: [
//                           BuildRow(
//                             rowData: RowData(
//                                 label: rowData[index].label,
//                                 value: rowData[index].value),
//                           ),
//                           BuildDivider(),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
