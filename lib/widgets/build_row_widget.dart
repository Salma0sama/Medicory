import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/widgets/constants.dart';

class BuildRow extends StatelessWidget {
  const BuildRow({super.key, required this.rowData});
  final RowData rowData;
  // final String label;
  // final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            rowData.label,
            style: TextStyle(
              fontSize: 19,
              color: kPrimaryColor,
            ),
          ),
          Expanded(
            child: Text(
              rowData.value.toString(),
              style: TextStyle(
                fontSize: 19,
                color: kPrimaryColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}