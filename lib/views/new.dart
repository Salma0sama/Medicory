import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';

class New extends StatefulWidget {
  const New({Key? key});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Open file picker to select file
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              File file = File(result.files.single.path!);

              // Replace "http://10.0.2.2:8081/lab/tests/result/1" with your actual upload URL
              String uploadUrl = "http://10.0.2.2:8081/lab/tests/result/1";

              // Upload file using Dio
              await uploadFileDio(uploadUrl, file);
            } else {
              // User canceled the file picker
            }
          },
          child: Text("UPLOAD"),
        ),
      ),
    );
  }

  Future<void> uploadFileDio(String url, File file) async {
    try {
      // Read the file content as a byte array
      List<int> fileBytes = await file.readAsBytes();

      // Encode the byte array to a base64 string
      String fileContent = base64Encode(fileBytes);

      // Create the request body
      Map<String, dynamic> requestBody = {
        'file': fileContent,
      };

      // Send the POST request using Dio
      Dio dio = Dio();
      var response = await dio.post(url, data: requestBody);

      if (response.statusCode == 200) {
        print("File uploaded successfully");
      } else {
        print("Failed to upload file");
        // Handle error
      }
    } catch (e) {
      print("Error uploading file: $e");
      // Handle error
    }
  }
}
