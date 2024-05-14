import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medicory/models/add_new_owner_model.dart';

class AddNewOwnerService {
  Future<AddNewOwnerModel> addNewOwner({
    required String firstName,
    required String middleName,
    required String lastName,
    required String gender,
    required String dateOfBirth,
    required String address,
    required String bloodType,
    required int nationalId,
    required String maritalStatus,
    required String job,
    required List<RelativePhoneNumber> relativePhoneNumbers,
    required UserDetail user,
  }) async {
    final Map<String, dynamic> ownerData = {
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "address": address,
      "bloodType": bloodType,
      "nationalId": nationalId,
      "maritalStatus": maritalStatus,
      "job": job,
      "relativePhoneNumbers":
          relativePhoneNumbers.map((r) => r.toJson()).toList(),
      "user": user.toJson(),
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8081/admin/owners/owner"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(ownerData),
    );

    if (response.statusCode == 201) {
      return AddNewOwnerModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add owner");
    }
  }
}
