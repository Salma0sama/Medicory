import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:medicory/models/prescription_model.dart';
import 'package:medicory/widgets/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

typedef void OnTestResultUpdated(bool status);

class TestResultView extends StatefulWidget {
  final GetLabTestsModel getLabTestsModel;
  final OnTestResultUpdated onTestResultUpdated;

  const TestResultView({
    Key? key,
    required this.getLabTestsModel,
    required this.onTestResultUpdated,
  }) : super(key: key);

  @override
  _TestResultViewState createState() => _TestResultViewState();
}

class _TestResultViewState extends State<TestResultView> {
  File? file;
  bool showSpinner = false;
  bool loading = false; // Track loading state
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    // Initialize SharedPreferences
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      // Load previously selected file path if available
      loadFile();
      // Load test result from the server or local storage
      loadTestResult();
    });
  }

  Future<void> loadFile() async {
    String? filePath =
        prefs.getString('test_file_path_${widget.getLabTestsModel.id}');
    if (filePath != null &&
        filePath.isNotEmpty &&
        widget.getLabTestsModel.testResult != null) {
      setState(() {
        file = File(filePath);
      });
    }
  }

  Future<void> loadTestResult() async {
    setState(() {
      showSpinner = true;
    });

    try {
      // Check if test result is saved locally
      String? localTestResult =
          prefs.getString('test_result_${widget.getLabTestsModel.id}');
      if (localTestResult != null && localTestResult.isNotEmpty) {
        setState(() {
          widget.getLabTestsModel.testResult = localTestResult;
        });
      } else {
        // Fetch test result from the server
        var uri = Uri.parse(
            'http://10.0.2.2:8081/lab/tests/result/${widget.getLabTestsModel.id}');
        var response = await http.get(uri);

        if (response.statusCode == 200) {
          var responseBody = response.body;
          setState(() {
            widget.getLabTestsModel.testResult = responseBody;
          });
          await prefs.setString(
              'test_result_${widget.getLabTestsModel.id}', responseBody);
        } else {
          print('Failed to load test result: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error loading test result: $e');
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Upload Result",
            style: TextStyle(
              color: kTextColor,
            ),
          ),
          iconTheme: IconThemeData(color: kTextColor),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.getLabTestsModel.testResult != null && file != null)
                file!.path.endsWith('.pdf')
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(180, 45),
                        ),
                        onPressed: openPDF,
                        child: Text(
                          'Open PDF File',
                          style: TextStyle(
                            fontSize: 19,
                            color: kTextColor,
                          ),
                        ),
                      )
                    : Image.file(
                        file!,
                        fit: BoxFit.cover,
                      ),
              SizedBox(height: 20), // Adding SizedBox for spacing
              if (file == null) // Updated condition for Upload File button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(180, 45),
                  ),
                  onPressed: pickFile,
                  child: Text(
                    'Upload File',
                    style: TextStyle(
                      fontSize: 19,
                      color: kTextColor,
                    ),
                  ),
                ),
              if (widget.getLabTestsModel.testResult != null && file != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(180, 45),
                  ),
                  onPressed: deleteFile,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 19,
                      color: kTextColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    widget.onTestResultUpdated(
        false); // Notify the parent widget about status change
    setState(() {
      loading = true; // Start showing loading indicator
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = File(result.files.single.path!);
      setState(() {
        file = pickedFile;
        widget.getLabTestsModel.testResult = pickedFile.path;
        saveFile(pickedFile.path); // Save file path to SharedPreferences
        uploadFile();
      });
    }

    setState(() {
      loading = false; // Stop showing loading indicator
    });
  }

  Future<void> saveFile(String filePath) async {
    await prefs.setString(
        'test_file_path_${widget.getLabTestsModel.id}', filePath);
    await prefs.setString(
        'test_result_${widget.getLabTestsModel.id}', filePath);
    // Save test result locally
  }

  Future<void> uploadFile() async {
    if (file == null) {
      return;
    }

    setState(() {
      showSpinner = true;
    });

    try {
      var uri = Uri.parse(
          'http://10.0.2.2:8081/lab/tests/result/${widget.getLabTestsModel.id}');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', file!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: 'Result uploaded successfully',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        print('File uploaded');
        // Update the local GetLabTestsModel instance
        setState(() {
          widget.getLabTestsModel.testResult = file!.path;
        });
        // Notify the parent widget about the status change
        widget.onTestResultUpdated(false);
      } else {
        String responseBody = await response.stream.bytesToString();
        print(
            "Failed to upload file ${response.statusCode} and body: $responseBody");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  Future<void> deleteFile() async {
    setState(() {
      file = null;
      widget.getLabTestsModel.testResult = null;
      widget.onTestResultUpdated(
          false); // Notify the parent widget about status change
    });

    try {
      var deleteUri = Uri.parse(
          'http://10.0.2.2:8081/lab/tests/result/${widget.getLabTestsModel.id}');
      var response = await http.delete(deleteUri);

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Success',
            message: 'Result deleted successfully',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        print('File deleted');
        await prefs.remove(
            'file_path_${widget.getLabTestsModel.id}'); // Remove stored file path
        await prefs.remove(
            'test_result_${widget.getLabTestsModel.id}'); // Remove stored test result

        // Delete file from device storage if test result is null
        if (widget.getLabTestsModel.testResult == null && file != null) {
          await file!.delete();
          print('File deleted from device storage');
        }
      } else {
        print('Failed to delete file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  void openPDF() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewer(file: file!),
      ),
    );
  }
}

class PDFViewer extends StatelessWidget {
  final File file;

  PDFViewer({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "PDF Viewer",
          style: TextStyle(
            color: kTextColor,
          ),
        ),
        iconTheme: IconThemeData(color: kTextColor),
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:testtt/models/prescription_model.dart';
// import 'package:testtt/widgets/constants.dart';

// typedef void OnTestResultUpdated(bool status);

// class TestResultView extends StatefulWidget {
//   final GetLabTestsModel getLabTestsModel;
//   final OnTestResultUpdated onTestResultUpdated;

//   const TestResultView({
//     Key? key,
//     required this.getLabTestsModel,
//     required this.onTestResultUpdated,
//   }) : super(key: key);

//   @override
//   _TestResultViewState createState() => _TestResultViewState();
// }

// class _TestResultViewState extends State<TestResultView> {
//   File? file;
//   bool showSpinner = false;
//   bool loading = false; // Track loading state
//   late SharedPreferences prefs;

//   @override
//   void initState() {
//     super.initState();
//     SharedPreferences.getInstance().then((value) {
//       prefs = value;
//       loadFile();
//       loadTestResult();
//     });
//   }

//   void loadFile() {
//     String? filePath =
//         prefs.getString('file_path_${widget.getLabTestsModel.id}');
//     if (filePath != null &&
//         filePath.isNotEmpty &&
//         widget.getLabTestsModel.testResult == null) {
//       setState(() {
//         file = File(filePath);
//       });
//     }
//   }

//   Future<void> loadTestResult() async {
//     setState(() {
//       showSpinner = true;
//     });

//     try {
//       String? localTestResult =
//           prefs.getString('test_result_${widget.getLabTestsModel.id}');
//       if (localTestResult != null && localTestResult.isNotEmpty) {
//         setState(() {
//           widget.getLabTestsModel.testResult = localTestResult;
//         });
//       } else {
//         var uri = Uri.parse(
//             'http://10.0.2.2:8081/lab/tests/result/${widget.getLabTestsModel.id}');
//         var response = await http.get(uri);

//         if (response.statusCode == 200) {
//           var responseBody = response.body;
//           setState(() {
//             widget.getLabTestsModel.testResult = responseBody;
//           });
//           await prefs.setString(
//               'test_result_${widget.getLabTestsModel.id}', responseBody);
//         } else {
//           print('Failed to load test result: ${response.statusCode}');
//         }
//       }
//     } catch (e) {
//       print('Error loading test result: $e');
//     } finally {
//       setState(() {
//         showSpinner = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: loading,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: kPrimaryColor,
//           title: Text(
//             "Upload Result",
//             style: TextStyle(
//               color: kTextColor,
//             ),
//           ),
//           iconTheme: IconThemeData(color: kTextColor),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               if (widget.getLabTestsModel.testResult != null && file != null)
//                 file!.path.endsWith('.pdf')
//                     ? ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: kPrimaryColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           minimumSize: Size(180, 45),
//                         ),
//                         onPressed: openFile,
//                         child: Text(
//                           'Open PDF File',
//                           style: TextStyle(
//                             fontSize: 19,
//                             color: kTextColor,
//                           ),
//                         ),
//                       )
//                     : Image.file(
//                         file!,
//                         fit: BoxFit.cover,
//                         width: 300,
//                         height: 300,
//                       ),
//               SizedBox(height: 20), // Adding SizedBox for spacing
//               if (file == null)
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: kPrimaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     minimumSize: Size(180, 45),
//                   ),
//                   onPressed: pickFile,
//                   child: Text(
//                     'Upload File',
//                     style: TextStyle(
//                       fontSize: 19,
//                       color: kTextColor,
//                     ),
//                   ),
//                 ),
//               if (widget.getLabTestsModel.testResult != null && file != null)
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: kPrimaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     minimumSize: Size(180, 45),
//                   ),
//                   onPressed: deleteFile,
//                   child: Text(
//                     'Delete',
//                     style: TextStyle(
//                       fontSize: 19,
//                       color: kTextColor,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> pickFile() async {
//     widget.onTestResultUpdated(
//         false); // Notify the parent widget about status change
//     setState(() {
//       loading = true; // Start showing loading indicator
//     });

//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles();
//       if (result != null && result.files.single.path != null) {
//         file = File(result.files.single.path!);
//         String filePath = file!.path;
//         await prefs.setString(
//             'file_path_${widget.getLabTestsModel.id}', filePath);

//         // Notify the parent widget that the test result has been updated
//         widget.onTestResultUpdated(true);

//         // Upload the file to the server
//         var uri = Uri.parse(
//             'http://10.0.2.2:8081/lab/tests/result/${widget.getLabTestsModel.id}');
//         var request = http.MultipartRequest('POST', uri)
//           ..files.add(await http.MultipartFile.fromPath('file', filePath));
//         var response = await request.send();

//         if (response.statusCode == 200) {
//           print('File uploaded successfully');
//         } else {
//           print('Failed to upload file: ${response.statusCode}');
//         }
//       }
//     } catch (e) {
//       print('Error picking file: $e');
//     } finally {
//       setState(() {
//         loading = false; // Stop showing loading indicator
//       });
//     }
//   }

//   Future<void> deleteFile() async {
//     widget.onTestResultUpdated(
//         false); // Notify the parent widget about status change
//     setState(() {
//       loading = true; // Start showing loading indicator
//     });

//     try {
//       // Send delete request to the server
//       var uri = Uri.parse(
//           'http://10.0.2.2:8081/lab/tests/result/${widget.getLabTestsModel.id}');
//       var response = await http.delete(uri);

//       if (response.statusCode == 200) {
//         // If delete request is successful, clear the file and test result locally
//         await prefs.remove('file_path_${widget.getLabTestsModel.id}');
//         await prefs.remove('test_result_${widget.getLabTestsModel.id}');
//         setState(() {
//           file = null;
//           widget.getLabTestsModel.testResult = null;
//         });
//       } else {
//         print('Failed to delete file: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error deleting file: $e');
//     } finally {
//       setState(() {
//         loading = false; // Stop showing loading indicator
//       });
//     }
//   }

//   void openFile() {
//     // Open the file based on its type
//     if (file!.path.endsWith('.pdf')) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PDFViewer(file: file!),
//         ),
//       );
//     } else {
//       // Handle other file types if needed
//       print('Unsupported file type');
//     }
//   }
// }

// class PDFViewer extends StatelessWidget {
//   final File file;

//   PDFViewer({required this.file});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           "PDF Viewer",
//           style: TextStyle(
//             color: kTextColor,
//           ),
//         ),
//         iconTheme: IconThemeData(color: kTextColor),
//       ),
//       body: PDFView(
//         filePath: file.path,
//       ),
//     );
//   }
// }
