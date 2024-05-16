import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/get_pharmacy_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:medicory/services/search_pharmacy_service.dart';
import 'package:medicory/views/show_pharmacy_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/search_container_widget.dart';
import 'package:medicory/widgets/search_with_selector_view.dart';

class SearchPharmacyView extends StatefulWidget {
  const SearchPharmacyView({super.key});

  @override
  State<SearchPharmacyView> createState() => _SearchPharmacyViewState();
}

class _SearchPharmacyViewState extends State<SearchPharmacyView> {
  String? searchWith;
  String searchText = "";
  int? pharmacyId;
  String? pharmacyName;
  List<GetPharmacySearch> pharmacy = [];

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SearchWithSelector(
              labelText: "Search With :",
              options: ["Code", "Name", "E-mail"],
              selectedValue: searchWith,
              onChanged: (value) {
                setState(() {
                  searchWith = value;
                  searchText = ""; // Clear text field for Code search
                  pharmacyId = null; // Clear previous owner ID
                  pharmacyName = null; // Clear previous owner full name
                });
              },
            ),
            if (searchWith != null) // Only render if search option is selected
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: kPrimaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    labelText: searchWith == "Code"
                        ? "Search Code"
                        : searchWith == "Name"
                            ? "Search Name"
                            : searchWith == "E-mail"
                                ? "Search E-mail"
                                : "Search",
                    hintText: searchWith == "Code"
                        ? "Enter Code"
                        : searchWith == "Name"
                            ? "Enter name"
                            : searchWith == "E-mail"
                                ? "Enter E-mail"
                                : "Please select a search option.",
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                ),
              ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(120, 40),
              ),
              onPressed: () async {
                if (searchWith != null) {
                  if (searchWith == "Code" && searchText.isNotEmpty) {
                    print("Searching by code $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/pharmacies/code/$searchText";
                    List<GetPharmacySearch> pharmacyData =
                        await SearchPharmacy(Dio()).showByCode(url);
                    if (pharmacyData.isNotEmpty) {
                      setState(() {
                        pharmacy = pharmacyData;
                      });
                    } else {
                      print("No pharmacy found with this code");
                    }
                  } else if (searchWith == "Name" && searchText.isNotEmpty) {
                    print("Searching by name $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/pharmacies/name/$searchText";
                    List<GetPharmacySearch> pharmacyData =
                        await SearchPharmacy(Dio()).showByName(url);
                    setState(() {
                      pharmacy = pharmacyData;
                    });
                  } else if (searchWith == "E-mail" && searchText.isNotEmpty) {
                    print("Searching by email $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/pharmacies/email/$searchText";
                    List<GetPharmacySearch> pharmacyData =
                        await SearchPharmacy(Dio()).showByEmail(url);
                    if (pharmacyData.isNotEmpty) {
                      setState(() {
                        pharmacy = pharmacyData;
                      });
                    } else {
                      print("No pharmacy found with this email");
                    }
                  } else {
                    print("Please enter a valid search term.");
                  }
                } else {
                  print("Please select a search option.");
                }
              },
              child: Text(
                "Search",
                style: TextStyle(
                  fontSize: 19,
                  color: kTextColor,
                ),
              ),
            ),
            SizedBox(height: 15),
            Column(
              children: pharmacy.map((pharmacy) {
                Color containerColor = pharmacy.enabled
                    ? kPrimaryColor
                    : const Color.fromARGB(155, 33, 149, 243);
                return GestureDetector(
                  onTap: () async {
                    String url =
                        "http://10.0.2.2:8081/admin/pharmacies/id/${pharmacy.pharmacyId}/pharmacy";
                    List<GetPharmacyModel> pharmacyData =
                        await SearchPharmacy(Dio()).showPharmacyById(url);
                    print(pharmacyData);
                    if (pharmacyData.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowPharmacyView(
                                  getPharmacyModel: pharmacyData[0],
                                )),
                      );
                    }
                  },
                  child: SearchContainer(
                    id: pharmacy.pharmacyId,
                    fullName: pharmacy.pharmacyName,
                    containerColor: containerColor,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
