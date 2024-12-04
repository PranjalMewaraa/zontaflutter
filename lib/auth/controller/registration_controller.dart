import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:zonta/auth/login_screen.dart'; // Import to use Platform class

class RegistrationController extends GetxController {
  var isEmailVerification = true.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralCodeController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final countryCode = "+1".obs; // Default country code

  // Define the login device constants
  final int loginDeviceFlutterAndroid = 3;
  final int loginDeviceFlutterIos = 4;

  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;

    // Determine the device type based on the platform (Android or iOS)
    int deviceType =
        Platform.isAndroid ? loginDeviceFlutterAndroid : loginDeviceFlutterIos;

    final body = {
      "email": emailController.text,
      "password": passwordController.text,
      "full_name": fullNameController.text,
      "contact_number": mobileNumberController.text,
      "device_token":
          "example_device_token", // Replace with actual device token
      "select_language": "en",
      "select_country_code": countryCode.value,
      "select_currency": "USD",
      "login_device": deviceType, // Ensure this is an integer
    };

    try {
      final response = await http
          .post(
        Uri.parse("http://147.182.135.77/api/customer/register"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode(body),
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        // Handle timeout
        throw TimeoutException('The connection has timed out');
      });

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        if (jsonResponse['status'] == 0) {
          // Show error message if registration failed
          Get.snackbar('Error', jsonResponse['message'],
              snackPosition: SnackPosition.TOP);
        } else {
          // Show success message and navigate to login page
          Get.snackbar('Success', 'Registration successful!',
              snackPosition: SnackPosition.TOP);

          // Redirect to Login widget
          Get.to(() => const LoginScreen());
        }
      } else {
        Get.snackbar('Error', 'Server error. Please try again later.',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      print("Error occurred: $e");
      if (e is TimeoutException) {
        Get.snackbar(
            'Error', 'Request timed out. Please check your connection.',
            snackPosition: SnackPosition.TOP);
      } else {
        Get.snackbar('Error', 'Something went wrong: $e',
            snackPosition: SnackPosition.TOP);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
