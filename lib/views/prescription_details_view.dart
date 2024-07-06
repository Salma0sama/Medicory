// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:testtt/models/general_model.dart';
// import 'package:testtt/models/medication_model.dart';
// import 'package:testtt/services/add_new_medicine_service.dart';
// import 'package:testtt/widgets/constants.dart';
// import 'package:testtt/widgets/prescription_textfield_widget.dart';

// class PrescriptionDetailsView extends StatefulWidget {
//   const PrescriptionDetailsView({super.key, required this.medication});
//   final Medication medication;
//   @override
//   State<PrescriptionDetailsView> createState() =>
//       _PrescriptionDetailsViewState();
// }

// class _PrescriptionDetailsViewState extends State<PrescriptionDetailsView> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   late Medication medication;
//   late TextEditingController medicineNameController;
//   late TextEditingController doseController;
//   late TextEditingController tipsController;
//   late TextEditingController freqController;
//   late TextEditingController sideEffectsController;
//   String? medicineName, dose, tips, sideEffects;
//   int? freq;

//   @override
//   void initState() {
//     super.initState();
//     medication = widget.medication;
//     medicineNameController = TextEditingController(text: medication.name);
//     doseController = TextEditingController(text: medication.dose);
//     tipsController = TextEditingController(text: medication.tips);
//     freqController =
//         TextEditingController(text: medication.frequency.toString());
//     sideEffectsController = TextEditingController(text: medication.sideEffects);
//   }

//   Future<void> handleSubmit() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     setState(() => isLoading = true);
//     try {
//       final addMedicineService = AddNewMedicineService();
//       final bool medicineAdded = await addMedicineService.addNewMedicine(
//           medicineName: medicineName ?? medicineNameController.text,
//           dose: dose ?? doseController.text,
//           frequency: freq ?? 1,
//           sideEffects: sideEffects ?? sideEffectsController.text,
//           tips: tipsController.text,
//           id: medication.id);
//       if (medicineAdded) {
//         print("Medicine added successfully");
//       }
//     } catch (error) {
//       print("Failed to add Medicine: $error");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "Prescription Details",
//           style: TextStyle(
//             color: kTextColor,
//           ),
//         ),
//         iconTheme: IconThemeData(color: kTextColor),
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: isLoading,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Medicine Name",
//                       controller: medicineNameController,
//                       hintText: 'Enter Medicine Name',
//                       onchange: (data) {
//                         medicineName = data;
//                       },
//                     ),
//                   ),
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Medicine Dose",
//                       controller: doseController,
//                       hintText: 'Enter Medicine Dose',
//                       onchange: (data) {
//                         dose = data;
//                       },
//                     ),
//                   ),
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Medicine Frequency",
//                       controller: freqController,
//                       hintText: 'Enter Medicine Frequency',
//                       onchange: (data) {
//                         if (data.isNotEmpty) {
//                           freq = int.parse(data);
//                         } else {
//                           freq = 1;
//                         }
//                       },
//                     ),
//                   ),
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Tips",
//                       controller: tipsController,
//                       hintText: 'Enter Tips',
//                       onchange: (data) {
//                         tips = data;
//                       },
//                     ),
//                   ),
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Side Effects *",
//                       controller: sideEffectsController,
//                       hintText: 'Enter Side Effects (optional)',
//                       onchange: (data) {
//                         sideEffects = data;
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: handleSubmit,
//                     child: Text("Add To Current Schedule"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:testtt/models/general_model.dart';
// import 'package:testtt/models/medication_model.dart';
// import 'package:testtt/services/add_new_medicine_service.dart';
// import 'package:testtt/views/record.dart';
// import 'package:testtt/widgets/button_widget.dart';
// import 'package:testtt/widgets/constants.dart';
// import 'package:testtt/widgets/prescription_textfield_widget.dart';

// class PrescriptionDetailsView extends StatefulWidget {
//   const PrescriptionDetailsView({super.key, required this.medication});
//   final Medication medication;
//   @override
//   State<PrescriptionDetailsView> createState() =>
//       _PrescriptionDetailsViewState();
// }

// class _PrescriptionDetailsViewState extends State<PrescriptionDetailsView> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   late Medication medication;
//   late TextEditingController medicineNameController;
//   late TextEditingController doseController;
//   late TextEditingController tipsController;
//   late TextEditingController freqController;
//   late TextEditingController sideEffectsController;
//   String? medicineName, dose, tips, sideEffects;
//   int? freq;
//   bool medicineAdded = false;

//   @override
//   void initState() {
//     super.initState();
//     medication = widget.medication;
//     medicineNameController = TextEditingController(text: medication.name);
//     doseController = TextEditingController(text: medication.dose);
//     tipsController = TextEditingController(text: medication.tips);
//     freqController =
//         TextEditingController(text: medication.frequency.toString());
//     sideEffectsController = TextEditingController(text: medication.sideEffects);
//     checkMedicationSchedule();
//   }

//   Future<void> checkMedicationSchedule() async {
//     setState(() => isLoading = true);
//     try {
//       final url =
//           'http://10.0.2.2:8081/owners/1CDAA42EA626493F/medication-schedule';
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = json.decode(response.body);
//         if (responseData.isNotEmpty) {
//           final medicationSchedule = responseData.firstWhere(
//             (med) => med['id'] == medication.id,
//             orElse: () => null,
//           );
//           if (medicationSchedule != null) {
//             setState(() {
//               medicineAdded = true;
//             });
//           }
//         }
//       } else {
//         print('Failed to fetch medication schedule. Error: ${response.body}');
//       }
//     } catch (error) {
//       print('Error fetching medication schedule: $error');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> handleSubmit() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     setState(() => isLoading = true);
//     try {
//       final addMedicineService = AddNewMedicineService();
//       medicineAdded = await addMedicineService.addNewMedicine(
//           medicineName: medicineName ?? medicineNameController.text,
//           dose: dose ?? doseController.text,
//           frequency: freq ?? 1,
//           sideEffects: sideEffects ?? sideEffectsController.text,
//           tips: tipsController.text,
//           id: medication.id);
//       if (medicineAdded) {
//         print("Medicine added successfully");
//       }
//     } catch (error) {
//       print("Failed to add Medicine: $error");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> handleDelete() async {
//     setState(() => isLoading = true);
//     try {
//       final url =
//           'http://10.0.2.2:8081/pharmacy/prescriptions/1CDAA42EA626493F/medications/${medication.id}';
//       final response = await http.delete(Uri.parse(url));

//       if (response.statusCode == 200) {
//         print('Medication deleted successfully');
//         setState(() {
//           medicineAdded = false; // Update UI to show it's not added anymore
//         });
//       } else {
//         print('Failed to delete medication. Error: ${response.body}');
//       }
//     } catch (error) {
//       print('Error deleting medication: $error');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "Prescription Details",
//           style: TextStyle(
//             color: kTextColor,
//           ),
//         ),
//         iconTheme: IconThemeData(color: kTextColor),
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: isLoading,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Medicine Name",
//                       controller: medicineNameController,
//                       hintText: 'Enter Medicine Name',
//                       onchange: (data) {
//                         medicineName = data;
//                       },
//                     ),
//                   ),
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Medicine Dose",
//                       controller: doseController,
//                       hintText: 'Enter Medicine Dose',
//                       onchange: (data) {
//                         dose = data;
//                       },
//                     ),
//                   ),
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Medicine Frequency",
//                       controller: freqController,
//                       hintText: 'Enter Medicine Frequency',
//                       onchange: (data) {
//                         if (data.isNotEmpty) {
//                           freq = int.parse(data);
//                         } else {
//                           freq = 1;
//                         }
//                       },
//                     ),
//                   ),
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Tips",
//                       controller: tipsController,
//                       hintText: 'Enter Tips',
//                       onchange: (data) {
//                         tips = data;
//                       },
//                     ),
//                   ),
//                   PrescriptionTextField(
//                     medicationDetails: MedicationDetails(
//                       label: "Side Effects *",
//                       controller: sideEffectsController,
//                       hintText: 'Enter Side Effects (optional)',
//                       onchange: (data) {
//                         sideEffects = data;
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   if (medicineAdded)
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Button(
//                             onPressed: () {
//                               Navigator.push(context,
//                                   MaterialPageRoute(builder: (builder) {
//                                 return RecordAudio();
//                               }));
//                             },
//                             text: 'Record Audio'),
//                         Button(
//                           onPressed: handleDelete,
//                           text: 'Delete From Schedule',
//                           color: Colors.red,
//                         ),
//                       ],
//                     )
//                   else
//                     Button(
//                       onPressed: handleSubmit,
//                       text: 'Add To Current Schedule',
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medicory/models/general_model.dart';
import 'package:medicory/models/medication_model.dart';
import 'package:medicory/services/add_new_medicine_service.dart';
import 'package:medicory/views/record.dart';
import 'package:medicory/widgets/button_widget.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:medicory/widgets/prescription_textfield_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'; // Ensure you have this package added

class PrescriptionDetailsView extends StatefulWidget {
  const PrescriptionDetailsView({super.key, required this.medication});
  final Medication medication;
  @override
  State<PrescriptionDetailsView> createState() =>
      _PrescriptionDetailsViewState();
}

class _PrescriptionDetailsViewState extends State<PrescriptionDetailsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late Medication medication;
  late TextEditingController medicineNameController;
  late TextEditingController doseController;
  late TextEditingController tipsController;
  late TextEditingController freqController;
  late TextEditingController sideEffectsController;
  String? medicineName, dose, tips, sideEffects;
  int? freq;
  bool medicineAdded = false;

  @override
  void initState() {
    super.initState();
    medication = widget.medication;
    medicineNameController = TextEditingController(text: medication.name);
    doseController = TextEditingController(text: medication.dose);
    tipsController = TextEditingController(text: medication.tips);
    freqController =
        TextEditingController(text: medication.frequency.toString());
    sideEffectsController = TextEditingController(text: medication.sideEffects);
    checkMedicationSchedule();
  }

  Future<void> checkMedicationSchedule() async {
    setState(() => isLoading = true);
    try {
      final url =
          'http://10.0.2.2:8081/owners/1CDAA42EA626493F/medication-schedule';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        if (responseData.isNotEmpty) {
          final medicationSchedule = responseData.firstWhere(
            (med) => med['id'] == medication.id,
            orElse: () => null,
          );
          if (medicationSchedule != null) {
            setState(() {
              medicineAdded = true;
            });
          }
        }
      } else {
        print('Failed to fetch medication schedule. Error: ${response.body}');
      }
    } catch (error) {
      print('Error fetching medication schedule: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);
    try {
      final addMedicineService = AddNewMedicineService();
      medicineAdded = await addMedicineService.addNewMedicine(
          medicineName: medicineName ?? medicineNameController.text,
          dose: dose ?? doseController.text,
          frequency: freq ?? int.parse(freqController.text),
          sideEffects: sideEffects ?? sideEffectsController.text,
          tips: tipsController.text,
          id: medication.id);
      if (medicineAdded) {
        _showSnackBar(
          title: 'Success',
          message: 'Medicine added successfully',
          contentType: ContentType.success,
        );
      } else {
        _showSnackBar(
          title: 'Error',
          message: 'Failed to add medicine, Try again',
          contentType: ContentType.failure,
        );
      }
    } catch (error) {
      _showSnackBar(
        title: 'Error',
        message: 'Failed to add medicine, Try again',
        contentType: ContentType.failure,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> handleDelete() async {
    setState(() => isLoading = true);
    try {
      final url =
          'http://10.0.2.2:8081/pharmacy/prescriptions/1CDAA42EA626493F/medications/${medication.id}';
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _showSnackBar(
          title: 'Success',
          message: 'Medication deleted successfully',
          contentType: ContentType.success,
        );
        setState(() {
          medicineAdded = false; // Update UI to show it's not added anymore
        });
      } else {
        _showSnackBar(
          title: 'Error',
          message: 'Failed to delete medication',
          contentType: ContentType.failure,
        );
      }
    } catch (error) {
      _showSnackBar(
        title: 'Error',
        message: 'Error deleting medication',
        contentType: ContentType.failure,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackBar({
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Prescription Details",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrescriptionTextField(
                    medicationDetails: MedicationDetails(
                      label: "Medicine Name",
                      controller: medicineNameController,
                      hintText: 'Enter Medicine Name',
                      onchange: (data) {
                        medicineName = data;
                      },
                    ),
                  ),
                  PrescriptionTextField(
                    medicationDetails: MedicationDetails(
                      label: "Medicine Dose",
                      controller: doseController,
                      hintText: 'Enter Medicine Dose',
                      onchange: (data) {
                        dose = data;
                      },
                    ),
                  ),
                  PrescriptionTextField(
                    medicationDetails: MedicationDetails(
                      label: "Medicine Frequency",
                      controller: freqController,
                      hintText: 'Enter Medicine Frequency',
                      onchange: (data) {
                        if (data.isNotEmpty) {
                          freq = int.parse(data);
                        } else {
                          freq = 1;
                        }
                      },
                    ),
                  ),
                  PrescriptionTextField(
                    medicationDetails: MedicationDetails(
                      label: "Tips",
                      controller: tipsController,
                      hintText: 'Enter Tips',
                      onchange: (data) {
                        tips = data;
                      },
                    ),
                  ),
                  PrescriptionTextField(
                    medicationDetails: MedicationDetails(
                      label: "Side Effects *",
                      controller: sideEffectsController,
                      hintText: 'Enter Side Effects (optional)',
                      onchange: (data) {
                        sideEffects = data;
                      },
                    ),
                  ),
                  // SizedBox(height: 20),
                  if (medicineAdded)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (builder) {
                                return RecordAudio();
                              }));
                            },
                            text: 'Record Audio'),
                        Button(
                          onPressed: handleDelete,
                          text: 'Delete From Schedule',
                          color: Colors.red,
                        ),
                      ],
                    )
                  else
                    Button(
                      onPressed: handleSubmit,
                      text: 'Add To Current Schedule',
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
