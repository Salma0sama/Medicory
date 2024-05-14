import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/views/add_owner_view.dart';
import 'package:medicory/views/search_owner_view.dart';
import 'package:medicory/widgets/categories_details_widget.dart';
import 'package:medicory/widgets/constants.dart';

class CardOwnerCategoriesView extends StatelessWidget {
  CardOwnerCategoriesView({super.key});
  final List<ButtonDetails> categories = [
    ButtonDetails(Navigation: () => SearchOwnerView(), Text: "Show Owner"),
    ButtonDetails(Navigation: () => AddOwnerView(), Text: "Add Owner"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Card Owners",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var category in categories) Categories(categories: category),
          ],
        ),
      ),
    );
  }
}
