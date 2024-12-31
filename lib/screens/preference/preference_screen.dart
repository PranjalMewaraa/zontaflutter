import 'package:flutter/material.dart';
import 'package:zonta/auth/auth_screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  // Set the default language and currency
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preference',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _LanguageButton(
                    text: 'English',
                    isSelected: _selectedLanguage == 'English',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'English';
                      });
                    },
                  ),
                  _LanguageButton(
                    text: 'عربي',
                    isSelected: _selectedLanguage == 'عربي',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'عربي';
                      });
                    },
                  ),
                  _LanguageButton(
                    text: 'Français',
                    isSelected: _selectedLanguage == 'Français',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'Français';
                      });
                    },
                  ),
                  _LanguageButton(
                    text: 'Española',
                    isSelected: _selectedLanguage == 'Española',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'Española';
                      });
                    },
                  ),
                  _LanguageButton(
                    text: 'kiswahili',
                    isSelected: _selectedLanguage == 'kiswahili',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'kiswahili';
                      });
                    },
                  ),
                  _LanguageButton(
                    text: 'አማርኛ',
                    isSelected: _selectedLanguage == 'አማርኛ',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'አማርኛ';
                      });
                    },
                  ),
                  _LanguageButton(
                    text: 'Zulu',
                    isSelected: _selectedLanguage == 'Zulu',
                    onTap: () {
                      setState(() {
                        _selectedLanguage = 'Zulu';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Select Currency',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _CurrencyButton(
                    text: 'USD \$',
                    isSelected: _selectedCurrency == 'USD',
                    onTap: () {
                      setState(() {
                        _selectedCurrency = 'USD';
                      });
                    },
                  ),
                  _CurrencyButton(
                    text: 'ETB Br',
                    isSelected: _selectedCurrency == 'ETB',
                    onTap: () {
                      setState(() {
                        _selectedCurrency = 'ETB';
                      });
                    },
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'You can change settings later from preference',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.text,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _CurrencyButton extends _LanguageButton {
  const _CurrencyButton({
    required String text,
    bool isSelected = false,
    required VoidCallback onTap,
  }) : super(text: text, isSelected: isSelected, onTap: onTap);
}
