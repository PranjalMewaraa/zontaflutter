import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GlassServiceController extends GetxController {
  // Observable for API response
  var serviceList = [].obs;
  var isLoading = true.obs;

  final String apiUrl = "http://147.182.135.77/api/customer/array-status";

  Future<void> fetchGlassServiceList() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve user_id and access_token
      int? userId = prefs.getInt('user_id');
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        Get.snackbar("Error", "User not logged in or credentials missing");
        return;
      }

      // Prepare request body
      var body = {
        "user_id": userId.toString(),
        "access_token": accessToken,
        "status": false
      };

      // Make the POST request
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print(responseData);
        serviceList.value = responseData['data'] ?? [];
      } else {
        Get.snackbar("Error", "Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}
