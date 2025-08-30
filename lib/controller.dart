// controllers/auth_controller.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import './constance.dart';

import 'package:http/http.dart' as http;
import 'package:patient_project/ConstantURL.dart';
import 'package:get/get.dart';

import 'homeDoctor.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  //when use real mobile put ip your computer
 // final String baseUrl = 'http://192.168.43.198:8000';

  //when use emulator
  // final String baseUrl = 'http://10.0.2.2:8000';

  // Validation methods
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
    //   return 'Enter a valid email';
    // }
    if (!RegExp(r'^[\w\.\-\+]+@([\w\-]+\.)+[a-zA-Z]{2,}$').hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }


  // bool isValidEmail(String email) {
  //   print("📧 التحقق من صحة الإيميل: $email");
  //   // تعبير نمطي (Regex) للتحقق من صحة البريد الإلكتروني
  //   final emailRegex = RegExp(
  //     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  //   );
  //   bool isValid = emailRegex.hasMatch(email);
  //   print(isValid ? "✅ الإيميل صحيح" : "❌ الإيميل غير صحيح");
  //   return isValid;
  // }
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';

    return null;
  }

  String? validateOtp(String? otp) {
    if (otp == null || otp.isEmpty) return 'OTP is required';
    return null;
  }

  Future<void> register(String email, String password) async {
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);
    if (emailError != null || passwordError != null) {
      errorMessage(emailError ?? passwordError!);
      return;
    }
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/api/email/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        Get.toNamed('/verify-email', arguments: {'email': email});
      } else {
        errorMessage(
            jsonDecode(response.body)['message'] ?? 'Registration failed');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final emailError = validateEmail(email);
    final otpError = validateOtp(otp);
    if (emailError != null || otpError != null) {
      errorMessage(emailError ?? otpError!);
      return;
    }
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/api/email/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      if (response.statusCode == 200) {
        Get.toNamed('/login');
      } else {
        errorMessage(
            jsonDecode(response.body)['message'] ?? 'Verification failed');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);
    if (emailError != null || passwordError != null) {
      errorMessage(emailError ?? passwordError!);
      return;
    }
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/api/email/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Logged in successfully');
        Map data = jsonDecode(response.body);
        token = data['token'];
        print(token);
        role = data['role'];

        // حفظ التوكن في SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        await prefs.setBool('is_logged_in', true);
        if (role == 'patient') {
          //go to patient screen
          Get.snackbar('Success', 'Logged in successfully as patient');
        } else if (role == 'admin') {
          //go to admin screen
          Get.snackbar('Success', 'Logged in successfully as admin');
        } else if (role == 'doctor') {
          //go to doctor screen
          Get.snackbar('Success', 'Logged in successfully as doctor');
          Get.off(() => HomeDoctor(token: token));
        } else if (role == 'secretary') {
          //go to secretary screen
          Get.snackbar('Success', 'Logged in successfully as secretary');
        }
      } else {
        errorMessage(jsonDecode(response.body)['message'] ?? 'Login failed');
        print(jsonDecode(response.body)['message'] ?? 'Login failed');
      }
    } catch (e) {
      errorMessage('Error: $e');
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> resendOtp(String email) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      errorMessage(emailError);
      return;
    }
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/api/email/resendOtp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP resent successfully');
        Get.back();
      } else {
        errorMessage(jsonDecode(response.body)['message'] ?? 'Resend failed');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> requestPasswordReset(String email) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      errorMessage(emailError);
      return;
    }
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/api/email/requestPasswordReset'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) {
        Get.toNamed('/reset-password-otp', arguments: {'email': email});
      } else {
        errorMessage(jsonDecode(response.body)['message'] ?? 'Request failed');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> resetPasswordWithOtp(
      String email, String password, String otp, String confirmPassword) async {
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);
    final otpError = validateOtp(otp);
    if (password != confirmPassword) {
      errorMessage('Passwords do not match');
      return;
    }
    if (emailError != null || passwordError != null || otpError != null) {
      errorMessage(emailError ?? passwordError ?? otpError!);
      return;
    }
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('$baseUrl/api/email/resetPasswordWithOtp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'otp': otp,
          'password_confirmation': confirmPassword
        }),
      );
      if (response.statusCode == 200) {
        Get.toNamed('/login');
        Get.snackbar('Success', 'Password reset successfully');
      } else {
        errorMessage(jsonDecode(response.body)['message'] ?? 'Reset failed');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
