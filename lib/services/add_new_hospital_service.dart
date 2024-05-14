import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicory/models/add_new_hospital_model.dart';

class AddNewHospitalService {
  Future<AddNewHospitalModel> addNewHospital({
    required String name,
    required String googleMapsLink,
    required String address,
    required String email,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> hospitalData = {
      "name": name,
      "googleMapsLink": googleMapsLink,
      "address": address,
      "email": email,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8081/admin/hosbitals/hospital"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(hospitalData),
    );

    if (response.statusCode == 201) {
      return AddNewHospitalModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add Hospital");
    }
  }
}
