// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:patient_project/homeDoctor.dart';
// import 'package:patient_project/Sign_Up_Screen.dart';
// import 'package:patient_project/token.dart';
// import 'package:patient_project/ConstantURL.dart';
// import 'package:patient_project/short_cut.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:animate_do/animate_do.dart';
// import 'package:animate_do/animate_do.dart';

// class OnBoardingPage extends StatefulWidget {
//   const OnBoardingPage({super.key});

//   @override
//   OnBoardingPageState createState() => OnBoardingPageState();
// }

// class OnBoardingPageState extends State<OnBoardingPage> {
//   // TextDirection textDirection = languageCode == 'A' ? TextDirection.rtl : TextDirection.ltr;
//   final introKey = GlobalKey<IntroductionScreenState>();

//   Future<void> _completeOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('hasSeenOnboarding', true);

//     Navigator.of(
//       context,
//     ).pushReplacement(MaterialPageRoute(builder: (_) => const Login_Screen()));
//   }

//   /// بناء الصور المستخدمة في صفحات OnBoarding
//   Widget _buildImage(String assetName, [double width = double.infinity]) {
//     return Image.asset('images/$assetName', width: width);
//   }

//   @override
//   Widget build(BuildContext context) {
//     const bodyStyle = TextStyle(fontSize: 19.0);

//     const pageDecoration = PageDecoration(
//       titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
//       bodyTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
//       pageColor: Colors.white,
//     );

//     return IntroductionScreen(
//       key: introKey,
//       globalBackgroundColor: Colors.white,
//       allowImplicitScrolling: true,
//       globalFooter: SizedBox(
//         width: double.infinity,
//         height: 80,
//         child: ElevatedButton(
//           onPressed: _completeOnboarding,
//           child: const Text(
//             'Skip all of them',
//             style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//       pages: [
//         PageViewModel(
//           title: "Hello user",
//           body: "Welcome to our shop application",
//           // image: _buildImage(
//           //     'helppier-welcome-tours-in-app-messaging-templates-4.png'),
//           decoration: pageDecoration,
//         ),
//         PageViewModel(
//           title: "With your touch",
//           body: "Browse the app, and choose anything you want",
//           // image: _buildImage(
//           //     'young-male-displaying-shopping-bags-t-shirt-jacket-looking-jolly-front-view.png'),
//           decoration: pageDecoration,
//         ),
//         PageViewModel(
//           title: "Secure and Safe",
//           body: "Strong safety with low-cost delivery",
//           // image: _buildImage('1698861237247.jpg'),
//           decoration: pageDecoration,
//         ),
//       ],
//       onDone: _completeOnboarding,
//       onSkip: _completeOnboarding,
//       // عند الضغط على Skip يتم الإكمال
//       showSkipButton: true,
//       skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
//       next: const Icon(Icons.arrow_forward),
//       done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
//       dotsDecorator: const DotsDecorator(
//         size: Size(10.0, 10.0),
//         color: Color(0xFFBDBDBD),
//         activeSize: Size(22.0, 10.0),
//         activeShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(25.0)),
//         ),
//       ),
//     );
//   }
// }

// class Login_Screen extends StatefulWidget {
//   const Login_Screen({super.key});

//   @override
//   State<Login_Screen> createState() => _login_Screen();
// }

// class _login_Screen extends State<Login_Screen> {
//   String languageCode = 'E';
//   bool _obscurePassword = true;

//   // String? token;
//   GlobalKey<FormState> formstatePassword = GlobalKey();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   void getLanguage() async {
//     print("🔄 جاري تحميل اللغة...");
//     final prefs = await SharedPreferences.getInstance();
//     String? lang = prefs.getString('languageCode');
//     setState(() {
//       languageCode = lang;
//     });
//     print("✅ تم تحميل اللغة: $languageCode");
//   }

//   bool isValidEmail(String email) {
//     print("📧 التحقق من صحة الإيميل: $email");
//     // تعبير نمطي (Regex) للتحقق من صحة البريد الإلكتروني
//     final emailRegex = RegExp(
//       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//     );
//     bool isValid = emailRegex.hasMatch(email);
//     print(isValid ? "✅ الإيميل صحيح" : "❌ الإيميل غير صحيح");
//     return isValid;
//   }

//   @override
//   void initState() {
//     super.initState();
//     print("🚀 بدء تشغيل شاشة تسجيل الدخول");
//     _loadSavedEmail();
//     getLanguage();
//   }

//   /// تحميل  email المحفوظ
//   Future<void> _loadSavedEmail() async {
//     print("🔍 البحث عن إيميل محفوظ...");
//     final prefs = await SharedPreferences.getInstance();
//     final savedEmail = prefs.getString('email');
//     if (savedEmail != null) {
//       emailController.text = savedEmail;
//       print("✅ تم تحميل الإيميل المحفوظ: $savedEmail");
//     } else {
//       print("ℹ️ لا يوجد إيميل محفوظ");
//     }
//   }

//   /// حفظ الايميل عند تسجيل الدخول بنجاح
//   Future<void> _saveEmail(String email) async {
//     print("💾 حفظ الإيميل: $email");
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('email', email);
//     print("✅ تم حفظ الإيميل بنجاح");
//   }

//   Future<void> _setLoggedIn() async {
//     print("🔐 تسجيل حالة تسجيل الدخول...");
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', true);
//     print("✅ تم تسجيل حالة تسجيل الدخول");
//   }

//   /// طلب تسجيل الدخول
//   Future<void> Sign_in() async {
//     print("\n=== 🚀 بداية عملية تسجيل الدخول ===");
//     print("📧 الإيميل: ${emailController.text.trim()}");
//     print(
//       "🔑 كلمة المرور: ${passwordController.text.trim().replaceAll(RegExp(r'.'), '*')}",
//     ); // إخفاء كلمة المرور
//     print(" 🌐 رابط API: $baseUrl/api/email/login");

//     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
//       print("❌ الحقول فارغة!");
//       Fluttertoast.showToast(
//         msg: languageCode == "E"
//             ? "Please fill in all fields"
//             : "الرجاء املأ كل الحقول",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         textColor: Colors.white,
//       );
//       return;
//     }

//     try {
//       print("📡 إنشاء طلب HTTP...");
//       final url = Uri.parse('$baseUrl/api/email/login');
//       print("sucess");
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({
//           'email': emailController.text.trim(),
//           'password': passwordController.text.trim(),
//         }),
//       );

//       print("📨 تم إرسال الطلب!");
//       print("📊 Status Code: ${response.statusCode}");
//       print("📋 Response Headers: ${response.headers}");
//       print("📄 Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         print("🎉 نجح الطلب! جاري معالجة البيانات...");
//         final data = jsonDecode(response.body);
//         print("📦 البيانات المستلمة: $data");

//         if (data.containsKey('token') && data['token'] != null) {
//           final token = data['token'];
//           print("🔑 تم العثور على Token: $token");

//           print("💾 حفظ Token...");
//           await tokenManager.saveToken(token);
//           print("💾 حفظ الإيميل...");
//           await _saveEmail(emailController.text);
//           print("💾 حفظ حالة تسجيل الدخول...");
//           await _setLoggedIn();

//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', token);
//           await prefs.setBool('is_logged_in', true);

//           print("✅ تم تسجيل الدخول بنجاح!");
//           Fluttertoast.showToast(
//             msg: languageCode == "E"
//                 ? "Logged in successfully"
//                 : "تم تسجيل الدخول بنجاح ",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.greenAccent,
//             textColor: Colors.white,
//           );

//           await Future.delayed(const Duration(seconds: 1));

//           print("🔄 الانتقال إلى الصفحة الرئيسية...");
//           if (!context.mounted) return;

//           // الانتقال إلى صفحة المطلوبة
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => HomeDoctor(
//                 token: token,
//                 //  token: token,
//               ),
//             ),
//           );
//         } else {
//           // في حالة عدم وجود token في الاستجابة
//           print("❌ لم يتم العثور على token في الاستجابة");
//           print("🔍 البحث عن مفاتيح أخرى في الاستجابة: ${data.keys.toList()}");
//           Fluttertoast.showToast(
//             msg: languageCode == "E"
//                 ? "Login failed: Invalid response from server"
//                 : "فشل تسجيل الدخول: استجابة غير صحيحة من الخادم",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.redAccent,
//             textColor: Colors.white,
//           );
//         }
//       } else if (response.statusCode == 401) {
//         print("🔒 خطأ 401: بيانات تسجيل الدخول غير صحيحة");
//         Fluttertoast.showToast(
//           msg: languageCode == "E"
//               ? "Login failed: wrong password"
//               : "فشل تسجيل الدخول كلمة السر غير صحيحة",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           textColor: Colors.white,
//         );
//       } else if (response.statusCode == 404) {
//         print("🔍 خطأ 404: الحساب غير موجود");
//         Fluttertoast.showToast(
//           msg: languageCode == 'E'
//               ? "Login failed: account not found with this email"
//               : "فشل تسجيل الدخول الحساب غير موجود بهذا الايميل ",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           textColor: Colors.white,
//         );
//       } else {
//         // إضافة معلومات أكثر عن الخطأ
//         print("⚠️ خطأ في الخادم:");
//         print("📊 Response Status: ${response.statusCode}");
//         print("📄 Response Data: ${response.body}");

//         Fluttertoast.showToast(
//           msg: languageCode == "E"
//               ? "Login failed: Server error (${response.statusCode})"
//               : "فشل تسجيل الدخول: خطأ في الخادم (${response.statusCode})",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.redAccent,
//           textColor: Colors.white,
//         );
//       }
//     } catch (e) {
//       // معالجة أخطاء الشبكة والاتصال
//       print("💥 خطأ في الشبكة أو الاتصال:");
//       print("❌ Login Error: $e");
//       print("🔍 تفاصيل الخطأ: ${e.toString()}");

//       Fluttertoast.showToast(
//         msg: languageCode == "E"
//             ? "Login failed: Network error - Check your connection"
//             : "فشل تسجيل الدخول: خطأ في الشبكة - تحقق من الاتصال",
//         toastLength: Toast.LENGTH_LONG,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.redAccent,
//         textColor: Colors.white,
//       );
//     }
//     print("=== 🏁 انتهاء عملية تسجيل الدخول ===\n");
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("🎨 بناء واجهة شاشة تسجيل الدخول");
//     TextDirection textDirection =
//         languageCode == 'A' ? TextDirection.rtl : TextDirection.ltr;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           languageCode == "E" ? 'Login Page' : "صفحة تسجيل الدخول",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color.fromARGB(255, 129, 237, 194),
//       ),
//       body: Directionality(
//         textDirection: textDirection,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: formstatePassword,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FadeInDown(
//                       duration: const Duration(milliseconds: 800),
//                       child: Image.asset(
//                         'assets/log.jpg',
//                         height: 200,
//                         width: double.infinity,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     SlideInLeft(
//                       duration: const Duration(milliseconds: 600),
//                       child: Animate(
//                         effects: [
//                           SlideEffect(
//                             begin: Offset(-1, 0),
//                             end: Offset(0, 0),
//                             curve: Curves.easeOut,
//                           ),
//                           FadeEffect(duration: 600.ms),
//                           ShimmerEffect(duration: 500.ms),
//                         ],
//                         child: Text(
//                           languageCode == "E" ? "Login" : "تسجيل الدخول",
//                           style: const TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                             color: Color(
//                               0xFF81C784,
//                             ), // أخضر فاتح (يمكنك تغييره)
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     FadeInUp(
//                       duration: const Duration(milliseconds: 700),
//                       child: Textfield(
//                         controller: emailController,
//                         icons: const Icon(Icons.email_outlined),
//                         labelText:
//                             languageCode == "E" ? 'Email' : "حساب الايميل",
//                         type: TextInputType.emailAddress,
//                         validate: (value) {
//                           if (value == null || value.isEmpty) {
//                             return languageCode == "E"
//                                 ? "empty field"
//                                 : "الحقل فارغ";
//                           }
//                           if (!isValidEmail(value)) {
//                             return languageCode == "E"
//                                 ? "Invalid email"
//                                 : "إيميل غير صحيح";
//                           }
//                           return null;
//                         },
//                         decoration: InputDecoration(
//                           border: const OutlineInputBorder(),
//                           labelText:
//                               languageCode == "E" ? 'Your Email' : " إيميلك",
//                           icon: const Icon(Icons.email_outlined),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     FadeInUp(
//                       duration: const Duration(milliseconds: 900),
//                       child: TextFormField(
//                         controller: passwordController,
//                         keyboardType: TextInputType.text,
//                         obscureText: _obscurePassword,
//                         decoration: InputDecoration(
//                           border: const OutlineInputBorder(),
//                           labelText: languageCode == "E"
//                               ? 'Your Password'
//                               : "كلمة السر",
//                           icon: const Icon(Icons.lock),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_off
//                                   : Icons.visibility,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return languageCode == "E"
//                                 ? "empty field"
//                                 : "الحقل فارغ";
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     BounceInDown(
//                       duration: const Duration(milliseconds: 1000),
//                       child: elvatButton(
//                         text: languageCode == "E" ? 'log in ' : "تسجيل الدخول",
//                         function: () async {
//                           print("🖱️ تم الضغط على زر تسجيل الدخول");
//                           if (formstatePassword.currentState!.validate()) {
//                             print("✅ تم التحقق من صحة النموذج");
//                             Sign_in();
//                           } else {
//                             print("❌ فشل التحقق من صحة النموذج");
//                           }
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Center(
//                       child: FadeIn(
//                         duration: const Duration(milliseconds: 700),
//                         child: Text(
//                           languageCode == "E"
//                               ? "Don't have an account create new one"
//                               : "لا تملك حساباً؟ أنشئ واحداً جديداً",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     FadeInUp(
//                       duration: const Duration(milliseconds: 800),
//                       child: elvatButton(
//                         text:
//                             languageCode == "E" ? 'Sign Up' : "إنشاء حساب جديد",
//                         function: () {
//                           print("🖱️ تم الضغط على زر إنشاء حساب جديد");
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                               builder: (_) => const SignUpApp(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
