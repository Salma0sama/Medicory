import 'package:flutter/material.dart';
import 'package:medicory/models/get_owner_model.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/owner_details_widget.dart';

class ShowOwnerView extends StatefulWidget {
  final GetOwnerModel getOwnerModel;
  final RelativePhoneNumber relativePhoneNumber;
  final UserDetail userDetail;
  final UserPhoneNumber userPhoneNumber;

  const ShowOwnerView(
      {Key? key,
      required this.getOwnerModel,
      required this.relativePhoneNumber,
      required this.userDetail,
      required this.userPhoneNumber})
      : super(key: key);

  @override
  State<ShowOwnerView> createState() => _ShowOwnerState();
}

class _ShowOwnerState extends State<ShowOwnerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Owner Details",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: OwnerDetails(
              getOwnerModel: widget.getOwnerModel,
              relativePhoneNumber: widget.relativePhoneNumber,
              userDetail: widget.userDetail,
              userPhoneNumber: widget.userPhoneNumber,
            ),
          ),
        ],
      ),
    );
  }
}
