import 'package:flutter/material.dart';
import 'package:medicory/models/get_doctor_model.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/doctor_details_widget.dart';

class ShowDoctorView extends StatefulWidget {
  final GetDoctorModel getDoctorModel;

  const ShowDoctorView({
    Key? key,
    required this.getDoctorModel,
  }) : super(key: key);

  @override
  State<ShowDoctorView> createState() => _ShowOwnerState();
}

class _ShowOwnerState extends State<ShowDoctorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Doctor Details",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: DoctorDetails(
              getDoctorModel: widget.getDoctorModel,
            ),
          ),
        ],
      ),
    );
  }
}
