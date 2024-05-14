import 'package:flutter/material.dart';
import 'package:medicory/models/get_hospital_model.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/hospital_details_widget.dart';

class ShowHospitalView extends StatefulWidget {
  final GetHospitalModel getHospitalModel;

  const ShowHospitalView({
    Key? key,
    required this.getHospitalModel,
  }) : super(key: key);

  @override
  State<ShowHospitalView> createState() => _ShowOwnerState();
}

class _ShowOwnerState extends State<ShowHospitalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Hospital Details",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: HospitalDetails(getHospitalModel: widget.getHospitalModel),
          ),
        ],
      ),
    );
  }
}
