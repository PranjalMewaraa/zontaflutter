import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'login_screen.dart';
import './controller/registration_controller.dart';

class RegisterScreen extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        elevation: 0,
        title: const Text('Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/zonta_logo.jpg',
              width: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Already have an account? ',
                    style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: () => Get.to(const LoginScreen()),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(controller.fullNameController, 'Full Name'),
            const SizedBox(height: 20),
            _buildTextField(controller.emailController, 'Email Address'),
            const SizedBox(height: 20),
            _buildTextField(controller.passwordController, 'Password',
                isPassword: true),
            const SizedBox(height: 20),
            _buildTextField(
                controller.confirmPasswordController, 'Re-Enter Password',
                isPassword: true),
            const SizedBox(height: 20),
            _buildTextField(controller.referralCodeController, 'Referral Code'),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                    child: Obx(() => CountryCodePicker(
                          initialSelection: controller.countryCode.value,
                          favorite: const ['+1', 'US'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: true,
                          onChanged: (code) =>
                              controller.countryCode.value = code.dialCode!,
                        ))),
                const SizedBox(width: 10),
                Flexible(
                  child: _buildTextField(
                      controller.mobileNumberController, 'Mobile Number*'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Which should we use to send you a verification code?',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Obx(() => _buildVerificationOption(
                      'Mobile Phone',
                      !controller.isEmailVerification.value,
                      () => controller.isEmailVerification.value = false,
                    )),
                const SizedBox(width: 20),
                const Text('OR'),
                const SizedBox(width: 20),
                Obx(() => _buildVerificationOption(
                      'Email',
                      controller.isEmailVerification.value,
                      () => controller.isEmailVerification.value = true,
                    )),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'By clicking "Register" and creating an account you accept Zonta\'s Terms of Use and Privacy Policy.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (controller.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              }
              return Container();
            }),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: isPassword ? const Icon(Icons.visibility_off) : null,
      ),
    );
  }

  Widget _buildVerificationOption(
      String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
