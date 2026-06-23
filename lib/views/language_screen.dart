import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'en'; // 'en' or 'ar'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // App Logo
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              // Heading
              Text(
                'Choose Your Language',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E3A59),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'اختر لغتك المفضلة',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF2E3A59).withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),

              // English Option Card
              GestureDetector(
                onTap: () => setState(() => _selectedLanguage = 'en'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: _selectedLanguage == 'en'
                        ? const Color(0xFF4DB6AC).withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: _selectedLanguage == 'en'
                          ? const Color(0xFF4DB6AC)
                          : Colors.grey.shade200,
                      width: _selectedLanguage == 'en' ? 2.0 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'English',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Use the app in English',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (_selectedLanguage == 'en')
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF4DB6AC),
                          size: 28.0,
                        )
                      else
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Arabic Option Card
              GestureDetector(
                onTap: () => setState(() => _selectedLanguage = 'ar'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: _selectedLanguage == 'ar'
                        ? const Color(0xFF4DB6AC).withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: _selectedLanguage == 'ar'
                          ? const Color(0xFF4DB6AC)
                          : Colors.grey.shade200,
                      width: _selectedLanguage == 'ar' ? 2.0 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'العربية',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E3A59),
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'استخدم التطبيق باللغة العربية',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (_selectedLanguage == 'ar')
                        const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF4DB6AC),
                          size: 28.0,
                        )
                      else
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 2.0),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _selectedLanguage == 'en' ? 'Continue' : 'استمرار',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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
