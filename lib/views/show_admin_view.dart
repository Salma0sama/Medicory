import 'package:flutter/material.dart';
import 'package:medicory/models/get_admin_model.dart';
import 'package:medicory/widgets/admin_details_widget.dart';
import 'package:medicory/widgets/constants.dart';

class ShowAdminView extends StatefulWidget {
  final GetAdminModel getAdminModel;

  const ShowAdminView({
    Key? key,
    required this.getAdminModel,
  }) : super(key: key);

  @override
  State<ShowAdminView> createState() => _ShowOwnerState();
}

class _ShowOwnerState extends State<ShowAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Admin Details",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: AdminDetails(gatAdminModel: widget.getAdminModel),
          ),
        ],
      ),
    );
  }
}
