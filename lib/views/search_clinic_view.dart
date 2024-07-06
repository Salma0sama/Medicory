import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_clinic_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:medicory/services/search_clinic_service.dart';
import 'package:medicory/views/clinic_details_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/search_clinic_container_widget.dart';

class SearchClinicView extends StatefulWidget {
  const SearchClinicView({Key? key}) : super(key: key);

  @override
  _SearchClinicViewState createState() => _SearchClinicViewState();
}

class _SearchClinicViewState extends State<SearchClinicView> {
  String searchText = "";
  String? searchWith;
  List<GetClinicSearch> clinic = [];
  FocusNode _focusNode = FocusNode();
  String selectedButton = "";
  bool isLoading = false;
  bool isButtonPressed = false;
  bool showErrorDialog = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void selectButton(String buttonName) {
    setState(() {
      selectedButton = buttonName;
      isButtonPressed = true; // Set the flag to true when a button is pressed
    });
  }

  void updateClinicEnabledStatus(int id, bool enabled, String clinicName) {
    setState(() {
      clinic = clinic.map((clinicItem) {
        if (clinicItem.clinicId == id) {
          clinicItem.enabled = enabled;
          clinicItem.clinicName = clinicName;
        }
        return clinicItem;
      }).toList();
    });
  }

  void navigateToEditClinic(GetClinicModel clinic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClinicDetailsView(
          getClinicModel: clinic,
          OnClinicUpdated: (bool enabled, String clinicName) {
            updateClinicEnabledStatus(clinic.id, enabled, clinicName);
          },
        ),
      ),
    );
  }

  void onClinicDeleted(int id) {
    setState(() {
      clinic = clinic.map((clinicItem) {
        if (clinicItem.clinicId == id) {
          clinicItem.enabled = false;
        }
        return clinicItem;
      }).toList();
    });
  }

  Future<void> searchClinics(String searchType) async {
    if (searchText.isEmpty) {
      // Display a message if the search text is empty
      AwesomeDialog(
        context: context,
        animType: AnimType.topSlide,
        dialogType: DialogType.error,
        title: 'Error',
        desc: 'Enter Search Term First',
        btnOkOnPress: () {
          setState(() {
            selectedButton = "";
          });
        },
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
      ).show();
      setState(() {
        showErrorDialog =
            true; // Set flag to true to prevent showing "No admin found" message
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    String url = "http://10.0.2.2:8081/admin/clinics/$searchType/$searchText";
    List<GetClinicSearch> clinicData;

    switch (searchType) {
      case 'code':
        clinicData = await SearchClinic(Dio()).showByCode(url);
        break;
      case 'name':
        clinicData = await SearchClinic(Dio()).showByName(url);
        break;
      case 'email':
        clinicData = await SearchClinic(Dio()).showByEmail(url);
        break;
      default:
        clinicData = [];
    }

    setState(() {
      isLoading = false;
      clinic = clinicData;
    });

    if (clinicData.isEmpty) {
      print("No Clinic found with this $searchType");
      setState(() {
        showErrorDialog = false; // Reset flag to false if there are no results
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Search Clinic",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(
                        Icons.search,
                        color: _focusNode.hasFocus ? Colors.blue : Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Search With ...",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        selectButton('Code');
                        await searchClinics('code');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selectedButton == 'Code'
                            ? Colors.blue
                            : Colors.white,
                        side: BorderSide(
                          color: selectedButton == 'Code'
                              ? Colors.blue
                              : Color.fromARGB(175, 0, 0, 0),
                        ),
                        foregroundColor: selectedButton == 'Code'
                            ? Colors.white
                            : Color.fromARGB(175, 0, 0, 0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.numbers,
                            color: selectedButton == 'Code'
                                ? Colors.white
                                : Color.fromARGB(175, 0, 0, 0),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Code',
                            style: TextStyle(
                              color: selectedButton == 'Code'
                                  ? Colors.white
                                  : Color.fromARGB(175, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        selectButton('Name');
                        await searchClinics('name');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selectedButton == 'Name'
                            ? Colors.blue
                            : Colors.white,
                        side: BorderSide(
                          color: selectedButton == 'Name'
                              ? Colors.blue
                              : Color.fromARGB(175, 0, 0, 0),
                        ),
                        foregroundColor: selectedButton == 'Name'
                            ? Colors.white
                            : Color.fromARGB(175, 0, 0, 0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            color: selectedButton == 'Name'
                                ? Colors.white
                                : Color.fromARGB(175, 0, 0, 0),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Name',
                            style: TextStyle(
                              color: selectedButton == 'Name'
                                  ? Colors.white
                                  : Color.fromARGB(175, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        selectButton('Email');
                        await searchClinics('email');
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: selectedButton == 'Email'
                            ? Colors.blue
                            : Colors.white,
                        side: BorderSide(
                          color: selectedButton == 'Email'
                              ? Colors.blue
                              : Color.fromARGB(175, 0, 0, 0),
                        ),
                        foregroundColor: selectedButton == 'Email'
                            ? Colors.white
                            : Color.fromARGB(175, 0, 0, 0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.email,
                            color: selectedButton == 'Email'
                                ? Colors.white
                                : Color.fromARGB(175, 0, 0, 0),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Email',
                            style: TextStyle(
                              color: selectedButton == 'Email'
                                  ? Colors.white
                                  : Color.fromARGB(175, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                  child: showErrorDialog
                      ? SizedBox() // Don't show any content when dialog is displayed
                      : clinic.isEmpty && isButtonPressed && !isLoading
                          ? Center(
                              child: Text(
                                "No Clinic found with this $selectedButton",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          : ListView(
                              children: clinic.map((clinic) {
                                Color containerColor = clinic.enabled
                                    ? kPrimaryColor
                                    : const Color.fromARGB(155, 33, 149, 243);
                                return GestureDetector(
                                  onTap: () async {
                                    String url =
                                        "http://10.0.2.2:8081/admin/clinics/id/${clinic.clinicId}/clinic";
                                    List<GetClinicModel> clinicData =
                                        await SearchClinic(Dio())
                                            .showClinicById(url);
                                    print(clinicData);
                                    if (clinicData.isNotEmpty) {
                                      navigateToEditClinic(clinicData[0]);
                                    }
                                  },
                                  child: SearchClinicContainer(
                                    infoContainer: InfoContainer(
                                      id: clinic.clinicId,
                                      fullName: clinic.clinicName,
                                      containerColor: containerColor,
                                      icon: Icon(Icons.delete,
                                          color: kTextColor), // Pass the icon
                                    ),
                                    getClinicSearch: clinic,
                                    onClinicDeleted:
                                        onClinicDeleted, // Pass callback here
                                  ),
                                );
                              }).toList(),
                            ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
