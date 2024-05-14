import 'dart:convert';
import 'package:medicory/models/add_new_admin_model.dart';
import 'package:http/http.dart' as http;

class AddNewAdminService {
  Future<AddNewAdminModel> addNewAdmin({
    required String firstName,
    required String lastName,
    required String maritalStatus,
    required String gender,
    required String email,
    required String role,
    required List<String> userPhoneNumbers,
    required bool enabled,
  }) async {
    final Map<String, dynamic> adminData = {
      "firstName": firstName,
      "lastName": lastName,
      "maritalStatus": maritalStatus,
      "gender": gender,
      "email": email,
      "role": role,
      "phoneNumbers": userPhoneNumbers,
      "enabled": enabled,
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8081/admin/admins"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(adminData),
    );

    if (response.statusCode == 201) {
      return AddNewAdminModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to add Admin ${response.statusCode} and body: ${response.body}");
    }
  }
}
