// screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_project/controller%20.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController _pageController = PageController();
  final int _numPages = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 71, 161, 145),
              Color.fromARGB(255, 68, 230, 221),
              // Color.fromARGB(255, 124, 238, 215),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: const [
                    OnboardingPage(
                      image:
                          'https://cdn.pixabay.com/photo/2016/11/15/06/44/doctor-1825417_1280.png',
                      title: 'Your Health, Our Priority',
                      description:
                          'Access quality healthcare from the comfort of your home with our comprehensive medical app.',
                    ),
                    OnboardingPage(
                      image:
                          'https://cdn.pixabay.com/photo/2025/02/16/11/39/ai-generated-9410660_960_720.png',
                      title: 'Connect with Experts',
                      description:
                          'Schedule appointments, get consultations, and receive personalized care from certified medical professionals.',
                    ),
                    OnboardingPage(
                      image:
                          'https://cdn.pixabay.com/photo/2016/03/31/19/15/doctor-1294848_1280.png',
                      title: 'Manage Health Records',
                      description:
                          'Keep all your medical history, prescriptions, and test results organized in one secure place.',
                    ),
                    OnboardingPage(
                      image:
                          'https://cdn.pixabay.com/photo/2012/04/10/17/40/vitamins-26622_960_720.png',
                      title: 'Never Miss a Dose',
                      description:
                          'Set reminders for medications, appointments, and follow-ups to stay on top of your health.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip button
                    TextButton(
                      onPressed: () => Get.toNamed('/login'),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    // Page indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _numPages,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Colors.white,
                        dotColor: Colors.white54,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 4,
                      ),
                    ),

                    // Next/Get Started button
                    ElevatedButton(
                      onPressed: () {
                        if (_pageController.page!.round() < _numPages - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        } else {
                          Get.toNamed('/login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image with shadow
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Image.network(
              image,
              height: 120,
              width: 120,
              color: const Color(0xFF0093E9),
            ),
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LoginScreenN extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  // Observable for password visibility
  final RxBool isPasswordVisible = false.obs;

  LoginScreenN({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome text with improved styling
              Text('Welcome back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      fontSize: 32)),
              const SizedBox(height: 12),
              Text('Sign in to continue your journey',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey[600])),
              const SizedBox(height: 40),

              /// FORM
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// Email Field with enhanced styling
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon:
                            Icon(Icons.email_outlined, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        floatingLabelStyle: const TextStyle(color: Colors.teal),
                      ),
                      validator: authController.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    /// Password Field with Toggle and enhanced styling
                    Obx(() => TextFormField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible.value,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.lock_outline_rounded,
                                color: Colors.grey[600]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: () => isPasswordVisible.value =
                                  !isPasswordVisible.value,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            floatingLabelStyle:
                                const TextStyle(color: Colors.teal),
                          ),
                          validator: authController.validatePassword,
                        )),
                    const SizedBox(height: 16),

                    /// Forgot Password with improved styling
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed('/forget-password'),
                        child: Text('Forgot Password?',
                            style: TextStyle(
                                color: Colors.teal[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Error & Loading with improved styling
                    Obx(() {
                      if (authController.isLoading.value) {
                        return Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                              strokeWidth: 2.5,
                            ),
                            const SizedBox(height: 12),
                            Text('Signing in...',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14)),
                          ],
                        );
                      }

                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red[700], size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  authController.errorMessage.value,
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                        height: authController.errorMessage.value.isNotEmpty
                            ? 16
                            : 0),

                    /// Sign In Button with improved styling
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.login(
                                emailController.text, passwordController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          shadowColor: Colors.teal.withOpacity(0.4),
                        ),
                        child: const Text('Sign In',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// OR Divider with improved styling
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500)),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    /// Create Account with improved styling
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Get.toNamed('/register'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.teal,
                          side:
                              const BorderSide(color: Colors.teal, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Create New Account',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// screens/register_screen.dart
class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  // Observable variables
  final RxString selectedGender = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  RegisterScreen({super.key});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      birthdayController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome text with improved styling
              Text('Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      fontSize: 32)),
              const SizedBox(height: 12),
              Text('Join us to get started',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey[600])),
              const SizedBox(height: 40),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// Name Field
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon:
                            Icon(Icons.person_outline, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        floatingLabelStyle: const TextStyle(color: Colors.teal),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// Email Field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon:
                            Icon(Icons.email_outlined, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        floatingLabelStyle: const TextStyle(color: Colors.teal),
                      ),
                      validator: authController.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    /// Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.lock_outline_rounded,
                            color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        floatingLabelStyle: const TextStyle(color: Colors.teal),
                        helperText: 'Must be at least 8 characters',
                        helperStyle:
                            TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      validator: authController.validatePassword,
                    ),
                    const SizedBox(height: 20),

                    /// Phone Field
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon:
                            Icon(Icons.phone_outlined, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        floatingLabelStyle: const TextStyle(color: Colors.teal),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        // Simple phone validation
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// Birthday Field with Date Picker
                    TextFormField(
                      controller: birthdayController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Birthday',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon:
                            Icon(Icons.cake_outlined, color: Colors.grey[600]),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today,
                              color: Colors.grey[600]),
                          onPressed: () => _selectDate(context),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        floatingLabelStyle: const TextStyle(color: Colors.teal),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your birthday';
                        }
                        return null;
                      },
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 20),

                    /// Gender Dropdown
                    Obx(() => InputDecorator(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline,
                                color: Colors.grey[600]),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedGender.value.isEmpty
                                  ? null
                                  : selectedGender.value,
                              isDense: true,
                              isExpanded: true,
                              hint: Text('Select your gender',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600])),
                              items: <String>['male', 'female']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                selectedGender.value = newValue!;
                              },
                            ),
                          ),
                        )),
                    const SizedBox(height: 32),

                    /// Error & Loading with improved styling
                    Obx(() {
                      if (authController.isLoading.value) {
                        return Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                              strokeWidth: 2.5,
                            ),
                            const SizedBox(height: 12),
                            Text('Creating account...',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14)),
                          ],
                        );
                      }

                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red[700], size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  authController.errorMessage.value,
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                        height: authController.errorMessage.value.isNotEmpty
                            ? 16
                            : 0),

                    /// Create Account Button with improved styling
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate gender selection
                          if (selectedGender.value.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please select your gender',
                              backgroundColor: Colors.red[50],
                              colorText: Colors.red[700],
                            );
                            return;
                          }

                          if (_formKey.currentState!.validate()) {
                            authController.register(
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                                phoneController.text,
                                birthdayController.text,
                                selectedGender.value);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          shadowColor: Colors.teal.withOpacity(0.4),
                        ),
                        child: const Text('Create Account',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// OR Divider with improved styling
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500)),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    /// Sign In button with improved styling
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.teal,
                          side:
                              const BorderSide(color: Colors.teal, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Already have an account? Sign In',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// screens/verify_email_screen.dart
class VerifyEmailScreen extends StatelessWidget {
  final String email = Get.arguments['email'];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button with improved styling
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87, size: 20),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 30),

              // Header with icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.email_outlined,
                      color: Colors.teal, size: 40),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Center(
                child: Text('Verify Your Email',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontSize: 28)),
              ),
              const SizedBox(height: 12),

              // Description with email
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Enter the code sent to\n',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    children: [
                      TextSpan(
                        text: email,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.teal[700],
                            fontSize: 16),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // OTP Field with enhanced styling
                    TextFormField(
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: 'Verification Code',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon:
                            Icon(Icons.sms_outlined, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        floatingLabelStyle: const TextStyle(color: Colors.teal),
                        hintText: 'Enter code',
                      ),
                      validator: authController.validateOtp,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Resend code button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed('/resend-otp',
                            arguments: {'email': email}),
                        child: Text("Didn't receive the code? Resend",
                            style: TextStyle(
                              color: Colors.teal[700],
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Error & Loading with improved styling
                    Obx(() {
                      if (authController.isLoading.value) {
                        return Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                              strokeWidth: 2.5,
                            ),
                            const SizedBox(height: 12),
                            Text('Verifying code...',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14)),
                          ],
                        );
                      }

                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red[700], size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  authController.errorMessage.value,
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                        height: authController.errorMessage.value.isNotEmpty
                            ? 16
                            : 0),

                    // Verify Email Button with improved styling
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.verifyOtp(email, otpController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          shadowColor: Colors.teal.withOpacity(0.4),
                        ),
                        child: const Text('Verify Email',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// screens/resend_otp_screen.dart
class ResendOtpScreen extends StatelessWidget {
  final String email = Get.arguments['email'];
  final AuthController authController = Get.put(AuthController());

  ResendOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button with improved styling
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87, size: 20),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 30),

              // Header with icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.autorenew_rounded,
                      color: Colors.teal, size: 40),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Center(
                child: Text('Resend Verification',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontSize: 28)),
              ),
              const SizedBox(height: 12),

              // Description with email
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Resend verification code to\n',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    children: [
                      TextSpan(
                        text: email,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.teal[700],
                            fontSize: 16),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Error message
              Obx(() {
                if (authController.errorMessage.value.isNotEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red[700], size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            authController.errorMessage.value,
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              SizedBox(
                height: authController.errorMessage.value.isNotEmpty ? 16 : 0,
              ),

              // Loading indicator
              Obx(() {
                if (authController.isLoading.value) {
                  return Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                        strokeWidth: 2.5,
                      ),
                      const SizedBox(height: 12),
                      Text('Sending code...',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14)),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 24),

              // Resend Code Button with improved styling
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    authController.resendOtp(email);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    shadowColor: Colors.teal.withOpacity(0.4),
                  ),
                  child: const Text('Resend Code',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),

              // Additional information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: Colors.teal[700], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Important Information',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.teal[700],
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '• Check your spam folder if you don\'t see the email\n'
                      '• The verification code will expire in 10 minutes\n'
                      '• You can request a new code every 2 minutes',
                      style: TextStyle(
                          color: Colors.teal[800], fontSize: 14, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// screens/forget_password_screen.dart
class ForgetPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button with improved styling
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87, size: 20),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 30),

              // Header with icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_reset_rounded,
                      color: Colors.teal, size: 40),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Center(
                child: Text('Reset Password',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontSize: 28)),
              ),
              const SizedBox(height: 12),

              // Description
              Center(
                child: Text(
                  'Enter your email to receive a reset link',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field with enhanced styling
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon:
                            Icon(Icons.email_outlined, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        floatingLabelStyle: const TextStyle(color: Colors.teal),
                      ),
                      validator: authController.validateEmail,
                    ),
                    const SizedBox(height: 32),

                    // Error message
                    Obx(() {
                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red[700], size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  authController.errorMessage.value,
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                      height:
                          authController.errorMessage.value.isNotEmpty ? 16 : 0,
                    ),

                    // Loading indicator
                    Obx(() {
                      if (authController.isLoading.value) {
                        return Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                              strokeWidth: 2.5,
                            ),
                            const SizedBox(height: 12),
                            Text('Sending reset code...',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14)),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    const SizedBox(height: 24),

                    // Send Reset Link Button with improved styling
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController
                                .requestPasswordReset(emailController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          shadowColor: Colors.teal.withOpacity(0.4),
                        ),
                        child: const Text('Send Reset Code',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// screens/reset_password_with_otp_screen.dart
class ResetPasswordWithOtpScreen extends StatelessWidget {
  final String email = Get.arguments['email'];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthController authController = Get.put(AuthController());

  // Observable for password visibility
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  ResetPasswordWithOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button with improved styling
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.black87, size: 20),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 30),

              // Header with icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_open_rounded,
                      color: Colors.teal, size: 40),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Center(
                child: Text('Reset Password',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontSize: 28)),
              ),
              const SizedBox(height: 12),

              // Description with email
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Reset password for\n',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    children: [
                      TextSpan(
                        text: email,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.teal[700],
                            fontSize: 16),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // OTP Field with enhanced styling
                    TextFormField(
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: 'Verification Code',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon:
                            Icon(Icons.sms_outlined, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Colors.teal, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        floatingLabelStyle: const TextStyle(color: Colors.teal),
                        hintText: 'Enter 6-digit code',
                      ),
                      validator: authController.validateOtp,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // New Password Field with Toggle
                    Obx(() => TextFormField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible.value,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.lock_outline_rounded,
                                color: Colors.grey[600]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: () => isPasswordVisible.value =
                                  !isPasswordVisible.value,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            floatingLabelStyle:
                                const TextStyle(color: Colors.teal),
                            helperText: 'Must be at least 8 characters',
                            helperStyle: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                          validator: authController.validatePassword,
                        )),
                    const SizedBox(height: 20),

                    // Confirm Password Field with Toggle
                    Obx(() => TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !isConfirmPasswordVisible.value,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.grey[600]),
                            prefixIcon: Icon(Icons.lock_outline_rounded,
                                color: Colors.grey[600]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isConfirmPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: () => isConfirmPasswordVisible.value =
                                  !isConfirmPasswordVisible.value,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: Colors.teal, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            floatingLabelStyle:
                                const TextStyle(color: Colors.teal),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password is required';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        )),
                    const SizedBox(height: 32),

                    // Error message
                    Obx(() {
                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  color: Colors.red[700], size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  authController.errorMessage.value,
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                      height:
                          authController.errorMessage.value.isNotEmpty ? 16 : 0,
                    ),

                    // Loading indicator
                    Obx(() {
                      if (authController.isLoading.value) {
                        return Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                              strokeWidth: 2.5,
                            ),
                            const SizedBox(height: 12),
                            Text('Resetting password...',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14)),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    const SizedBox(height: 24),

                    // Reset Password Button with improved styling
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.resetPasswordWithOtp(
                              email,
                              passwordController.text,
                              otpController.text,
                              confirmPasswordController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          shadowColor: Colors.teal.withOpacity(0.4),
                        ),
                        child: const Text('Reset Password',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
