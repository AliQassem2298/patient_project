// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:patient_project/cubit/post_cubit_Secretary.dart';
import 'package:patient_project/middleware/auth_middleware.dart';
import 'package:patient_project/screens/centerBage.dart';
import 'package:patient_project/screens/pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubitDoctor(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('ar', ''), // Arabic
        ],
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        // home: const LoginScreen(),
        home: OnboardingScreen(),
        // initialRoute: centerBage.id,
        getPages: [
          GetPage(
              name: centerBage.id,
              page: () => OnboardingScreen(),
              middlewares: [
                AuthMiddleare(),
              ]),
          GetPage(name: '/login', page: () => LoginScreenN()),
          GetPage(name: '/register', page: () => RegisterScreen()),
          GetPage(name: '/verify-email', page: () => VerifyEmailScreen()),
          GetPage(name: '/resend-otp', page: () => ResendOtpScreen()),
          GetPage(name: '/forget-password', page: () => ForgetPasswordScreen()),
          GetPage(name: centerBage.id, page: () => const centerBage()),
          GetPage(
              name: '/reset-password-otp',
              page: () => ResetPasswordWithOtpScreen()),
        ],
      ),
    );
  }
}
