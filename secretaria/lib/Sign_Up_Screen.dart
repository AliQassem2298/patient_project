// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:helloworld/widget/Login_Screen.dart';
// import 'package:helloworld/ConstantURL.dart';
// import 'package:helloworld/short_cut.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignUpApp extends StatelessWidget {
//   const SignUpApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SignUpScreen(),
//     );
//   }
// }

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   GlobalKey<FormState> state = GlobalKey();

//   TextEditingController controller_FirstName = TextEditingController();
//   TextEditingController controller_LastName = TextEditingController();
//   TextEditingController controller_Number = TextEditingController();
//   TextEditingController controller_password = TextEditingController();
//   TextEditingController controller_confirm = TextEditingController();
//   TextEditingController controller_location = TextEditingController();

//   String? confirm;
//   File? _image;
//   final picker = ImagePicker();
//   String languageCode = 'E';

//   @override
//   void initState() {
//     super.initState();
//     getLanguage();
//     _resetControllers(); // إعادة تعيين الحقول
//   }

//   void _resetControllers() {
//     controller_FirstName.clear();
//     controller_LastName.clear();
//     controller_Number.clear();
//     controller_password.clear();
//     controller_confirm.clear();
//     controller_location.clear();
//     setState(() {
//       _image = null; // إعادة تعيين الصورة أيضًا
//     });
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       print("Image selected: ${_image!.path}");
//     } else {
//       print("No image selected.");
//     }
//   }

//   void getLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? lang = prefs.getString('languageCode');
//     if (lang != null) {
//       setState(() {
//         languageCode = lang;
//       });
//     }
//   }

//   Future<void> registerUser() async {
//     if (controller_FirstName.text.isEmpty ||
//         controller_Number.text.isEmpty ||
//         controller_password.text.isEmpty ||
//         controller_confirm.text.isEmpty ||
//         controller_LastName.text.isEmpty) {
//       Fluttertoast.showToast(
//         msg: languageCode == 'E'
//             ? "please fill the fields"
//             : "الرجاء املأ الحقول",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       return;
//     }

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$baseUrl/api/auth/register'),
//     );
//     request.fields['first_name'] = controller_FirstName.text;
//     request.fields['last_name'] = controller_LastName.text;
//     request.fields['phone'] = controller_Number.text;
//     request.fields['password'] = controller_password.text;
//     request.fields['location'] = controller_location.text; // حتى لو كان فارغًا

//     if (_image != null) {
//       request.files.add(await http.MultipartFile.fromPath(
//         'personal_photo',
//         _image!.path,
//       ));
//     }

//     var response = await request.send();

//     if (response.statusCode == 200) {
//       Fluttertoast.showToast(
//         msg: languageCode == 'E'
//             ? "account created successfully , please enter your new account"
//             : "تم إنشاء الحساب بنجاح، الرجاء ادخل حسابك الجديد",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.blueAccent.shade400,
//         textColor: Colors.white,
//       );

//       await Future.delayed(const Duration(seconds: 0));
//       Navigator.push(
//           context, MaterialPageRoute(builder: (_) => const Login_Screen()));
//     } else {
//       Fluttertoast.showToast(
//         msg: languageCode == 'E'
//             ? "creation failed :phone number has taken before"
//             : "فشل إنشاء الحساب:",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => SignUpScreen()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextDirection textDirection =
//         languageCode == 'A' ? TextDirection.rtl : TextDirection.ltr;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(languageCode == 'E' ? "Register page" : "صفحة التسجيل"),
//         backgroundColor: Colors.blue,
//         centerTitle: true,
//       ),
//       body: Directionality(
//         textDirection: textDirection,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: state,
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _image != null ? FileImage(_image!) : null,
//                     child: _image == null
//                         ? const Icon(
//                             Icons.camera_alt,
//                             size: 50,
//                             color: Colors.grey,
//                           )
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Textfield(
//                   controller: controller_FirstName,
//                   icons: const Icon(Icons.person),
//                   labelText: languageCode == 'E' ? 'First Name' : 'الاسم الأول',
//                   type: TextInputType.name,
//                   validate: (value) {
//                     if (value.isEmpty) {
//                       return languageCode == 'E' ? "empty field" : 'الحقل فارغ';
//                     }
//                     if (value.length >= 30) {
//                       return languageCode == 'E'
//                           ? "Name must be between 0-30 character"
//                           : " الاسم يجب أن يكون بين 0-30 حرف";
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                       icon: const Icon(Icons.person),
//                       labelText:
//                           languageCode == 'E' ? 'First Name' : 'الاسم الأول',
//                       focusedBorder: const OutlineInputBorder()),
//                 ),
//                 const SizedBox(height: 16),
//                 Textfield(
//                   controller: controller_LastName,
//                   icons: const Icon(Icons.person),
//                   labelText: languageCode == 'E' ? 'Last Name' : 'الاسم الأخير',
//                   type: TextInputType.name,
//                   validate: (value) {
//                     if (value.isEmpty) {
//                       return languageCode == 'E' ? "empty field" : 'الحقل فارغ';
//                     }
//                     if (value.length >= 30) {
//                       return languageCode == 'E'
//                           ? "Name must be between 0-30 character"
//                           : " الاسم يجب أن يكون بين 0-30 حرف";
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                       icon: const Icon(Icons.person),
//                       labelText:
//                           languageCode == 'E' ? 'Last Name' : 'الاسم الأخير',
//                       focusedBorder: const OutlineInputBorder()),
//                 ),
//                 const SizedBox(height: 16),
//                 Textfield(
//                     controller: controller_Number,
//                     maxlength: 10,
//                     icons: const Icon(Icons.phone_android_outlined),
//                     labelText: languageCode == 'E'
//                         ? 'Your Phone number ex:09********'
//                         : '********09 رقم جوالك مثل:',
//                     type: TextInputType.number,
//                     validate: (value) {
//                       if (value.isEmpty) {
//                         return languageCode == 'E'
//                             ? "empty field"
//                             : 'الحقل فارغ';
//                       }
//                       if (value.length <= 9 || value.length > 10) {
//                         return languageCode == 'E'
//                             ? "wrong number"
//                             : "الرقم خطأ";
//                       }
//                     },
//                     decoration: InputDecoration(
//                         icon: const Icon(Icons.phone_android_outlined),
//                         labelText: languageCode == 'E'
//                             ? 'Your Phone number ex:09********'
//                             : 'رقم جوالك مثل:********09',
//                         focusedBorder: const OutlineInputBorder())),
//                 const SizedBox(height: 7),
//                 Textfield(
//                     controller: controller_password,
//                     icons: const Icon(Icons.lock),
//                     labelText:
//                         languageCode == 'E' ? 'New Password' : 'كلمة سر جديدة',
//                     type: TextInputType.text,
//                     validate: (value) {
//                       if (value.length <= 6) {
//                         return languageCode == 'E'
//                             ? "wrong , short password"
//                             : "خطأ، كلمة السر قصيرة";
//                       }
//                       if (value.isEmpty) {
//                         return languageCode == 'E'
//                             ? "empty field"
//                             : 'الحقل فارغ';
//                       }
//                       if ((confirm = value) ==
//                           (value.length > 6 && value.length <= 30)) {
//                         return null;
//                       }
//                     },
//                     obscureText: true,
//                     decoration: InputDecoration(
//                         icon: const Icon(Icons.lock),
//                         labelText:
//                             languageCode == 'E' ? 'Password' : "كلمة السر",
//                         focusedBorder: const OutlineInputBorder())),
//                 const SizedBox(height: 16),
//                 Textfield(
//                     controller: controller_confirm,
//                     icons: const Icon(Icons.lock),
//                     labelText: languageCode == 'E'
//                         ? 'Confirm Password'
//                         : "تأكيد كلمة السر",
//                     type: TextInputType.text,
//                     validate: (value) {
//                       if (value.length <= 6) {
//                         return languageCode == 'E'
//                             ? "wrong , short password"
//                             : "خطأ، كلمة السر قصيرة";
//                       }
//                       if (value.isEmpty) {
//                         return languageCode == 'E'
//                             ? "empty field"
//                             : 'الحقل فارغ';
//                       }
//                       if (value.length == confirm!.length) {
//                       } else {
//                         return languageCode == 'E'
//                             ? "Password does not match"
//                             : "كلمة السر غير متطابقة";
//                       }
//                     },
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       focusedBorder: const OutlineInputBorder(),
//                       icon: const Icon(Icons.lock),
//                       labelText: languageCode == 'E'
//                           ? 'Confirm Password'
//                           : "تأكيد كلمة السر",
//                     )),
//                 const SizedBox(height: 16),
//                 Textfield(
//                   controller: controller_location,
//                   icons: const Icon(Icons.location_on),
//                   labelText: languageCode == 'E' ? 'location' : "الموقع",
//                   type: TextInputType.text,
//                   validate: (value) {
//                     // جعل الحقل اختياريًا
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     icon: const Icon(Icons.location_on),
//                     labelText: languageCode == 'E' ? 'location' : "الموقع",
//                     focusedBorder: const OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 elvatButton(
//                     text: languageCode == 'E' ? 'Sign Up' : "التسجيل",
//                     function: () {
//                       if (state.currentState!.validate()) {
//                         registerUser();
//                       }
//                     }),
//                 const SizedBox(height: 8),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => const Login_Screen()));
//                   },
//                   child: Text(languageCode == 'E'
//                       ? "Already have an account? Log-in"
//                       : " هل لديك حساب؟ سجل الدخول"),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
