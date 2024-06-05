import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_clinic_model.dart';
import 'package:medicory/views/edit_clinic_view.dart';
import 'package:medicory/widgets/build_divider_widget.dart';
import 'package:medicory/widgets/build_row_widget.dart';
import 'package:medicory/widgets/button_widget.dart';

class ClinicDetails extends StatefulWidget {
  const ClinicDetails({Key? key, required this.getClinicModel})
      : super(key: key);
  final GetClinicModel getClinicModel;

  @override
  State<ClinicDetails> createState() => _ClinicDetailsState();
}

class _ClinicDetailsState extends State<ClinicDetails> {
  late List<RowData> rowData;

  @override
  void initState() {
    super.initState();
    rowData = [
      RowData(label: 'Name : ', value: widget.getClinicModel.name),
      RowData(
          label: 'Google Maps Link : ',
          value: widget.getClinicModel.googleMapsLink),
      RowData(label: 'Address : ', value: widget.getClinicModel.address),
      RowData(label: 'Owner Name : ', value: widget.getClinicModel.ownerName),
      RowData(
          label: 'Specialization : ',
          value: widget.getClinicModel.specialization),
      RowData(label: 'Code : ', value: widget.getClinicModel.code),
      RowData(label: 'Email : ', value: widget.getClinicModel.email),
      RowData(label: 'Password : ', value: widget.getClinicModel.password),
      RowData(label: 'Role : ', value: widget.getClinicModel.role),
      RowData(
          label: 'phone : ', value: widget.getClinicModel.userPhoneNumbers[0]),
      RowData(
          label: 'Enabled : ', value: widget.getClinicModel.enabled.toString()),
    ];
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: [
          isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: rowData.length + 1,
                    itemBuilder: (context, index) {
                      if (index < rowData.length) {
                        return Column(
                          children: [
                            BuildRow(
                              rowData: RowData(
                                  label: rowData[index].label,
                                  value: rowData[index].value),
                            ),
                            BuildDivider(),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Button(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditClinicView(
                                          getClinicModel:
                                              widget.getClinicModel);
                                    },
                                  ),
                                );
                              },
                              text: "Edit",
                            ),
                            SizedBox(
                              width: 35,
                            ),
                            Button(
                              onPressed: () async {
                                await http.delete(
                                  Uri.parse(
                                      "http://10.0.2.2:8081/admin/clinics/id/${widget.getClinicModel.id}"),
                                );
                              },
                              color: Colors.red,
                              text: "Delete",
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
