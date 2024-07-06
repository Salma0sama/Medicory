import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/get_pharmacy_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:medicory/services/search_pharmacy_service.dart';
import 'package:medicory/views/pharmacy_details_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/search_pharmacy_container_widget.dart';

class SearchPharmacyView extends StatefulWidget {
  const SearchPharmacyView({Key? key}) : super(key: key);

  @override
  _SearchPharmacyViewState createState() => _SearchPharmacyViewState();
}

class _SearchPharmacyViewState extends State<SearchPharmacyView> {
  String searchText = "";
  String? searchWith;
  List<GetPharmacySearch> pharmacy = [];
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

  void updatePharmacyEnabledStatus(int id, bool enabled, String pharmacyName) {
    setState(() {
      pharmacy = pharmacy.map((pharmacyItem) {
        if (pharmacyItem.pharmacyId == id) {
          pharmacyItem.enabled = enabled;
          pharmacyItem.pharmacyName = pharmacyName;
        }
        return pharmacyItem;
      }).toList();
    });
  }

  void navigateToPharmacyDetails(GetPharmacyModel pharmacy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PharmacyDetailsView(
          getPharmacyModel: pharmacy,
          OnPharmacyUpdated: (bool enabled, String pharmacyName) {
            updatePharmacyEnabledStatus(pharmacy.id, enabled, pharmacyName);
          },
        ),
      ),
    );
  }

  void onPharmacyDeleted(int id) {
    setState(() {
      pharmacy = pharmacy.map((pharmacyItem) {
        if (pharmacyItem.pharmacyId == id) {
          pharmacyItem.enabled = false;
        }
        return pharmacyItem;
      }).toList();
    });
  }

  Future<void> searchPharmacys(String searchType) async {
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
    String url =
        "http://10.0.2.2:8081/admin/pharmacies/$searchType/$searchText";
    List<GetPharmacySearch> pharmacyData;

    switch (searchType) {
      case 'code':
        pharmacyData = await SearchPharmacy(Dio()).showByCode(url);
        break;
      case 'name':
        pharmacyData = await SearchPharmacy(Dio()).showByName(url);
        break;
      case 'email':
        pharmacyData = await SearchPharmacy(Dio()).showByEmail(url);
        break;
      default:
        pharmacyData = [];
    }

    setState(() {
      isLoading = false;
      pharmacy = pharmacyData;
    });

    if (pharmacyData.isEmpty) {
      print("No Pharmacy found with this $searchType");
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
          "Search Pharmacy",
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
                        await searchPharmacys('code');
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
                        await searchPharmacys('name');
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
                        await searchPharmacys('email');
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
                      : pharmacy.isEmpty && isButtonPressed && !isLoading
                          ? Center(
                              child: Text(
                                "No Pharmacy found with this $selectedButton",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          : ListView(
                              children: pharmacy.map((pharmacy) {
                                Color containerColor = pharmacy.enabled
                                    ? kPrimaryColor
                                    : const Color.fromARGB(155, 33, 149, 243);
                                return GestureDetector(
                                  onTap: () async {
                                    String url =
                                        "http://10.0.2.2:8081/admin/pharmacies/id/${pharmacy.pharmacyId}/pharmacy";
                                    List<GetPharmacyModel> pharmacyData =
                                        await SearchPharmacy(Dio())
                                            .showPharmacyById(url);
                                    print(pharmacyData);
                                    if (pharmacyData.isNotEmpty) {
                                      navigateToPharmacyDetails(
                                          pharmacyData[0]);
                                    }
                                  },
                                  child: SearchPharmacyContainer(
                                    infoContainer: InfoContainer(
                                      id: pharmacy.pharmacyId,
                                      fullName: pharmacy.pharmacyName,
                                      containerColor: containerColor,
                                      icon: Icon(Icons.delete,
                                          color: kTextColor), // Pass the icon
                                    ),
                                    getPharmacySearch: pharmacy,
                                    onPharmacyDeleted: onPharmacyDeleted,
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
