// screens/onboarding_screen.dart

import './controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 129, 237, 194),
              Colors.white,
            ],
            stops: [0.4, 0.4],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 60,
                    color: Color.fromARGB(255, 129, 237, 194),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Welcome to Our App',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Join us today and explore amazing features!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/login'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Get.toNamed('/register'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Register', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// screens/login_screen.dart

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Welcome back!',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text('Sign in to continue your journey',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: authController.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                      obscureText: true,
                      validator: authController.validatePassword,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed('/forget-password'),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(() {
                      if (authController.isLoading.value) {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(255, 129, 237, 194),
                        );
                      }

                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            authController.errorMessage.value,
                            style: TextStyle(color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                        height: authController.errorMessage.value.isNotEmpty
                            ? 16
                            : 0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.login(
                              emailController.text, passwordController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child:
                          const Text('Sign In', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR',
                              style: TextStyle(color: Colors.grey[600])),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => Get.toNamed('/register'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Create New Account',
                          style: TextStyle(fontSize: 16)),
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Create Account',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text('Join us to get started',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: authController.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        helperText: 'Must be at least 8 characters',
                      ),
                      obscureText: true,
                      validator: authController.validatePassword,
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      if (authController.isLoading.value) {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(255, 129, 237, 194),
                        );
                      }

                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            authController.errorMessage.value,
                            style: TextStyle(color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                        height: authController.errorMessage.value.isNotEmpty
                            ? 16
                            : 0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.register(
                              emailController.text, passwordController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Create Account',
                          style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR',
                              style: TextStyle(color: Colors.grey[600])),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Already have an account? Sign In',
                          style: TextStyle(fontSize: 16)),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Verify Email',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: 'Enter the 6-digit code sent to ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: otpController,
                      decoration: const InputDecoration(
                        labelText: 'Verification Code',
                        prefixIcon: Icon(Icons.sms_outlined),
                      ),
                      validator: authController.validateOtp,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      if (authController.isLoading.value) {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(255, 129, 237, 194),
                        );
                      }

                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            authController.errorMessage.value,
                            style: TextStyle(color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                        height: authController.errorMessage.value.isNotEmpty
                            ? 16
                            : 0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.verifyOtp(email, otpController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Verify Email',
                          style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => Get.toNamed('/resend-otp',
                          arguments: {'email': email}),
                      child: const Text("Didn't receive the code? Resend"),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Resend Verification',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: 'Resend verification code to ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Obx(() {
                if (authController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 129, 237, 194),
                    ),
                  );
                }

                if (authController.errorMessage.value.isNotEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Text(
                      authController.errorMessage.value,
                      style: TextStyle(color: Colors.red[700]),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return const SizedBox.shrink();
              }),
              SizedBox(
                  height:
                      authController.errorMessage.value.isNotEmpty ? 24 : 0),
              ElevatedButton(
                onPressed: () {
                  authController.resendOtp(email);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child:
                    const Text('Resend Code', style: TextStyle(fontSize: 18)),
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Reset Password',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text('Enter your email to receive a reset link',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: authController.validateEmail,
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      if (authController.isLoading.value) {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(255, 129, 237, 194),
                        );
                      }

                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            authController.errorMessage.value,
                            style: TextStyle(color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                        height: authController.errorMessage.value.isNotEmpty
                            ? 16
                            : 0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController
                              .requestPasswordReset(emailController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Send Reset Link',
                          style: TextStyle(fontSize: 18)),
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

  ResetPasswordWithOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Reset Password',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  text: 'Reset password for ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: otpController,
                      decoration: const InputDecoration(
                        labelText: 'Verification Code',
                        prefixIcon: Icon(Icons.sms_outlined),
                      ),
                      validator: authController.validateOtp,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        helperText: 'Must be at least 8 characters',
                      ),
                      obscureText: true,
                      validator: authController.validatePassword,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    Obx(() {
                      if (authController.isLoading.value) {
                        return const CircularProgressIndicator(
                          color: Color.fromARGB(255, 129, 237, 194),
                        );
                      }

                      if (authController.errorMessage.value.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Text(
                            authController.errorMessage.value,
                            style: TextStyle(color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    }),
                    SizedBox(
                        height: authController.errorMessage.value.isNotEmpty
                            ? 16
                            : 0),
                    ElevatedButton(
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
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('Reset Password',
                          style: TextStyle(fontSize: 18)),
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
