// import 'package:flutter/material.dart';
// // Import the dio package for HTTP requests
// import 'package:dio/dio.dart';
// import 'package:patient_project/main.dart';
// import 'package:patient_project/screens/pages.dart';
// // Import shared_preferences for local storage
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:patient_project/screens/centerBage.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   // Key to control the form's state and validation
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for the input fields
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   // A boolean to control password visibility
//   bool _isPasswordVisible = false;

//   // A boolean to manage the loading state of the button
//   bool _isLoading = false;
//   // A boolean to handle the initial check for a token
//   bool _isCheckingToken = true;

//   // Define the new color palette
//   final Color _primaryColor = const Color(0xFF4CAF50); // A fresh green
//   final Color _accentColor = const Color(0xFF81C784); // A lighter green
//   final Color _backgroundColor =
//       const Color(0xFFF1F8E9); // A very light green/off-white

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   // Check if a login token already exists
//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');

//     if (token != null) {
//       // If a token is found, navigate to the main page immediately
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const centerBage()),
//         );
//       });
//     }

//     // Set checking token state to false once the check is complete
//     setState(() {
//       _isCheckingToken = false;
//     });
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // Asynchronous login function using Dio
//   Future<void> _login() async {
//     // Check if the form is valid before proceeding
//     if (_formKey.currentState!.validate()) {
//       // Set loading state to true and refresh the UI
//       setState(() {
//         _isLoading = true;
//       });

//       // The API endpoint for login
//       const String apiUrl = 'http://127.0.0.1:8000/api/email/login';

//       // Create a new Dio instance
//       final dio = Dio();

//       try {
//         // Send a POST request to the API with the email and password
//         final response = await dio.post(
//           apiUrl,
//           data: {
//             'email': _emailController.text,
//             'password': _passwordController.text,
//           },
//         );

//         // Check if the response was successful (status code 200)
//         if (response.statusCode == 200) {
//           // Parse the response data
//           final Map<String, dynamic> data = response.data;

//           // Display a success message
//           if (data['message'] == 'messages.login_success') {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   'Login successful!',
//                   textAlign: TextAlign.center,
//                 ),
//                 backgroundColor: Colors.green,
//               ),
//             );

//             // Save the token for future use
//             await sharedPreferences!.setString('token', data['token']);
//             await sharedPreferences!.setString('role', data['role']);

//             // Navigate to the next page upon successful login
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const centerBage()),
//             );
//           } else {
//             // Handle unexpected successful response formats
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   'Login failed. Unexpected server response.',
//                   textAlign: TextAlign.center,
//                 ),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         }
//       } on DioException catch (e) {
//         // Handle Dio-specific errors (e.g., network issues, server errors)
//         String errorMessage = 'An unexpected error occurred.';
//         if (e.response != null) {
//           // The server responded with a status code other than 2xx
//           final responseData = e.response!.data;
//           if (responseData != null &&
//               responseData is Map &&
//               responseData.containsKey('message')) {
//             // Use the specific error message from the API
//             errorMessage = responseData['message'];
//           } else {
//             errorMessage = 'Server error: ${e.response!.statusCode}';
//           }
//         } else {
//           // No response received, likely a network error
//           errorMessage = 'Network error. Please check your connection.';
//         }

//         // Display the error message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               errorMessage,
//               textAlign: TextAlign.center,
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } catch (e) {
//         // Handle any other types of errors
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'An unexpected error occurred.',
//               textAlign: TextAlign.center,
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       } finally {
//         // Set loading state back to false after the request completes
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Show a loading indicator while checking for a saved token
//     if (_isCheckingToken) {
//       return const Scaffold(
//         backgroundColor: Color(0xFFF1F8E9),
//         body: Center(
//           child: CircularProgressIndicator(
//             color: Color(0xFF4CAF50),
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Text(
//                   'Welcome to our clinic',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 36.0,
//                     fontWeight: FontWeight.w900,
//                     color: Color(0xFF4CAF50),
//                   ),
//                 ),
//                 const SizedBox(height: 48.0),
//                 // Email input field
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     labelStyle: TextStyle(color: _primaryColor),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       borderSide: BorderSide(color: _primaryColor),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       borderSide: BorderSide(color: _primaryColor, width: 2),
//                     ),
//                     prefixIcon: Icon(Icons.email, color: _primaryColor),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 // Password input field
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   maxLength: 8,
//                   decoration: InputDecoration(
//                     labelText: 'Password (8 characters or numbers)',
//                     labelStyle: TextStyle(color: _primaryColor),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       borderSide: BorderSide(color: _primaryColor),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       borderSide: BorderSide(color: _primaryColor, width: 2),
//                     ),
//                     prefixIcon: Icon(Icons.lock, color: _primaryColor),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: _primaryColor,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a password';
//                     }
//                     if (value.length < 8) {
//                       return 'Password must be at least 8 characters long';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30.0),
//                 // Sign In button
//                 ElevatedButton(
//                   onPressed: _isLoading
//                       ? null
//                       : _login, // Disable button while loading
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _primaryColor,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                           'Login',
//                           style: TextStyle(fontSize: 18.0),
//                         ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 // Register button
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigate to the new page when this button is pressed
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RegisterScreen()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _accentColor,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                   ),
//                   child: const Text(
//                     'Sign Up',
//                     style: TextStyle(fontSize: 18.0),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
