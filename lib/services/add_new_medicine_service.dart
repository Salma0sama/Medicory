import 'dart:convert';
import 'package:http/http.dart' as http;

class AddNewMedicineService {
  Future<bool> addNewMedicine({
    required String medicineName,
    required String dose,
    required int frequency,
    required String sideEffects,
    required String tips,
    required int id,
  }) async {
    final Map<String, dynamic> medicineData = {
      "medicineName": medicineName,
      "dose": dose,
      "frequency": frequency,
      "sideEffects": sideEffects,
      "tips": tips,
      "id": id,
    };

    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2:8081/pharmacy/prescriptions/1CDAA42EA626493F/medications"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(medicineData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "Failed to add Medicine ${response.statusCode} and body: ${response.body}");
    }
  }
}
