import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_admin_model.dart';
import 'package:medicory/views/edit_admin_view.dart';
import 'package:medicory/widgets/build_divider_widget.dart';
import 'package:medicory/widgets/build_row_widget.dart';
import 'package:medicory/widgets/button_widget.dart';

class AdminDetails extends StatefulWidget {
  const AdminDetails({Key? key, required this.gatAdminModel}) : super(key: key);
  final GetAdminModel gatAdminModel;

  @override
  State<AdminDetails> createState() => _AdminDetailsState();
}

class _AdminDetailsState extends State<AdminDetails> {
  late List<RowData> rowData;

  @override
  void initState() {
    super.initState();
    rowData = [
      RowData(label: 'First Name : ', value: widget.gatAdminModel.firstName),
      RowData(label: 'Last Name : ', value: widget.gatAdminModel.lastName),
      RowData(
          label: 'Marital Status : ',
          value: widget.gatAdminModel.maritalStatus),
      RowData(label: 'Gender : ', value: widget.gatAdminModel.gender),
      RowData(label: 'Code : ', value: widget.gatAdminModel.code),
      RowData(label: 'Email : ', value: widget.gatAdminModel.email),
      RowData(label: 'Password : ', value: widget.gatAdminModel.password),
      RowData(label: 'Role : ', value: widget.gatAdminModel.role),
      RowData(
          label: 'User phone : ',
          value: widget.gatAdminModel.userPhoneNumbers[0]),
      RowData(label: 'Enabled : ', value: widget.gatAdminModel.enabled),
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
                                      return EditAdminView(
                                        getAdminModel: widget.gatAdminModel,
                                      );
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
                                      "http://10.0.2.2:8081/admin/admins/id/${widget.gatAdminModel.id}"),
                                );

                                print("SUCCESS");
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
