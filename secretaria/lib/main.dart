// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:helloworld/widget/Login_Screen.dart';
// import 'package:helloworld/cubit/post_cubit_Secretary.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// //import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
//   final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

//   runApp(MyApp());
//   // runApp(MyApp(isLoggedIn: isLoggedIn));
// }

// class MyApp extends StatelessWidget {
// //  final bool isLoggedIn;
//   const MyApp({super.key});
//   // const MyApp({super.key, required this.isLoggedIn});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => PostCubitDoctor(),
//       child: MaterialApp(
//         title: 'patient_project',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           fontFamily: 'Tajawal',
//         ),
//         //   home: isLoggedIn ? const HomeDoctor() : const Login_Screen (),
//         home: const Login_Screen(),
//       ),
//     );
//   }
// }
