import 'package:flutter/material.dart';
import 'package:medicory/models/get_lab_model.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/lab_details_widget.dart';

class ShowLabView extends StatefulWidget {
  final GetLabModel getLabModel;

  const ShowLabView({Key? key, required this.getLabModel}) : super(key: key);

  @override
  State<ShowLabView> createState() => _ShowOwnerState();
}

class _ShowOwnerState extends State<ShowLabView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Lab Details",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: LabDetails(
              getLabModel: widget.getLabModel,
            ),
          ),
        ],
      ),
    );
  }
}
