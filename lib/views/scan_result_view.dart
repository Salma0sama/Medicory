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

typedef void OnScanResultUpdated(bool status);

class ScanResultView extends StatefulWidget {
  final GetLabScanModel getLabScansModel;
  final OnScanResultUpdated onScanResultUpdated;

  const ScanResultView({
    Key? key,
    required this.getLabScansModel,
    required this.onScanResultUpdated,
  }) : super(key: key);

  @override
  _ScanResultViewState createState() => _ScanResultViewState();
}

class _ScanResultViewState extends State<ScanResultView> {
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
      loadScanResult();
    });
  }

  Future<void> loadFile() async {
    String? filePath =
        prefs.getString('scan_file_path_${widget.getLabScansModel.id}');
    if (filePath != null &&
        filePath.isNotEmpty &&
        widget.getLabScansModel.imageResult != null) {
      setState(() {
        file = File(filePath);
      });
    }
  }

  Future<void> loadScanResult() async {
    setState(() {
      showSpinner = true;
    });

    try {
      // Check if test result is saved locally
      String? localScanResult =
          prefs.getString('scan_result_${widget.getLabScansModel.id}');
      if (localScanResult != null && localScanResult.isNotEmpty) {
        setState(() {
          widget.getLabScansModel.imageResult = localScanResult;
        });
      } else {
        // Fetch test result from the server
        var uri = Uri.parse(
            'http://10.0.2.2:8081/lab/imagingTests/result/${widget.getLabScansModel.id}');
        var response = await http.get(uri);

        if (response.statusCode == 200) {
          var responseBody = response.body;
          setState(() {
            widget.getLabScansModel.imageResult = responseBody;
          });
          await prefs.setString(
              'Scan_result_${widget.getLabScansModel.id}', responseBody);
        } else {
          print('Failed to load scan result: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error loading scan result: $e');
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
              if (widget.getLabScansModel.imageResult != null && file != null)
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
                          'Open File',
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
                    'Upload Result',
                    style: TextStyle(
                      fontSize: 19,
                      color: kTextColor,
                    ),
                  ),
                ),
              if (widget.getLabScansModel.imageResult != null && file != null)
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
                    'Delete Result',
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
    widget.onScanResultUpdated(
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
        widget.getLabScansModel.imageResult = pickedFile.path;
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
        'scan_file_path_${widget.getLabScansModel.id}', filePath);
    await prefs.setString(
        'scan_result_${widget.getLabScansModel.id}', filePath);
    // Save scan result locally
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
          'http://10.0.2.2:8081/lab/imagingTests/result/${widget.getLabScansModel.id}');
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
          widget.getLabScansModel.imageResult = file!.path;
        });
        // Notify the parent widget about the status change
        widget.onScanResultUpdated(false);
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
      widget.getLabScansModel.imageResult = null;
      widget.onScanResultUpdated(
          false); // Notify the parent widget about status change
    });

    try {
      var deleteUri = Uri.parse(
          'http://10.0.2.2:8081/lab/imagingTests/result/${widget.getLabScansModel.id}');
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
            'file_path_${widget.getLabScansModel.id}'); // Remove stored file path
        await prefs.remove(
            'scan_result_${widget.getLabScansModel.id}'); // Remove stored test result

        // Delete file from device storage if test result is null
        if (widget.getLabScansModel.imageResult == null && file != null) {
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
