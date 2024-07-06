import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/views/admin_categories_view%20copy.dart';
import 'package:medicory/views/card_owner_categories_view.dart';
import 'package:medicory/views/clinic_categories_view.dart';
import 'package:medicory/views/doctor_categories_view.dart';
import 'package:medicory/views/hospital_categories_view.dart';
import 'package:medicory/views/lab_categories_view.dart';
import 'package:medicory/views/pharmacy_categories_view.dart';
import 'package:medicory/widgets/admin_home_categories_widget.dart';
import 'package:medicory/widgets/constants.dart';

class AdminHomeView extends StatefulWidget {
  AdminHomeView({Key? key}) : super(key: key);

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  bool imagesLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImages(context);
  }

  Future<void> _loadImages(BuildContext context) async {
    await Future.wait([
      precacheImage(AssetImage("lib/images/admin.jpg"), context),
      precacheImage(AssetImage("lib/images/owner.jpg"), context),
      precacheImage(AssetImage("lib/images/doctor.jpg"), context),
      precacheImage(AssetImage("lib/images/hospital.jpg"), context),
      precacheImage(AssetImage("lib/images/clinic.jpg"), context),
      precacheImage(AssetImage("lib/images/pharmacy.jpg"), context),
      precacheImage(AssetImage("lib/images/lab.jpg"), context),
    ]);
    setState(() {
      imagesLoaded = true;
    });
  }

  final List<ImageCategories> categories = [
    ImageCategories(
        categoryName: "Admins",
        image: "lib/images/admin.jpg",
        Navigation: () => AdminCategoriesView()),
    ImageCategories(
        categoryName: "Card Owner",
        image: "lib/images/owner.jpg",
        Navigation: () => CardOwnerCategoriesView()),
    ImageCategories(
        categoryName: "Doctor",
        image: "lib/images/doctor.jpg",
        Navigation: () => DoctorCategoriesView()),
    ImageCategories(
        categoryName: "Hospital",
        image: "lib/images/hospital.jpg",
        Navigation: () => HospitalCategoriesView()),
    ImageCategories(
        categoryName: "Clinic",
        image: "lib/images/clinic.jpg",
        Navigation: () => ClinicCategoriesView()),
    ImageCategories(
        categoryName: "Pharmacy",
        image: "lib/images/pharmacy.jpg",
        Navigation: () => PharmacyCategoriesView()),
    ImageCategories(
        categoryName: "Lab",
        image: "lib/images/lab.jpg",
        Navigation: () => LabCategoriesView()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Home",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: !imagesLoaded
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: AdminHomeCategories(
                              categories: categories[index]),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
    );
  }
}
