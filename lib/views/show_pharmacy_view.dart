import 'package:flutter/material.dart';
import 'package:medicory/models/get_pharmacy_model.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/pharmacy_details_widget.dart';

class ShowPharmacyView extends StatefulWidget {
  final GetPharmacyModel getPharmacyModel;

  const ShowPharmacyView({
    Key? key,
    required this.getPharmacyModel,
  }) : super(key: key);

  @override
  State<ShowPharmacyView> createState() => _ShowOwnerState();
}

class _ShowOwnerState extends State<ShowPharmacyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Pharmacy Details",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: PharmacyDetails(getPharmacyModel: widget.getPharmacyModel),
          ),
        ],
      ),
    );
  }
}
