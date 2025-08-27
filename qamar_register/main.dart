// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:clinc/Login_Screen.dart';
// // import 'package:clinc/cubit/post_cubit_doctor.dart';
// // import 'package:clinc/homeDoctor.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // //
// // // void main() {
// // //   runApp(const MyApp());
// // // }
// // //
// // // class MyApp extends StatelessWidget {
// // //   const MyApp({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'تسجيل الدخول',
// // //       theme: ThemeData(
// // //         primarySwatch: Colors.blue,
// // //         fontFamily: 'Tajawal',
// // //       ),
// // //       home: RepositoryProvider(
// // //         create: (context) => PostCubitDoctor(),
// // //         child: const LoginScreen(),
// // //          // child: const HomeDoctor(),
// // //       ),
// // //     );
// // //   }
// // // }
// //////////////////////////////////////////////
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   final prefs = await SharedPreferences.getInstance();
// //   final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
// //
// //   runApp(MyApp());
// //  // runApp(MyApp(isLoggedIn: isLoggedIn));
// // }
// //
// // class MyApp extends StatelessWidget {
// // //  final bool isLoggedIn;
// //   const MyApp({super.key});
// //  // const MyApp({super.key, required this.isLoggedIn});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocProvider(
// //       create: (context) => PostCubitDoctor(),
// //       child: MaterialApp(
// //         title: 'العيادة',
// //         debugShowCheckedModeBanner: false,
// //         theme: ThemeData(
// //           primarySwatch: Colors.blue,
// //           fontFamily: 'Tajawal',
// //         ),
// //     //   home: isLoggedIn ? const HomeDoctor() : const Login_Screen (),
// //         home: const Login_Screen (),
// //       ),
// //     );
// //   }
// // }

// // // main.dart///////////////////////////////////////////////
// // import './constance.dart';
// // import './pages.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GetMaterialApp(
// //       theme: theme,
// //       home: OnboardingScreen(),
// //       getPages: [
// //         GetPage(name: '/onboarding', page: () => OnboardingScreen()),
// //         GetPage(name: '/login', page: () => LoginScreen()),
// //         GetPage(name: '/register', page: () => RegisterScreen()),
// //         GetPage(name: '/verify-email', page: () => VerifyEmailScreen()),
// //         GetPage(name: '/resend-otp', page: () => ResendOtpScreen()),
// //         GetPage(name: '/forget-password', page: () => ForgetPasswordScreen()),
// //         GetPage(
// //             name: '/reset-password-otp',
// //             page: () => ResetPasswordWithOtpScreen()),
// //       ],
// //     );
// //   }
// // }



// import './constance.dart';
// import './pages.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:clinc/cubit/post_cubit_doctor.dart';
// import 'package:clinc/Login_Screen.dart';
// import 'package:clinc/homeDoctor.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
//   final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
//   runApp(MyApp());
//  // runApp(MyApp(isLoggedIn: isLoggedIn));
// }

// class MyApp extends StatelessWidget {
// //  final bool isLoggedIn;
//  // const MyApp({super.key, required this.isLoggedIn});
//  const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => PostCubitDoctor(),
//       child: GetMaterialApp(
//         theme: theme,
//         debugShowCheckedModeBanner: false,
//         home: //isLoggedIn ? const HomeDoctor() :
//         OnboardingScreen(),
//         getPages: [
//           GetPage(name: '/onboarding', page: () => OnboardingScreen()),
//           GetPage(name: '/login', page: () => LoginScreen()),
//           GetPage(name: '/register', page: () => RegisterScreen()),
//           GetPage(name: '/verify-email', page: () => VerifyEmailScreen()),
//           GetPage(name: '/resend-otp', page: () => ResendOtpScreen()),
//           GetPage(name: '/forget-password', page: () => ForgetPasswordScreen()),
//           GetPage(name: '/reset-password-otp', page: () => ResetPasswordWithOtpScreen(),),
//           //GetPage(name: '/home-doctor', page: () => const HomeDoctor()),
//         ],
//       ),
//     );
//   }
// }




