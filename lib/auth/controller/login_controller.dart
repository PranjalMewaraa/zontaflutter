import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:zonta/screens/dashboard/dashboard_screen.dart'; // For Platform.isAndroid, Platform.isIOS

class LoginController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var loginType =
      ''.obs; // This will hold the dynamic login type (e.g., 'apple', 'google')
  final int loginDeviceFlutterAndroid = 3;
  final int loginDeviceFlutterIos = 4;
  final loginTypeFacebook = "facebook";
  final loginTypeGoogle = "google";
  final loginTypeEmail = "email";
  final loginTypeApple = "apple";

  // Dynamically set login type based on user choice
  void setLoginType(String type) {
    loginType.value = type; // e.g., 'apple', 'google', etc.
  }

  // Login method to make the API call
  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;

    final url = Uri.parse("http://147.182.135.77/api/customer/login");
    int deviceType =
        Platform.isAndroid ? loginDeviceFlutterAndroid : loginDeviceFlutterIos;
    // Build the request body
    final body = {
      "login_type": loginTypeEmail,
      "device_token": "voluptates", // Replace with actual device token
      "select_language": "consectetur", // Language selection
      "select_currency": "nisi", // Currency selection
      "email": emailController.text,
      "password": passwordController.text,
      "login_device": deviceType,
      "select_country_code": "+251"
    };

    try {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: json.encode(body));

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        if (jsonResponse['status'] == 0) {
          Get.snackbar('Error', jsonResponse['message'],
              snackPosition: SnackPosition.TOP);
        } else {
          // Successfully logged in. Save data to local storage
          await _saveUserData(jsonResponse);
          print(jsonResponse);
          // Proceed to the dashboard or next screen
          Get.to(() => const DashboardScreen());
        }
      } else {
        Get.snackbar('Error', 'Server error. Please try again later.',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  // Method to save user data to local storage
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the user data
    await prefs.setInt('user_id', userData['user_id']);
    await prefs.setString('access_token', userData['access_token']);
    await prefs.setString('user_name', userData['user_name']);
  }

  // Optional: Method to retrieve user data from local storage
  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt('user_id');
    String? accessToken = prefs.getString('access_token');
    String? userName = prefs.getString('user_name');

    if (userId != null && accessToken != null && userName != null) {
      return {
        'user_id': userId,
        'access_token': accessToken,
        'user_name': userName
      };
    } else {
      return {};
    }
  }
}
