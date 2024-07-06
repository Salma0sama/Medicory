import 'dart:convert';
import 'package:http/http.dart' as http;

class EditDoctorService {
  Future<bool> EditDoctor({
    required int id,
    required String firstName,
    required String middleName,
    required String lastName,
    required String specialization,
    required String licenceNumber,
    required String nationalId,
    required String maritalStatus,
    required String gender,
    required String code,
    required String email,
    required String? password,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> doctorData = {
      "id": id,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "gender": gender,
      "specialization": specialization,
      "licenceNumber": licenceNumber,
      "nationalId": nationalId,
      "maritalStatus": maritalStatus,
      "code": code,
      "email": email,
      "password": password,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.put(
      Uri.parse("http://10.0.2.2:8081/admin/doctors/id/$id/doctor"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(doctorData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "Failed to edit Doctor ${response.statusCode} with ${response.body}");
    }
  }
}
