import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicory/models/add_new_doctor_model.dart';

class AddNewDoctorService {
  Future<AddNewDoctorModel> addNewDoctor({
    required String firstName,
    required String middleName,
    required String lastName,
    required String specialization,
    required String licenceNumber,
    // required int nationalId,
    required String nationalId,
    required String maritalStatus,
    required String gender,
    required String email,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> doctorData = {
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "specialization": specialization,
      "licenceNumber": licenceNumber,
      "nationalId": nationalId,
      "maritalStatus": maritalStatus,
      "gender": gender,
      "email": email,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8081/admin/doctors/doctor"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(doctorData),
    );

    if (response.statusCode == 201) {
      return AddNewDoctorModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add doctor");
    }
  }
}
