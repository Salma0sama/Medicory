import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/get_owner_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:medicory/services/search_owner_service.dart';
import 'package:medicory/views/show_owner_view.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/search_container_widget.dart';
import 'package:medicory/widgets/search_with_selector_view.dart';

class SearchOwnerView extends StatefulWidget {
  const SearchOwnerView({Key? key}) : super(key: key);

  @override
  State<SearchOwnerView> createState() => _SearchState();
}

class _SearchState extends State<SearchOwnerView> {
  String? searchWith;
  String searchText = "";
  int? ownerId;
  String? ownerFullName;
  List<GetOwnerSearch> owners = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Search Owner",
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
                  ownerId = null; // Clear previous owner ID
                  ownerFullName = null; // Clear previous owner full name
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
                        "http://10.0.2.2:8081/admin/owners/code/$searchText";
                    List<GetOwnerSearch> ownerData =
                        await SearchOwner(Dio()).showByCode(url);
                    if (ownerData.isNotEmpty) {
                      setState(() {
                        owners = ownerData;
                      });
                    } else {
                      print("No owner found with this code");
                    }
                  } else if (searchWith == "Name" && searchText.isNotEmpty) {
                    print("Searching by name $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/owners/name/$searchText";
                    List<GetOwnerSearch> ownerData =
                        await SearchOwner(Dio()).showByName(url);
                    setState(() {
                      owners = ownerData;
                    });
                  } else if (searchWith == "E-mail" && searchText.isNotEmpty) {
                    print("Searching by email $searchText");
                    String url =
                        "http://10.0.2.2:8081/admin/owners/email/$searchText";
                    List<GetOwnerSearch> ownerData =
                        await SearchOwner(Dio()).showByEmail(url);
                    if (ownerData.isNotEmpty) {
                      setState(() {
                        owners = ownerData;
                      });
                    } else {
                      print("No owner found with this email");
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
              children: owners.map((owner) {
                Color containerColor = owner.isEnabled
                    ? kPrimaryColor
                    : const Color.fromARGB(155, 33, 149, 243);
                return GestureDetector(
                  onTap: () async {
                    String url =
                        "http://10.0.2.2:8081/admin/owners/id/${owner.id}";
                    List<GetOwnerModel> ownerData =
                        await SearchOwner(Dio()).showOwnerById(url);
                    if (ownerData.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowOwnerView(
                                getOwnerModel: ownerData[0],
                                relativePhoneNumber:
                                    ownerData[0].relativePhoneNumbers[0],
                                userDetail: ownerData[0].user,
                                userPhoneNumber:
                                    ownerData[0].user.userPhoneNumbers[0])),
                      );
                    }
                  },
                  child: SearchContainer(
                    id: owner.id,
                    fullName: owner.fullName,
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
