import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/search_model.dart';
import 'package:http/http.dart' as http;
import 'package:medicory/widgets/constants.dart';

class SearchPharmacyContainer extends StatefulWidget {
  const SearchPharmacyContainer({
    Key? key,
    required this.infoContainer,
    required this.getPharmacySearch,
    required this.onPharmacyDeleted,
  }) : super(key: key);

  final InfoContainer infoContainer;
  final GetPharmacySearch getPharmacySearch;
  final Function(int id) onPharmacyDeleted;

  @override
  State<SearchPharmacyContainer> createState() =>
      _SearchPharmacyContainerState();
}

class _SearchPharmacyContainerState extends State<SearchPharmacyContainer> {
  bool _isDialogOpen = false;

  Future<void> deletePharmacy() async {
    final response = await http.delete(
      Uri.parse(
          "http://10.0.2.2:8081/admin/pharmacies/id/${widget.getPharmacySearch.pharmacyId}"),
    );

    if (response.statusCode == 200) {
      print("SUCCESS");
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: 'Pharmacy Deleted successfully',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      widget.onPharmacyDeleted(widget.getPharmacySearch.pharmacyId);
    } else {
      print("FAILED");
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: 'Failed to Delete Pharmacy',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          color: widget.infoContainer.containerColor,
        ),
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${widget.infoContainer.id}',
                style: TextStyle(
                  fontSize: 19,
                  color: kTextColor,
                ),
              ),
              VerticalDivider(
                color: Colors.white,
                thickness: 1.2,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.infoContainer.fullName,
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 1),
              if (widget.getPharmacySearch.enabled) // Check if admin is enabled
                GestureDetector(
                  onTap: () {
                    if (!_isDialogOpen) {
                      setState(() {
                        _isDialogOpen = true;
                      });

                      AwesomeDialog(
                        context: context,
                        animType: AnimType.topSlide,
                        dialogType: DialogType.question,
                        title: 'Warning',
                        desc: 'Are You Sure You Want To Delete Pharmacy?',
                        btnOkOnPress: () async {
                          setState(() {
                            _isDialogOpen = false;
                          });
                          await deletePharmacy();
                        },
                        btnCancelOnPress: () {
                          setState(() {});
                        },
                        dismissOnTouchOutside:
                            false, // Prevents dismissal on outside touch
                        dismissOnBackKeyPress:
                            false, // Prevents dismissal on back button
                      ).show();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: widget.infoContainer.icon, // Display icon here
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
