import 'package:flutter/material.dart';
import 'package:medicory/models/get_clinic_model.dart';
import 'package:medicory/widgets/clinic_details_widget.dart';
import 'package:medicory/widgets/constants.dart';

class ShowClinicView extends StatefulWidget {
  final GetClinicModel getClinicModel;

  const ShowClinicView({
    Key? key,
    required this.getClinicModel,
  }) : super(key: key);

  @override
  State<ShowClinicView> createState() => _ShowOwnerState();
}

class _ShowOwnerState extends State<ShowClinicView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Clinic Details",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: ClinicDetails(getClinicModel: widget.getClinicModel),
          ),
        ],
      ),
    );
  }
}
