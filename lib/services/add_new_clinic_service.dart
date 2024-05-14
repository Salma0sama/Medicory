import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicory/models/add_new_clinic_model.dart';

class AddNewClinicService {
  Future<AddNewClinicModel> addNewClinic({
    required String name,
    required String googleMapsLink,
    required String address,
    required String ownerName,
    required String specialization,
    required String email,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> clinicData = {
      "name": name,
      "googleMapsLink": googleMapsLink,
      "address": address,
      "ownerName": ownerName,
      "specialization": specialization,
      "email": email,
      "role": role,
      "userPhoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8081/admin/clinics/clinic"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(clinicData),
    );

    if (response.statusCode == 201) {
      return AddNewClinicModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add clinic");
    }
  }
}