// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:patient_project/ConstantURL.dart';
// import 'package:patient_project/PatientsScreen.dart';
// import 'package:patient_project/RequestVacation.dart';
// import 'package:patient_project/cubit/post_cubit_doctor.dart';
// import 'package:patient_project/cubit/post_state_doctor.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:patient_project/models/modelDoctor_appointment.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:patient_project/Login_Screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:patient_project/NewAppointment.dart';
// import 'package:patient_project/PatientsScreen.dart'; // تأكد من المسار الصحيح

// class HomeDoctor extends StatefulWidget {
//   final String token;

//   const HomeDoctor({super.key, required this.token});

//   @override
//   State<HomeDoctor> createState() => _HomeDoctorState();
// }

// class _HomeDoctorState extends State<HomeDoctor> {
//   int selectIndex = 0;
//   bool darkTheme = false;
//   Map<String, dynamic>? userData;
//   bool isLoading = true;
//   final ScrollController _scrollController = ScrollController();

//   final List<String> appbarTitles = [
//     "مواعيد الأطباء",
//     "الملف الشخصي",
//     "سجلات المرضى",
//   ];

//   late final List<Widget> screens = [
//     BlocBuilder<PostCubitDoctor, PostStateDoctor>(
//       builder: (context, state) => _buildBody(state),
//     ),
//     _buildProfilePage(),
//     PatientsScreen(token: widget.token),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchDoctorProfile();
//     _scrollController.addListener(_onScroll);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<PostCubitDoctor>().fetchAppointments(initialLoad: true);
//     });
//   }

//   Future<Map<String, dynamic>> fetchDoctorBalance(String token) async {
//     final response = await http.get(
//       Uri.parse("$baseUrl/doctorBalance"),
//       headers: {
//         "Authorization": "Bearer ${widget.token}",
//         "Accept": "application/json",
//       },
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("فشل في جلب بيانات الدخل");
//     }
//   }

//   Future<void> fetchDoctorProfile() async {
//     try {
//       final url = Uri.parse("$baseUrl/doctor_profile");
//       final response = await http.get(
//         url,
//         headers: {
//           "Authorization": "Bearer ${widget.token}",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           userData = data['doctor_profile'];
//           isLoading = false;
//           print(userData);
//         });
//       } else {
//         throw Exception("فشل في جلب البيانات");
//       }
//     } catch (e) {
//       print("خطأ: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       context.read<PostCubitDoctor>().fetchAppointments(initialLoad: false);
//     }
//   }

//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const Login_Screen()),
//       (route) => false,
//     );
//   }

//   Widget _buildUserProfile() {
//     return MaterialButton(
//       onPressed: () {
//         setState(() {
//           selectIndex = 1;
//         });
//         Navigator.pop(context);
//       },
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(30),
//             child: userData?['image'] != null
//                 ? Image.network(
//                     formatImageUrl(userData!['image']),
//                     fit: BoxFit.cover,
//                     width: 60,
//                     height: 60,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         width: 60,
//                         height: 60,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.person, size: 40),
//                       );
//                     },
//                   )
//                 : Container(
//                     width: 60,
//                     height: 60,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.person, size: 40),
//                   ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userData?['name'] ?? 'Guest',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text("Birth Date: ${userData?['birth_date'] ?? 'N/A'}"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerMenu() {
//     return ListView(
//       padding: EdgeInsets.zero,
//       children: [
//         DrawerHeader(
//           decoration: const BoxDecoration(
//             color: Color.fromARGB(255, 235, 241, 247),
//           ),
//           child: _buildUserProfile(),
//         ),
//         ListTile(
//           leading: const Icon(Icons.logout),
//           title: const Text('تسجيل الخروج'),
//           onTap: _logout,
//         ),
//         SwitchListTile(
//           title: const Text('الوضع الليلي'),
//           value: darkTheme,
//           onChanged: (value) {
//             setState(() {
//               darkTheme = value;
//             });
//           },
//         ),
//         ListTile(
//           leading: const FaIcon(FontAwesomeIcons.umbrellaBeach),
//           title: const Text('Request Vacation'),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (_) => RequestVacation(
//                         token: widget.token,
//                       )),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildAppointmentItem(Appointment appointment, int index) {
//     return AnimationConfiguration.staggeredList(
//       position: index,
//       duration: const Duration(milliseconds: 375),
//       child: SlideAnimation(
//         verticalOffset: 50.0,
//         child: FadeInAnimation(
//           child: Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             elevation: 4,
//             child: ListTile(
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 4),
//                   Text(
//                       '📅 Data: ${DateFormat('yyyy-MM-dd').format(appointment.appointmentTime ?? DateTime.now())}'),
//                   Text('⏰ Time: ${appointment.time}'),
//                 ],
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//               onTap: () {},
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppointmentList(PostLoadedDoctor state) {
//     return AnimationLimiter(
//       child: ListView.builder(
//         controller: _scrollController,
//         itemCount: state.appointments.length + (state.hasReachedMax ? 0 : 1),
//         itemBuilder: (context, index) {
//           if (index >= state.appointments.length) {
//             return const Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Center(child: CircularProgressIndicator()),
//             );
//           }
//           return _buildAppointmentItem(state.appointments[index], index);
//         },
//       ),
//     );
//   }

//   Widget _buildBody(PostStateDoctor state) {
//     if (state is PostInitialDoctor ||
//         (state is PostLoadingDoctor && state.isFirstFetch)) {
//       return ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//         },
//       );
//     } else if (state is PostErrorDoctor) {
//       return Center(child: Text(state.message));
//     } else if (state is PostLoadedDoctor) {
//       return _buildAppointmentList(state);
//     }
//     return const SizedBox.shrink();
//   }

//   Widget _buildProfilePage() {
//     if (isLoading) {
//       return Center(
//         child: Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircleAvatar(radius: 70, backgroundColor: Colors.white),
//               SizedBox(height: 20),
//               Container(width: 200, height: 20, color: Colors.white),
//               SizedBox(height: 10),
//               Container(width: 150, height: 20, color: Colors.white),
//             ],
//           ),
//         ),
//       );
//     }

//     if (userData == null) {
//       return const Center(child: Text("لا توجد بيانات متاحة"));
//     }

//     final certificates = (userData?['certificates'] as List<dynamic>? ?? [])
//         .map((c) => c['name'].toString())
//         .toList();

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: AnimationConfiguration.toStaggeredList(
//           duration: const Duration(milliseconds: 500),
//           childAnimationBuilder: (widget) => SlideAnimation(
//             horizontalOffset: 50,
//             child: FadeInAnimation(child: widget),
//           ),
//           children: [
//             Hero(
//               tag: "doctorImage",
//               child: CircleAvatar(
//                 radius: 70,
//                 backgroundColor: Colors.grey[300],
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(70),
//                   child: userData?['image'] != null
//                       ? Image.network(
//                           formatImageUrl(userData!['image']),
//                           width: 140,
//                           height: 140,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             print('خطأ في تحميل الصورة: $error');
//                             return const Icon(Icons.person,
//                                 size: 70, color: Colors.white);
//                           },
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes !=
//                                         null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                     : null,
//                               ),
//                             );
//                           },
//                         )
//                       : const Icon(Icons.person, size: 70, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Text(
//               userData?['name'] ?? '',
//               style: GoogleFonts.cairo(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Birth Date: ${userData?['birth_date'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 25),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 'الشهادات',
//                 style: GoogleFonts.cairo(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 129, 237, 194),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ...certificates.map((cert) => Card(
//                   color: Colors.green[50],
//                   margin: const EdgeInsets.symmetric(vertical: 5),
//                   child: ListTile(
//                     leading: const Icon(Icons.school,
//                         color: Color.fromARGB(255, 129, 237, 194), size: 30),
//                     title: Text(cert, style: GoogleFonts.cairo(fontSize: 16)),
//                   ),
//                 )),
//             const SizedBox(height: 25),
//             Wrap(
//               alignment: WrapAlignment.center,
//               spacing: 12,
//               runSpacing: 12,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => EditProfileScreen(
//                           name: userData?['name'] ?? '',
//                           birthDate: userData?['birth_date'] ?? '',
//                           imageUrl: formatImageUrl(userData?['image']),
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.edit, color: Colors.white),
//                   label: const Text('تعديل المعلومات'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 129, 237, 194),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                     textStyle: GoogleFonts.cairo(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           appbarTitles[selectIndex],
//           style: GoogleFonts.cairo(
//               color: darkTheme ? Colors.white : Colors.black87),
//         ),
//         backgroundColor: darkTheme
//             ? Colors.grey[800]
//             : const Color.fromARGB(255, 129, 237, 194),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_circle, size: 28),
//             onPressed: () {
//               if (selectIndex == 0) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const NewAppointmentPage()),
//                 );
//               } else if (selectIndex == 2) {
//                 // TODO: هنا يمكنك إضافة كود للانتقال لصفحة إضافة مريض جديد
//               }
//             },
//             color: darkTheme ? Colors.white : Colors.white,
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: darkTheme
//             ? Colors.grey[900]
//             : const Color.fromARGB(255, 235, 241, 247),
//         child: _buildDrawerMenu(),
//       ),
//       body: IndexedStack(
//         index: selectIndex,
//         children: screens,
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 Color(0xFFA8F5C3),
//                 Color(0xFFC4EDD3),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(25),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: GNav(
//             selectedIndex: selectIndex,
//             onTabChange: (index) {
//               setState(() {
//                 selectIndex = index;
//               });
//             },
//             backgroundColor: Colors.transparent,
//             tabBackgroundColor: Colors.white.withOpacity(0.2),
//             gap: 10,
//             activeColor: const Color.fromARGB(255, 129, 237, 194),
//             color: Colors.grey[700],
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//             tabs: const [
//               GButton(
//                 icon: Icons.home,
//                 text: 'Home',
//               ),
//               GButton(
//                 icon: Icons.person,
//                 text: 'Profile',
//               ),
//               GButton(
//                 icon: Icons.people, // تم تغيير الأيقونة لتكون أكثر وضوحاً
//                 text: 'Patients',
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // صفحة تعديل الملف الشخصي
// class EditProfileScreen extends StatelessWidget {
//   final String name;
//   final String birthDate;
//   final String imageUrl;

//   const EditProfileScreen({
//     Key? key,
//     required this.name,
//     required this.birthDate,
//     required this.imageUrl,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("تعديل المعلومات"),
//         backgroundColor: const Color.fromARGB(255, 129, 237, 194),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             Hero(
//               tag: "doctorImage",
//               child: CircleAvatar(
//                 radius: 70,
//                 backgroundImage:
//                     imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
//                 backgroundColor: Colors.grey[300],
//                 child: imageUrl.isEmpty
//                     ? const Icon(Icons.person, size: 70, color: Colors.white)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(name,
//                 style: GoogleFonts.cairo(
//                     fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Text("Birth Date: $birthDate",
//                 style: GoogleFonts.cairo(fontSize: 18)),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:patient_project/ConstantURL.dart';
// import 'package:patient_project/cubit/post_cubit_doctor.dart';
// import 'package:patient_project/cubit/post_state_doctor.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:patient_project/models/modelDoctor_appointment.dart';
// import 'package:patient_project/widget/PatientsScreen.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:patient_project/widget/Login_Screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:patient_project/widget/NewAppointment.dart';

// class HomeDoctor extends StatefulWidget {
//   final String token;
//   const HomeDoctor({super.key, required this.token});
//   @override
//   State<HomeDoctor> createState() => _HomeDoctorState();
// }

// class _HomeDoctorState extends State<HomeDoctor> {
//   int selectIndex = 0;
//   bool darkTheme = false;
//   Map<String, dynamic>? userData;
//   bool isLoading = true;
//   final ScrollController _scrollController = ScrollController();

//   final List<String> appbarTitles = [
//     "Doctor Appointments",
//     "Profile",
//     "Patient Records",
//   ];

//   late final List<Widget> screens = [
//     BlocBuilder<PostCubitDoctor, PostStateDoctor>(
//       builder: (context, state) => _buildBody(state),
//     ),
//     _buildProfilePage(),
//     PatientsScreen(token: widget.token),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchsecretaryProfile();
//     _scrollController.addListener(_onScroll);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<PostCubitDoctor>().fetchAppointments(initialLoad: true);
//     });
//   }

//   Future<void> fetchsecretaryProfile() async {
//     try {
//       final url = Uri.parse("$baseUrl/secretary_profile");
//       final response = await http.get(
//         url,
//         headers: {
//           "Authorization": "Bearer ${widget.token}",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           userData = data['secretary_profile'];
//           isLoading = false;
//           print(userData);
//         });
//       } else {
//         throw Exception("فشل في جلب البيانات");
//       }
//     } catch (e) {
//       print("خطأ: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       context.read<PostCubitDoctor>().fetchAppointments(initialLoad: false);
//     }
//   }

//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const Login_Screen()),
//       (route) => false,
//     );
//   }

//   Widget _buildUserProfile() {
//     return MaterialButton(
//       onPressed: () {
//         setState(() {
//           selectIndex = 1;
//         });
//         Navigator.pop(context);
//       },
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(30),
//             child: userData?['image'] != null
//                 ? Image.network(
//                     formatImageUrl(userData!['image']),
//                     fit: BoxFit.cover,
//                     width: 60,
//                     height: 60,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         width: 60,
//                         height: 60,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.person, size: 40),
//                       );
//                     },
//                   )
//                 : Container(
//                     width: 60,
//                     height: 60,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.person, size: 40),
//                   ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userData?['name'] ?? 'Guest',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text("Birth Date: ${userData?['birth_date'] ?? 'N/A'}"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerMenu() {
//     return ListView(
//       padding: EdgeInsets.zero,
//       children: [
//         DrawerHeader(
//           decoration: const BoxDecoration(
//             color: Color.fromARGB(255, 235, 241, 247),
//           ),
//           child: _buildUserProfile(),
//         ),
//         ListTile(
//           leading: const Icon(Icons.logout),
//           title: const Text('Logout'),
//           onTap: _logout,
//         ),

//       ],
//     );
//   }

//   Widget _buildAppointmentItem(Appointment appointment, int index) {
//     return AnimationConfiguration.staggeredList(
//       position: index,
//       duration: const Duration(milliseconds: 375),
//       child: SlideAnimation(
//         verticalOffset: 50.0,
//         child: FadeInAnimation(
//           child: Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             elevation: 4,
//             child: ListTile(
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 4),
//                   Text(
//                       '📅 Data: ${DateFormat('yyyy-MM-dd').format(appointment.appointmentTime ?? DateTime.now())}'),
//                   Text('⏰ Time: ${appointment.time}'),
//                 ],
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//               onTap: () {},
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppointmentList(PostLoadedDoctor state) {
//     return AnimationLimiter(
//       child: ListView.builder(
//         controller: _scrollController,
//         itemCount: state.appointments.length + (state.hasReachedMax ? 0 : 1),
//         itemBuilder: (context, index) {
//           if (index >= state.appointments.length) {
//             return const Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Center(child: CircularProgressIndicator()),
//             );
//           }
//           return _buildAppointmentItem(state.appointments[index], index);
//         },
//       ),
//     );
//   }

//   Widget _buildBody(PostStateDoctor state) {
//     if (state is PostInitialDoctor ||
//         (state is PostLoadingDoctor && state.isFirstFetch)) {
//       return ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//         },
//       );
//     } else if (state is PostErrorDoctor) {
//       return Center(child: Text(state.message));
//     } else if (state is PostLoadedDoctor) {
//       return _buildAppointmentList(state);
//     }
//     return const SizedBox.shrink();
//   }

//   Widget _buildProfilePage() {
//     if (isLoading) {
//       return Center(
//         child: Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircleAvatar(radius: 70, backgroundColor: Colors.white),
//               SizedBox(height: 20),
//               Container(width: 200, height: 20, color: Colors.white),
//               SizedBox(height: 10),
//               Container(width: 150, height: 20, color: Colors.white),
//             ],
//           ),
//         ),
//       );
//     }

//     if (userData == null) {
//       return const Center(child: Text("No Data Available"));
//     }

//     final certificates = (userData?['certificates'] as List<dynamic>? ?? [])
//         .map((c) => c['name'].toString())
//         .toList();

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: AnimationConfiguration.toStaggeredList(
//           duration: const Duration(milliseconds: 500),
//           childAnimationBuilder: (widget) => SlideAnimation(
//             horizontalOffset: 50,
//             child: FadeInAnimation(child: widget),
//           ),
//           children: [
//             Hero(
//               tag: "secretaryImage",
//               child: CircleAvatar(
//                 radius: 70,
//                 backgroundColor: Colors.grey[300],
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(70),
//                   child: userData?['image'] != null
//                       ? Image.network(
//                           formatImageUrl(userData!['image']),
//                           width: 140,
//                           height: 140,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             print('خطأ في تحميل الصورة: $error');
//                             return const Icon(Icons.person,
//                                 size: 70, color: Colors.white);
//                           },
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes !=
//                                         null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                     : null,
//                               ),
//                             );
//                           },
//                         )
//                       : const Icon(Icons.person, size: 70, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Text(
//               userData?['name'] ?? '',
//               style: GoogleFonts.cairo(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Birth Date: ${userData?['birth_date'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 25),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 'Certificates',
//                 style: GoogleFonts.cairo(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 129, 237, 194),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ...certificates.map((cert) => Card(
//                   color: Colors.green[50],
//                   margin: const EdgeInsets.symmetric(vertical: 5),
//                   child: ListTile(
//                     leading: const Icon(Icons.school,
//                         color: Color.fromARGB(255, 129, 237, 194), size: 30),
//                     title: Text(cert, style: GoogleFonts.cairo(fontSize: 16)),
//                   ),
//                 )),
//             const SizedBox(height: 25),
//             Wrap(
//               alignment: WrapAlignment.center,
//               spacing: 12,
//               runSpacing: 12,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => EditProfileScreen(
//                           name: userData?['name'] ?? '',
//                           birthDate: userData?['birth_date'] ?? '',
//                           imageUrl: formatImageUrl(userData?['image']),
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.edit, color: Colors.white),
//                   label: const Text('Update Profile'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color.fromARGB(255, 129, 237, 194),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                     textStyle: GoogleFonts.cairo(
//                         fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           appbarTitles[selectIndex],
//           style: GoogleFonts.cairo(
//               color: darkTheme ? Colors.white : Colors.black87),
//         ),
//         backgroundColor: darkTheme
//             ? Colors.grey[800]
//             : const Color.fromARGB(255, 129, 237, 194),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_circle, size: 28),
//             onPressed: () {
//               if (selectIndex == 0) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const NewAppointmentPage()),
//                 );
//               } else if (selectIndex == 2) {
//                 // TODO: هنا يمكنك إضافة كود للانتقال لصفحة إضافة مريض جديد
//               }
//             },
//             color: darkTheme ? Colors.white : Colors.white,
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: darkTheme
//             ? Colors.grey[900]
//             : const Color.fromARGB(255, 235, 241, 247),
//         child: _buildDrawerMenu(),
//       ),
//       body: IndexedStack(
//         index: selectIndex,
//         children: screens,
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 Color(0xFFA8F5C3),
//                 Color(0xFFC4EDD3),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(25),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: GNav(
//             selectedIndex: selectIndex,
//             onTabChange: (index) {
//               setState(() {
//                 selectIndex = index;
//               });
//             },
//             backgroundColor: Colors.transparent,
//             tabBackgroundColor: Colors.white.withOpacity(0.2),
//             gap: 1,
//             activeColor: const Color.fromARGB(255, 129, 237, 194),
//             color: Colors.grey[700],
//             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//             tabs: const [
//               GButton(
//                 icon: Icons.home,
//                 text: 'Home',
//               ),
//               GButton(
//                 icon: Icons.person,
//                 text: 'Profile',
//               ),
//               GButton(
//                 icon: Icons.people,
//                 text: 'Patients',
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// صفحة تعديل الملف الشخصي
// class EditProfileScreen extends StatelessWidget {
//   final String name;
//   final String birthDate;
//   final String imageUrl;

//   const EditProfileScreen({
//     Key? key,
//     required this.name,
//     required this.birthDate,
//     required this.imageUrl,
//   }) : super(key: key);

@override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Update Profile"),
//         backgroundColor: const Color.fromARGB(255, 129, 237, 194),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             Hero(
//               tag: "secretaryImage",
//               child: CircleAvatar(
//                 radius: 70,
//                 backgroundImage:
//                     imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
//                 backgroundColor: Colors.grey[300],
//                 child: imageUrl.isEmpty
//                     ? const Icon(Icons.person, size: 70, color: Colors.white)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(name,
//                 style: GoogleFonts.cairo(
//                     fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Text("Birth Date: $birthDate",
//                 style: GoogleFonts.cairo(fontSize: 18)),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:patient_project/ConstantURL.dart';
// import 'package:patient_project/cubit/post_cubit_doctor.dart';
// import 'package:patient_project/cubit/post_state_doctor.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:patient_project/models/modelDoctor_appointment.dart';
// import 'package:patient_project/widget/AddMedicalRecordPage.dart';
// import 'package:patient_project/widget/PatientsScreen.dart';
// import 'package:patient_project/widget/UnpaidTreatmentsScreen.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:patient_project/widget/Login_Screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:patient_project/widget/NewAppointment.dart';

// // Helper function to format image URL
// String formatImageUrl(String? path) {
//   if (path == null) {
//     return '';
//   }
//   return path.startsWith('http') ? path : '$baseUrl/storage/$path';
// }

// class HomeDoctor extends StatefulWidget {
//   final String token;
//   const HomeDoctor({super.key, required this.token});
//   @override
//   State<HomeDoctor> createState() => _HomeDoctorState();
// }

// class _HomeDoctorState extends State<HomeDoctor> {
//   int selectIndex = 0;
//   bool darkTheme = false;
//   Map<String, dynamic>? userData;
//   bool isLoading = true;
//   final ScrollController _scrollController = ScrollController();

//   final List<String> appbarTitles = [
//     "Doctor Appointments",
//     "Profile",
//     "Patient Records",
//     "Unpaid Bills",
//   ];

//   late final List<Widget> screens = [
//     BlocBuilder<PostCubitDoctor, PostStateDoctor>(
//       builder: (context, state) => _buildBody(state),
//     ),
//     _buildProfilePage(),
//     PatientsScreen(token: widget.token),
//     UnpaidTreatmentsScreen(token: widget.token),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchsecretaryProfile();
//     _scrollController.addListener(_onScroll);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<PostCubitDoctor>().fetchAppointments(initialLoad: true);
//     });
//   }

//   Future<void> fetchsecretaryProfile() async {
//     try {
//       final url = Uri.parse("$baseUrl/secretary_profile");
//       final response = await http.get(
//         url,
//         headers: {
//           "Authorization": "Bearer ${widget.token}",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           userData = data['secretary_profile'];
//           isLoading = false;
//           print(userData);
//         });
//       } else {
//         throw Exception("Failed to fetch data");
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       context.read<PostCubitDoctor>().fetchAppointments(initialLoad: false);
//     }
//   }

//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const Login_Screen()),
//       (route) => false,
//     );
//   }

//   Widget _buildSecretaryProfile() {
//     return MaterialButton(
//       onPressed: () {
//         setState(() {
//           selectIndex = 1;
//         });
//         Navigator.pop(context);
//       },
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(30),
//             child: userData?['image'] != null
//                 ? Image.network(
//                     formatImageUrl(userData!['image']),
//                     fit: BoxFit.cover,
//                     width: 60,
//                     height: 60,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         width: 60,
//                         height: 60,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.person, size: 40),
//                       );
//                     },
//                   )
//                 : Container(
//                     width: 60,
//                     height: 60,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.person, size: 40),
//                   ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userData?['name'] ?? 'Guest',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text("Birth Date: ${userData?['birth_date'] ?? 'N/A'}"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerMenu() {
//     return ListView(
//       padding: EdgeInsets.zero,
//       children: [
//         DrawerHeader(
//           decoration: const BoxDecoration(
//             color: Color.fromARGB(255, 235, 241, 247),
//           ),
//           child: _buildSecretaryProfile(),
//         ),
//         ListTile(
//           leading: const Icon(Icons.logout),
//           title: const Text('Logout'),
//           onTap: _logout,
//         ),
//       ],
//     );
//   }

//   Widget _buildAppointmentItem(Appointment appointment, int index) {
//     return AnimationConfiguration.staggeredList(
//       position: index,
//       duration: const Duration(milliseconds: 375),
//       child: SlideAnimation(
//         verticalOffset: 50.0,
//         child: FadeInAnimation(
//           child: Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             elevation: 4,
//             child: ListTile(
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 4),
//                   Text(
//                       '📅 Data: ${DateFormat('yyyy-MM-dd').format(appointment.appointmentTime ?? DateTime.now())}'),
//                   Text('⏰ Time: ${appointment.time}'),
//                 ],
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//               onTap: () {},
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppointmentList(PostLoadedDoctor state) {
//     return AnimationLimiter(
//       child: ListView.builder(
//         controller: _scrollController,
//         itemCount: state.appointments.length + (state.hasReachedMax ? 0 : 1),
//         itemBuilder: (context, index) {
//           if (index >= state.appointments.length) {
//             return const Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Center(child: CircularProgressIndicator()),
//             );
//           }
//           return _buildAppointmentItem(state.appointments[index], index);
//         },
//       ),
//     );
//   }

//   Widget _buildBody(PostStateDoctor state) {
//     if (state is PostInitialDoctor ||
//         (state is PostLoadingDoctor && state.isFirstFetch)) {
//       return ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//         },
//       );
//     } else if (state is PostErrorDoctor) {
//       return Center(child: Text(state.message));
//     } else if (state is PostLoadedDoctor) {
//       return _buildAppointmentList(state);
//     }
//     return const SizedBox.shrink();
//   }

//   Widget _buildProfilePage() {
//     if (isLoading) {
//       return Center(
//         child: Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircleAvatar(radius: 70, backgroundColor: Colors.white),
//               SizedBox(height: 20),
//               Container(width: 200, height: 20, color: Colors.white),
//               SizedBox(height: 10),
//               Container(width: 150, height: 20, color: Colors.white),
//             ],
//           ),
//         ),
//       );
//     }

//     if (userData == null) {
//       return const Center(child: Text("No Data Available"));
//     }

//     final certificates = (userData?['certificates'] as List<dynamic>? ?? [])
//         .map((c) => c['name'].toString())
//         .toList();

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: AnimationConfiguration.toStaggeredList(
//           duration: const Duration(milliseconds: 500),
//           childAnimationBuilder: (widget) => SlideAnimation(
//             horizontalOffset: 50,
//             child: FadeInAnimation(child: widget),
//           ),
//           children: [
//             Hero(
//               tag: "secretaryImage",
//               child: CircleAvatar(
//                 radius: 70,
//                 backgroundColor: Colors.grey[300],
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(70),
//                   child: userData?['image'] != null
//                       ? Image.network(
//                           formatImageUrl(userData!['image']),
//                           width: 140,
//                           height: 140,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             print('Error loading image: $error');
//                             return const Icon(Icons.person,
//                                 size: 70, color: Colors.white);
//                           },
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes !=
//                                         null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                     : null,
//                               ),
//                             );
//                           },
//                         )
//                       : const Icon(Icons.person, size: 70, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Text(
//               userData?['name'] ?? '',
//               style: GoogleFonts.cairo(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Birth Date: ${userData?['birth_date'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Shift: ${userData?['shift'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Salary: ${userData?['salary'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Vaccation Number: ${userData?['vaccation_number'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 25),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 'Certificates',
//                 style: GoogleFonts.cairo(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 129, 237, 194),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ...certificates.map((cert) => Card(
//                   color: Colors.green[50],
//                   margin: const EdgeInsets.symmetric(vertical: 5),
//                   child: ListTile(
//                     leading: const Icon(Icons.school,
//                         color: Color.fromARGB(255, 129, 237, 194), size: 30),
//                     title: Text(cert, style: GoogleFonts.cairo(fontSize: 16)),
//                   ),
//                 )),
//             const SizedBox(height: 25),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           appbarTitles[selectIndex],
//           style: GoogleFonts.cairo(
//               color: darkTheme ? Colors.white : Colors.black87),
//         ),
//         backgroundColor: darkTheme
//             ? Colors.grey[800]
//             : const Color.fromARGB(255, 129, 237, 194),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_circle, size: 28),
//             onPressed: () {
//               if (selectIndex == 0) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const NewAppointmentPage()),
//                 );
//               } else if (selectIndex == 2) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         AddMedicalRecordPage(token: widget.token),
//                   ),
//                 );
//               }
//             },
//             color: darkTheme ? Colors.white : Colors.white,
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: darkTheme
//             ? Colors.grey[900]
//             : const Color.fromARGB(255, 235, 241, 247),
//         child: _buildDrawerMenu(),
//       ),
//       body: IndexedStack(
//         index: selectIndex,
//         children: screens,
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 Color(0xFFA8F5C3),
//                 Color(0xFFC4EDD3),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(25),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: GNav(
//             selectedIndex: selectIndex,
//             onTabChange: (index) {
//               setState(() {
//                 selectIndex = index;
//               });
//             },
//             backgroundColor: Colors.transparent,
//             tabBackgroundColor: Colors.white.withOpacity(0.2),
//             gap: 8,
//             activeColor: const Color.fromARGB(255, 129, 237, 194),
//             color: Colors.grey[700],
//             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//             mainAxisAlignment: MainAxisAlignment.center,
//             tabs: const [
//               GButton(
//                 icon: Icons.home,
//                 text: 'Home',
//               ),
//               GButton(
//                 icon: Icons.person,
//                 text: 'Profile',
//               ),
//               GButton(
//                 icon: Icons.people,
//                 text: 'Patients',
//               ),
//               GButton(
//                 icon: Icons.request_page_outlined,
//                 text: 'Bills',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:patient_project/ConstantURL.dart';
// import 'package:patient_project/cubit/post_cubit_doctor.dart';
// import 'package:patient_project/cubit/post_state_doctor.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:patient_project/models/modelDoctor_appointment.dart';
// import 'package:patient_project/widget/AddMedicalRecordPage.dart';
// import 'package:patient_project/widget/PatientsScreen.dart';
// import 'package:patient_project/widget/UnpaidTreatmentsScreen.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:patient_project/widget/Login_Screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:patient_project/widget/NewAppointment.dart';

// // Helper function to format image URL
// String formatImageUrl(String? path) {
//   if (path == null) {
//     return '';
//   }
//   return path.startsWith('http') ? path : '$baseUrl/storage/$path';
// }

// class HomeDoctor extends StatefulWidget {
//   final String token;
//   const HomeDoctor({super.key, required this.token});
//   @override
//   State<HomeDoctor> createState() => _HomeDoctorState();
// }

// class _HomeDoctorState extends State<HomeDoctor> {
//   int selectIndex = 0;
//   bool darkTheme = false;
//   Map<String, dynamic>? userData;
//   bool isLoading = true;
//   final ScrollController _scrollController = ScrollController();

//   final List<String> appbarTitles = [
//     "Doctor Appointments",
//     "Profile",
//     "Patient Records",
//     "Unpaid Bills",
//   ];

//   late final List<Widget> screens = [
//     BlocBuilder<PostCubitDoctor, PostStateDoctor>(
//       builder: (context, state) => _buildBody(state),
//     ),
//     _buildProfilePage(),
//     PatientsScreen(token: widget.token),
//     UnpaidTreatmentsScreen(token: widget.token),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchsecretaryProfile();
//     _scrollController.addListener(_onScroll);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<PostCubitDoctor>().fetchAppointments(initialLoad: true);
//     });
//   }

//   Future<void> fetchsecretaryProfile() async {
//     try {
//       final url = Uri.parse("$baseUrl/secretary_profile");
//       final response = await http.get(
//         url,
//         headers: {
//           "Authorization": "Bearer ${widget.token}",
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           userData = data['secretary_profile'];
//           isLoading = false;
//           print("Profile Data fetched successfully: $userData");
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         throw Exception("Failed to fetch data: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Error fetching profile: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       context.read<PostCubitDoctor>().fetchAppointments(initialLoad: false);
//     }
//   }

//   Future<void> _logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (_) => const Login_Screen()),
//       (route) => false,
//     );
//   }

//   Widget _buildSecretaryProfile() {
//     return MaterialButton(
//       onPressed: () {
//         setState(() {
//           selectIndex = 1;
//         });
//         Navigator.pop(context);
//       },
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(30),
//             child: userData?['image'] != null
//                 ? Image.network(
//                     formatImageUrl(userData!['image']),
//                     fit: BoxFit.cover,
//                     width: 60,
//                     height: 60,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         width: 60,
//                         height: 60,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.person, size: 40),
//                       );
//                     },
//                   )
//                 : Container(
//                     width: 60,
//                     height: 60,
//                     color: Colors.grey[300],
//                     child: const Icon(Icons.person, size: 40),
//                   ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   userData?['name'] ?? 'Guest',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text("Birth Date: ${userData?['birth_date'] ?? 'N/A'}"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerMenu() {
//     return ListView(
//       padding: EdgeInsets.zero,
//       children: [
//         DrawerHeader(
//           decoration: const BoxDecoration(
//             color: Color.fromARGB(255, 235, 241, 247),
//           ),
//           child: _buildSecretaryProfile(),
//         ),
//         ListTile(
//           leading: const Icon(Icons.logout),
//           title: const Text('Logout'),
//           onTap: _logout,
//         ),
//       ],
//     );
//   }

//   Widget _buildAppointmentItem(Appointment appointment, int index) {
//     return AnimationConfiguration.staggeredList(
//       position: index,
//       duration: const Duration(milliseconds: 375),
//       child: SlideAnimation(
//         verticalOffset: 50.0,
//         child: FadeInAnimation(
//           child: Card(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             elevation: 4,
//             child: ListTile(
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 4),
//                   Text(
//                       '📅 Data: ${DateFormat('yyyy-MM-dd').format(appointment.appointmentTime ?? DateTime.now())}'),
//                   Text('⏰ Time: ${appointment.time}'),
//                 ],
//               ),
//               trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//               onTap: () {},
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAppointmentList(PostLoadedDoctor state) {
//     return AnimationLimiter(
//       child: ListView.builder(
//         controller: _scrollController,
//         itemCount: state.appointments.length + (state.hasReachedMax ? 0 : 1),
//         itemBuilder: (context, index) {
//           if (index >= state.appointments.length) {
//             return const Padding(
//               padding: EdgeInsets.symmetric(vertical: 20),
//               child: Center(child: CircularProgressIndicator()),
//             );
//           }
//           return _buildAppointmentItem(state.appointments[index], index);
//         },
//       ),
//     );
//   }

//   Widget _buildBody(PostStateDoctor state) {
//     if (state is PostInitialDoctor ||
//         (state is PostLoadingDoctor && state.isFirstFetch)) {
//       return ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               height: 80,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//         },
//       );
//     } else if (state is PostErrorDoctor) {
//       return Center(child: Text(state.message));
//     } else if (state is PostLoadedDoctor) {
//       return _buildAppointmentList(state);
//     }
//     return const SizedBox.shrink();
//   }

//   Widget _buildProfilePage() {
//     if (isLoading) {
//       return Center(
//         child: Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircleAvatar(radius: 70, backgroundColor: Colors.white),
//               SizedBox(height: 20),
//               Container(width: 200, height: 20, color: Colors.white),
//               SizedBox(height: 10),
//               Container(width: 150, height: 20, color: Colors.white),
//             ],
//           ),
//         ),
//       );
//     }

//     if (userData == null) {
//       return const Center(child: Text("No Data Available"));
//     }

//     final certificates = (userData?['certificates'] as List<dynamic>? ?? [])
//         .map((c) => c['name'].toString())
//         .toList();

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: AnimationConfiguration.toStaggeredList(
//           duration: const Duration(milliseconds: 500),
//           childAnimationBuilder: (widget) => SlideAnimation(
//             horizontalOffset: 50,
//             child: FadeInAnimation(child: widget),
//           ),
//           children: [
//             Hero(
//               tag: "secretaryImage",
//               child: CircleAvatar(
//                 radius: 70,
//                 backgroundColor: Colors.grey[300],
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(70),
//                   child: userData?['image'] != null
//                       ? Image.network(
//                           formatImageUrl(userData!['image']),
//                           width: 140,
//                           height: 140,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             print('Error loading image: $error');
//                             return const Icon(Icons.person,
//                                 size: 70, color: Colors.white);
//                           },
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes !=
//                                         null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                     : null,
//                               ),
//                             );
//                           },
//                         )
//                       : const Icon(Icons.person, size: 70, color: Colors.white),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             Text(
//               userData?['name'] ?? '',
//               style: GoogleFonts.cairo(
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Birth Date: ${userData?['birth_date'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Shift: ${userData?['shift'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Salary: ${userData?['salary'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "Vaccation Number: ${userData?['vaccation_number'] ?? ''}",
//               style: GoogleFonts.cairo(
//                 fontSize: 18,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 25),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 'Certificates',
//                 style: GoogleFonts.cairo(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: const Color.fromARGB(255, 129, 237, 194),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ...certificates.map((cert) => Card(
//                   color: Colors.green[50],
//                   margin: const EdgeInsets.symmetric(vertical: 5),
//                   child: ListTile(
//                     leading: const Icon(Icons.school,
//                         color: Color.fromARGB(255, 129, 237, 194), size: 30),
//                     title: Text(cert, style: GoogleFonts.cairo(fontSize: 16)),
//                   ),
//                 )),
//             const SizedBox(height: 25),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           appbarTitles[selectIndex],
//           style: GoogleFonts.cairo(
//               color: darkTheme ? Colors.white : Colors.black87),
//         ),
//         backgroundColor: darkTheme
//             ? Colors.grey[800]
//             : const Color.fromARGB(255, 129, 237, 194),
//         elevation: 0,
//         actions: [
//           if (selectIndex == 0 || selectIndex == 2)
//             IconButton(
//               icon: const Icon(Icons.add_circle, size: 28),
//               onPressed: () {
//                 if (selectIndex == 0) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const NewAppointmentPage()),
//                   );
//                 } else if (selectIndex == 2) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           AddMedicalRecordPage(token: widget.token),
//                     ),
//                   );
//                 }
//               },
//               color: darkTheme ? Colors.white : Colors.white,
//             ),
//         ],
//       ),
//       drawer: Drawer(
//         backgroundColor: darkTheme
//             ? Colors.grey[900]
//             : const Color.fromARGB(255, 235, 241, 247),
//         child: _buildDrawerMenu(),
//       ),
//       body: IndexedStack(
//         index: selectIndex,
//         children: screens,
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [
//                 Color(0xFFA8F5C3),
//                 Color(0xFFC4EDD3),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(25),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: GNav(
//             selectedIndex: selectIndex,
//             onTabChange: (index) {
//               setState(() {
//                 selectIndex = index;
//               });
//             },
//             backgroundColor: Colors.transparent,
//             tabBackgroundColor: Colors.white.withOpacity(0.2),
//             gap: 8,
//             activeColor: const Color.fromARGB(255, 129, 237, 194),
//             color: Colors.grey[700],
//             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//             mainAxisAlignment: MainAxisAlignment.center,
//             tabs: const [
//               GButton(
//                 icon: Icons.home,
//                 text: 'Home',
//               ),
//               GButton(
//                 icon: Icons.person,
//                 text: 'Profile',
//               ),
//               GButton(
//                 icon: Icons.people,
//                 text: 'Patients',
//               ),
//               GButton(
//                 icon: Icons.request_page_outlined,
//                 text: 'Bills',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_project/ConstantURL.dart';
import 'package:patient_project/cubit/post_cubit_Secretary.dart';
import 'package:patient_project/cubit/post_state_Secretary.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient_project/models/modelSecretary_appointment.dart';
import 'package:patient_project/screens/pages.dart';
import 'package:patient_project/widget/AddMedicalRecordPage.dart';
import 'package:patient_project/widget/AppointmentDetailsScreen.dart';
import 'package:patient_project/widget/PatientsScreen.dart';
import 'package:patient_project/widget/UnpaidTreatmentsScreen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:patient_project/widget/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:patient_project/widget/NewAppointment.dart';
// <--- استيراد الشاشة الجديدة

// Helper function to format image URL
String formatImageUrl(String? path) {
  if (path == null) {
    return '';
  }
  return path.startsWith('http') ? path : '$baseUrl/storage/$path';
}

class Homesecretary extends StatefulWidget {
  final String token;
  const Homesecretary({super.key, required this.token});
  @override
  State<Homesecretary> createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<Homesecretary> {
  int selectIndex = 0;
  bool darkTheme = false;
  // قم بإزالة المتغيرات المتعلقة بالبروفايل من هنا
  // Map<String, dynamic>? userData;
  // bool isLoading = true;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  final ScrollController _scrollController = ScrollController();

  final List<String> appbarTitles = [
    "Doctor Appointments",
    "Profile",
    "Patient Records",
    "Unpaid Bills",
  ];

  late final List<Widget> screens = [
    BlocBuilder<PostCubitDoctor, PostStateDoctor>(
      builder: (context, state) => _buildBody(state),
    ),
    ProfileScreen(token: widget.token), // <--- استخدام الـ Widget الجديد
    PatientsScreen(token: widget.token),
    UnpaidTreatmentsScreen(token: widget.token),
  ];

  @override
  void initState() {
    super.initState();
    // قم باستدعاء الدالة لجلب البيانات للـ Drawer فقط
    fetchsecretaryProfile();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostCubitDoctor>().fetchAppointments(initialLoad: true);
    });
  }

  // ابق على هذه الدالة فقط لجلب بيانات الـ Drawer
  Future<void> fetchsecretaryProfile() async {
    try {
      final url = Uri.parse("$baseUrl/secretary_profile");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userData = data['secretary_profile'];
          isLoading = false;
          print("Drawer Profile Data fetched: $userData");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Failed to fetch drawer data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching drawer profile: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PostCubitDoctor>().fetchAppointments(initialLoad: false);
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreenN()),
      (route) => false,
    );
  }

  Widget _buildSecretaryProfile() {
    return MaterialButton(
      onPressed: () {
        setState(() {
          selectIndex = 1;
        });
        Navigator.pop(context);
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: userData?['image'] != null
                ? Image.network(
                    formatImageUrl(userData!['image']),
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 40),
                      );
                    },
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 40),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData?['name'] ?? 'Guest',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Birth Date: ${userData?['birth_date'] ?? 'N/A'}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerMenu() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 235, 241, 247),
          ),
          child: _buildSecretaryProfile(),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: _logout,
        ),
      ],
    );
  }

  Widget _buildAppointmentItem(Appointment appointment, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                      '📅 Data: ${DateFormat('yyyy-MM-dd').format(appointment.appointmentTime ?? DateTime.now())}'),
                  Text('⏰ Time: ${appointment.time}'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AppointmentDetailsScreen(appointment: appointment),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(PostLoadedDoctor state) {
    return AnimationLimiter(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.appointments.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.appointments.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return _buildAppointmentItem(state.appointments[index], index);
        },
      ),
    );
  }

  Widget _buildBody(PostStateDoctor state) {
    if (state is PostInitialDoctor ||
        (state is PostLoadingDoctor && state.isFirstFetch)) {
      return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      );
    } else if (state is PostErrorDoctor) {
      return Center(child: Text(state.message));
    } else if (state is PostLoadedDoctor) {
      return _buildAppointmentList(state);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appbarTitles[selectIndex],
          style: GoogleFonts.cairo(
              color: darkTheme ? Colors.white : Colors.black87),
        ),
        backgroundColor: darkTheme
            ? Colors.grey[800]
            : const Color.fromARGB(255, 129, 237, 194),
        elevation: 0,
        actions: [
          if (selectIndex == 0 || selectIndex == 2)
            IconButton(
              icon: const Icon(Icons.add_circle, size: 28),
              onPressed: () {
                if (selectIndex == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewAppointmentPage()),
                  );
                } else if (selectIndex == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddMedicalRecordPage(token: widget.token),
                    ),
                  );
                }
              },
              color: darkTheme ? Colors.white : Colors.white,
            ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: darkTheme
            ? Colors.grey[900]
            : const Color.fromARGB(255, 235, 241, 247),
        child: _buildDrawerMenu(),
      ),
      body: IndexedStack(
        index: selectIndex,
        children: screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFA8F5C3),
                Color(0xFFC4EDD3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: GNav(
            selectedIndex: selectIndex,
            onTabChange: (index) {
              setState(() {
                selectIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            tabBackgroundColor: Colors.white.withOpacity(0.2),
            gap: 8,
            activeColor: const Color.fromARGB(255, 129, 237, 194),
            color: Colors.grey[700],
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            mainAxisAlignment: MainAxisAlignment.center,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
              GButton(
                icon: Icons.people,
                text: 'Patients',
              ),
              GButton(
                icon: Icons.request_page_outlined,
                text: 'Bills',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
