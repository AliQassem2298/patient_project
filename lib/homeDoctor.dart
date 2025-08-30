import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_project/ConstantURL.dart';
import 'package:patient_project/cubit/post_cubit_doctor.dart';
import 'package:patient_project/cubit/post_state_doctor.dart';
import 'package:patient_project/models/modelDoctor_appointment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:patient_project/patient_profile_screen.dart';
import 'package:patient_project/screens/pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:path_provider/path_provider.dart';
import 'RequestNewContract.dart';
import 'RequestVacation.dart';

class HomeDoctor extends StatefulWidget {
  final String token;

  const HomeDoctor({super.key, required this.token});

  @override
  State<HomeDoctor> createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<HomeDoctor> {
  int selectIndex = 0;
  bool darkTheme = false;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  int _unreadCount = 0;
  Timer? _timer;
  final List<dynamic> _notifications = [];
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDoctorProfile();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostCubitDoctor>().fetchAppointments(initialLoad: true);
    });

    _fetchUnreadCount();

    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchUnreadCount();
    });
  }

  Future<List<dynamic>> fetchNotifications(String token) async {
    final url = Uri.parse(
        '$baseUrl/api/getNotifications'); // استبدل الرابط برابط الواجهة الخلفية الخاص بك

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> notifications = jsonDecode(response.body);
        return notifications;
      } else {
        // التعامل مع الأخطاء
        print(
            'Failed to load notifications. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // التعامل مع أخطاء الاتصال بالإنترنت
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchDoctorBalance(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/doctorBalance"),
      headers: {
        "Authorization": "Bearer ${widget.token}",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("فشل في جلب بيانات الدخل");
    }
  }

  Future<void> fetchDoctorProfile() async {
    try {
      final url = Uri.parse("$baseUrl/api/doctor_profile");
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
          userData = data['doctor_profile'];
          isLoading = false;
          print(userData);
        });
      } else {
        throw Exception("فشل في جلب البيانات");
      }
    } catch (e) {
      print("خطأ: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel(); // ✨ إلغاء المؤقت عند إغلاق الواجهة
    super.dispose();
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/unread"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final count = data[0] as int;
        if (mounted) {
          setState(() {
            _unreadCount = count;
          });
        }
      }
    } catch (e) {
      debugPrint("❌ خطأ في جلب عدد الإشعارات: $e");
    }
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

  Widget _buildUserProfile() {
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
          child: _buildUserProfile(),
        ),
        ListTile(
          leading: const FaIcon(
            FontAwesomeIcons.umbrellaBeach,
            color: Color.fromARGB(255, 129, 237, 194),
          ),
          title: const Text('Request Vacation'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => RequestVacation(
                        token: widget.token,
                      )),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.assignment,
            color: Color.fromARGB(255, 129, 237, 194),
          ), // أيقونة العقد
          title: const Text('Request New Contract'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => RequestNewContract(token: widget.token)),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Color.fromARGB(255, 129, 237, 194),
          ),
          title: const Text('تسجيل الخروج'),
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
              title: Text(appointment.patient.name ?? 'null',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                      '📅 Data: ${DateFormat('yyyy-MM-dd').format(appointment.appointmentTime)}'),
                  Text('⏰ Time: ${appointment.time}'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetailsPage(
                      patientId: appointment.patientId,
                      token: widget.token,
                      doctor_id: appointment.doctorId,
                      appointment_id1: appointment.id,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  //
  // Widget _buildAppointmentItem(Appointment appointment, int index) {
  //   return AnimationConfiguration.staggeredList(
  //     position: index,
  //     duration: const Duration(milliseconds: 375),
  //     child: SlideAnimation(
  //       verticalOffset: 50.0,
  //       child: FadeInAnimation(
  //         child: Card(
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //           elevation: 4,
  //           child: ListTile(
  //             contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             title: Text(appointment.patient.name ?? 'null',
  //                 style: const TextStyle(fontWeight: FontWeight.bold)),
  //             subtitle: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const SizedBox(height: 4),
  //                 Text('📅 Date: ${DateFormat('yyyy-MM-dd').format(appointment.appointmentTime)}'),
  //                 Text('⏰ Time: ${appointment.time}'),
  //               ],
  //             ),
  //             trailing: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 IconButton(
  //                   icon: const Icon(Icons.delete, color: Colors.red),
  //                   onPressed: () {
  //                     // Show confirmation dialog before deleting
  //                     AwesomeDialog(
  //                       context: context,
  //                       dialogType: DialogType.warning,
  //                       animType: AnimType.scale,
  //                       title: 'Delete Confirmation',
  //                       desc: 'Are you sure you want to delete this appointment?',
  //                       btnCancelOnPress: () {},
  //                       btnOkOnPress: () async {
  //                         // Send delete request to server
  //                         final response = await http.post(
  //                           Uri.parse('$baseUrl/api/deleteAppointment'),
  //                           headers: {
  //                             'Authorization': 'Bearer ${widget.token}',
  //                             'Content-Type': 'application/json',
  //                           },
  //                           body: json.encode({
  //                             'appointment_id': appointment.id,
  //                           }),
  //                         );
  //
  //                         if (response.statusCode == 200) {
  //                           setState(() {
  //                             appointment.removeAt(index);
  //                           });
  //
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             const SnackBar(content: Text("Appointment deleted successfully")),
  //                           );
  //                         } else {
  //                           final data = json.decode(response.body);
  //                           ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(content: Text(data['message'] ?? "Failed to delete")),
  //                           );
  //                         }
  //                       },
  //                     ).show();
  //                   },
  //                 ),
  //                 const Icon(Icons.arrow_forward_ios, size: 18),
  //               ],
  //             ),
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => PatientDetailsPage(
  //                     patientId: appointment.patientId,
  //                     token: widget.token,
  //                     doctor_id: appointment.doctorId,
  //                     appointment_id1: appointment.id,
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

  Widget _buildProfilePage() {
    if (isLoading) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 70, backgroundColor: Colors.white),
              const SizedBox(height: 20),
              Container(width: 200, height: 20, color: Colors.white),
              const SizedBox(height: 10),
              Container(width: 150, height: 20, color: Colors.white),
            ],
          ),
        ),
      );
    }

    if (userData == null) {
      return const Center(child: Text("لا توجد بيانات متاحة"));
    }

    final certificates = (userData?['certificates'] as List<dynamic>? ?? [])
        .map((c) => c['name'].toString())
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            // صورة الطبيب
            Hero(
              tag: "doctorImage",
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[300],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: userData?['image'] != null
                      ? Image.network(
                          formatImageUrl(userData!['image']),
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('خطأ في تحميل الصورة: $error');
                            return const Icon(Icons.person,
                                size: 70, color: Colors.white);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : const Icon(Icons.person, size: 70, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // الاسم
            Text(
              userData?['name'] ?? '',
              style: GoogleFonts.cairo(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              "Birth Date: ${userData?['birth_date'] ?? ''}",
              style: GoogleFonts.cairo(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الشهادات',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 129, 237, 194),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...certificates.map((cert) => Card(
                  color: Colors.green[50],
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.school,
                        color: Color.fromARGB(255, 129, 237, 194), size: 30),
                    title: Text(cert, style: GoogleFonts.cairo(fontSize: 16)),
                  ),
                )),

            const SizedBox(height: 25),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                          name: userData?['name'] ?? '',
                          birthDate: userData?['birth_date'] ?? '',
                          //salary: userData?['salary']?.toString() ?? '',
                          imageUrl: formatImageUrl(userData?['image']),
                          token: widget.token,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('تعديل المعلومات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 129, 237, 194),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    textStyle: GoogleFonts.cairo(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (_) => IncomeChartScreen(
                //           months: ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'],
                //           rawValues: [5000, 6000, 5500, 7000, 6500, 7200],
                //         ),
                //       ),
                //     );
                //   },
                //   icon: const Icon(Icons.bar_chart, color: Colors.white),
                //   label: const Text('مخطط الدخل'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color.fromARGB(255, 129, 237, 194),
                //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                //     textStyle: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
                //   ),
                // ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final data = await fetchDoctorBalance(widget.token);

                      if (data.containsKey("Balance")) {
                        final balanceList = data["Balance"] as List;

                        // مباشرة استخدام أسماء الأشهر كما أرسلها السيرفر
                        // final months = balanceList.map<String>((e) => e["month"] as String).toList();
                        final months = balanceList
                            .map<String>((e) => "${e['month']}/${e['year']}")
                            .toList();
                        final values = balanceList
                            .map<num>(
                                (e) => double.parse(e["total"].toString()))
                            .toList();

                        //  final values = balanceList.map<num>((e) => e["total"] as num).toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => IncomeChartScreen(
                              months: months,
                              rawValues: values,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("لا يوجد دخل لهذا العام")),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("خطأ في جلب البيانات: $e")),
                      );
                    }
                  },
                  icon: const Icon(Icons.bar_chart, color: Colors.white),
                  label: const Text('مخطط الدخل'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 129, 237, 194),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    textStyle: GoogleFonts.cairo(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      BlocBuilder<PostCubitDoctor, PostStateDoctor>(
        builder: (context, state) => _buildBody(state),
      ),
      _buildProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("📋 مواعيد الدكتور"),
        backgroundColor: darkTheme
            ? Colors.grey[800]
            : const Color.fromARGB(255, 129, 237, 194),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DoctorSearchDelegate(
                  token: widget.token,
                ),
              );
            },
          ),
          Badge(
            isLabelVisible: _unreadCount > 0,
            backgroundColor: Colors.red,
            label: Text(
              "$_unreadCount",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () async {
                try {
                  final response = await http.get(
                    Uri.parse("$baseUrl/api/getNotifications"),
                    headers: {
                      "Authorization": "Bearer ${widget.token}",
                      "Accept": "application/json",
                    },
                  );

                  if (response.statusCode == 200) {
                    final data = json.decode(response.body);
                    final notifications = data[0] as List<dynamic>;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsPage(
                          notifications: notifications,
                          token: widget.token,
                        ),
                      ),
                    ).then((_) {
                      _fetchUnreadCount();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(" فشل في جلب الإشعارات")),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(" error: $e")),
                  );
                }
              },
            ),
          ),
        ],
        // const Spacer(),
        // // // ✨ إضافة زر الإشعارات هنا
        // // _buildNotificationButton(),
        // const SizedBox(width: 10),]
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
            mainAxisAlignment: MainAxisAlignment.center,
            selectedIndex: selectIndex,
            onTabChange: (index) {
              setState(() {
                selectIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            tabBackgroundColor: Colors.white.withOpacity(0.2),
            gap: 10,
            activeColor: const Color.fromARGB(255, 129, 237, 194),
            color: Colors.grey[700],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

mixin custom_notification {}

// // صفحة تعديل الملف الشخصي
// class EditProfileScreen extends StatelessWidget {
//   final String name;
//   final String birthDate;
//   final String imageUrl;
//
//   const EditProfileScreen({
//     Key? key,
//     required this.name,
//     required this.birthDate,
//     required this.imageUrl,
//   }) : super(key: key);
//
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
//                 backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
//                 backgroundColor: Colors.grey[300],
//                 child: imageUrl.isEmpty ? const Icon(Icons.person, size: 70, color: Colors.white) : null,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(name, style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Text("Birth Date: $birthDate", style: GoogleFonts.cairo(fontSize: 18)),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EditProfileScreen extends StatefulWidget {
//   final String name;
//   final String birthDate;
//   final String imageUrl;
//   final String token;
//
//   const EditProfileScreen({
//     Key? key,
//     required this.name,
//     required this.birthDate,
//     required this.imageUrl,
//     required this.token,
//   }) : super(key: key);
//
//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   late String imageUrl;
//   File? _selectedImage;
//
//   @override
//   void initState() {
//     super.initState();
//     imageUrl = widget.imageUrl;
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
//
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   // Future<String?> uploadProfileImage(String token, File imageFile) async {
//   //   var request = http.MultipartRequest(
//   //     'POST',
//   //     Uri.parse('$baseUrl/api/addImage'), // عدّل حسب رابط الـ API
//   //   );
//   //   request.headers['Authorization'] = 'Bearer $token';
//   //   request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
//   //
//   //   var response = await request.send();
//   //
//   //   if (response.statusCode == 200) {
//   //     final respStr = await response.stream.bytesToString();
//   //     final data = json.decode(respStr);
//   //     return data['doctor']['image']; // عدّل حسب شكل الرد
//   //   } else {
//   //     print("❌ فشل رفع الصورة: ${response.statusCode}");
//   //     return null;
//   //   }
//   // }
//
//   Future<String?> uploadProfileImage(String token, File imageFile) async {
//     try {
//       final uri = Uri.parse('$baseUrl/api/addImage'); // عدّل حسب سيرفرك
//       var request = http.MultipartRequest('POST', uri);
//
//       // إضافة التوكن
//       request.headers['Authorization'] = 'Bearer ${widget.token}';
//
//       // إضافة الصورة
//       request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
//
//       // إرسال الطلب
//       var response = await request.send();
//
//       final respStr = await response.stream.bytesToString();
//       print("🚀 Response Status: ${response.statusCode}");
//       print("📦 Response Body: $respStr");
//
//       if (response.statusCode == 200) {
//         final data = json.decode(respStr);
//         // تحقق من بنية الرد
//         if (data.containsKey('doctor') && data['doctor'].containsKey('image')) {
//           return data['doctor']['image'];
//         } else {
//           print("⚠️ الرد لا يحتوي على الصورة: $data");
//           return null;
//         }
//       } else if (response.statusCode == 404) {
//         print("❌ الرابط غير موجود (404). تحقق من route في Laravel");
//         return null;
//       } else if (response.statusCode == 403) {
//         print("❌ غير مصرح (403)، تحقق من التوكن والصلاحيات");
//         return null;
//       } else {
//         print("❌ فشل رفع الصورة: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("❌ حدث خطأ أثناء رفع الصورة: $e");
//       return null;
//     }
//   }
//
//
//
//   Future<void> _uploadSelectedImage() async {
//     if (_selectedImage == null) return;
//
//     String? newImageUrl = await uploadProfileImage(widget.token, _selectedImage!);
//     if (newImageUrl != null) {
//       setState(() {
//         imageUrl = newImageUrl;
//         _selectedImage = null;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("تم تحديث الصورة بنجاح")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("فشل رفع الصورة")),
//       );
//     }
//   }
//
//   void _showImageSourceOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('اختر من المعرض'),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('التقط صورة بالكاميرا'),
//               onTap: () {
//                 Navigator.of(context).pop();
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
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
//             GestureDetector(
//               onTap: _showImageSourceOptions,
//               child: Hero(
//                 tag: "doctorImage",
//                 child: CircleAvatar(
//                   radius: 70,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage: _selectedImage != null
//                       ? FileImage(_selectedImage!)
//                       : (imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null) as ImageProvider?,
//                   child: (_selectedImage == null && imageUrl.isEmpty)
//                       ? const Icon(Icons.person, size: 70, color: Colors.white)
//                       : null,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             if (_selectedImage != null)
//               ElevatedButton.icon(
//                 onPressed: _uploadSelectedImage,
//                 icon: const Icon(Icons.upload),
//                 label: const Text('رفع الصورة'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 129, 237, 194),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             Text(widget.name,
//                 style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             Text("Birth Date: ${widget.birthDate}", style: GoogleFonts.cairo(fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String birthDate;
  final String imageUrl;
  final String token;

  const EditProfileScreen({
    super.key,
    required this.name,
    required this.birthDate,
    required this.imageUrl,
    required this.token,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String imageUrl;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadProfileImage(String token, File imageFile) async {
    try {
      final uri = Uri.parse('$baseUrl/api/addImage'); // عدّل حسب سيرفرك
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      print("🚀 Response Status: ${response.statusCode}");
      print("📦 Response Body: $respStr");

      if (response.statusCode == 200) {
        final data = json.decode(respStr);
        if (data.containsKey('doctor') && data['doctor'].containsKey('image')) {
          return data['doctor']['image'];
        } else {
          print("⚠️ الرد لا يحتوي على الصورة: $data");
          return null;
        }
      } else {
        print("❌ فشل رفع الصورة: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ حدث خطأ أثناء رفع الصورة: $e");
      return null;
    }
  }

  Future<void> _uploadSelectedImage() async {
    if (_selectedImage == null) return;

    String? newImageUrl =
        await uploadProfileImage(widget.token, _selectedImage!);
    if (newImageUrl != null) {
      setState(() {
        imageUrl = newImageUrl;
        _selectedImage = null;
      });

      // إرجاع الصورة الجديدة للصفحة السابقة لتحديث userData مباشرة
      if (mounted) Navigator.pop(context, newImageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تحديث الصورة بنجاح")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل رفع الصورة")),
      );
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('اختر من المعرض'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('التقط صورة بالكاميرا'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل المعلومات"),
        backgroundColor: const Color.fromARGB(255, 129, 237, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                GestureDetector(
                  onTap: _showImageSourceOptions,
                  child: Hero(
                    tag: "doctorImage",
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (imageUrl.isNotEmpty
                              ? NetworkImage(imageUrl)
                              : null) as ImageProvider?,
                      child: (_selectedImage == null && imageUrl.isEmpty)
                          ? const Icon(Icons.person,
                              size: 70, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 20),
                      onPressed: _showImageSourceOptions,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_selectedImage != null)
              ElevatedButton.icon(
                onPressed: _uploadSelectedImage,
                icon: const Icon(Icons.upload),
                label: const Text('رفع الصورة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 129, 237, 194),
                ),
              ),
            const SizedBox(height: 20),
            Text(widget.name,
                style: GoogleFonts.cairo(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Birth Date: ${widget.birthDate}",
                style: GoogleFonts.cairo(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class IncomeChartScreen extends StatelessWidget {
  final List<String> months;
  final List<num> rawValues;

  IncomeChartScreen({
    super.key,
    required this.months,
    required this.rawValues,
  }) : values = rawValues.map((e) => e.toDouble()).toList();

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final average = values.isNotEmpty
        ? values.reduce((a, b) => a + b) / values.length
        : 0.0;

    final GlobalKey<SfCartesianChartState> chartKey =
        GlobalKey<SfCartesianChartState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Income Chart'),
        backgroundColor: const Color.fromARGB(255, 129, 237, 194),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _saveChartAsImage(chartKey, context),
            tooltip: 'Save as Image',
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'المعدل العام للدخل: ${average.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SfCartesianChart(
                key: chartKey,
                primaryXAxis: const CategoryAxis(),
                title: const ChartTitle(text: 'الدخل الشهري'),
                legend: const Legend(isVisible: false),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  ColumnSeries<double, String>(
                    dataSource: values,
                    xValueMapper: (val, index) =>
                        months.length > index ? months[index] : 'N/A',
                    yValueMapper: (val, index) => val,
                    name: 'الدخل',
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    color: const Color.fromARGB(255, 129, 237, 194),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChartAsImage(
      GlobalKey<SfCartesianChartState> chartKey, BuildContext context) async {
    try {
      final chart = chartKey.currentState!;
      final bytes = await chart.toImage(pixelRatio: 3.0);
      final pngBytes = await bytes!.toByteData(format: ImageByteFormat.png);

      final directory = await getApplicationDocumentsDirectory();
      final file = File(
          '${directory.path}/income_chart_${DateTime.now().millisecondsSinceEpoch}.png');

      // حفظ الملف
      await file.writeAsBytes(pngBytes!.buffer.asUint8List());

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ الرسم البياني في: ${file.path}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('خطأ في حفظ الرسم البياني: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل في حفظ الرسم البياني'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class DoctorSearchDelegate extends SearchDelegate {
  final String token;
  DoctorSearchDelegate({required this.token});

  Future<List<dynamic>> fetchResults(String query) async {
    if (query.isEmpty) return [];

    if (query.length > 25) {
      throw Exception("النص طويل جدًا");
    }

    final url = Uri.parse('$baseUrl/api/doctorSearch');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'search': query}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message']);
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchResults(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('⚠️ ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final results = snapshot.data!;
          if (results.isEmpty) {
            return const Center(child: Text('لا توجد نتائج'));
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final patient = results[index];
              if (patient['appointments'] != null &&
                  patient['appointments'].isNotEmpty) {
                final firstAppointment = patient['appointments'][0];
                return ListTile(
                  title: Text(patient['name']),
                  subtitle: Text('phone: ${patient['phone']}'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PatientDetailsPage(
                                  patientId: firstAppointment["patient_id"],
                                  token: token,
                                  doctor_id: firstAppointment["doctor_id"],
                                  appointment_id1: firstAppointment["id"],
                                )));
                  },
                );
              }
              return null;
            },
          );
        } else {
          return const Center(child: Text('لا توجد نتائج'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('أدخل اسم المريض للبحث'));
  }
}

class NotificationsPage extends StatelessWidget {
  final List<dynamic> notifications;
  final String token;
  const NotificationsPage(
      {super.key, required this.notifications, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: notifications.isEmpty
          ? const Center(child: Text("لا توجد إشعارات حالياً"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                print(n['title']);
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Color.fromARGB(255, 129, 237, 194),
                    ),
                    title: Text(
                      n['title'] ?? "بدون عنوان",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationDetailPage(
                            token: token,
                            notificationId: n['id'], // نمرر الـ id
                          ),
                        ),
                      );
                    },
                    //  subtitle: Text(n['body'] ?? ""),
                  ),
                );
              },
            ),
    );
  }
}

class NotificationDetailPage extends StatelessWidget {
  final String token;
  final int notificationId;

  const NotificationDetailPage({
    super.key,
    required this.token,
    required this.notificationId,
  });
  Future<Map<String, dynamic>> fetchNotificationById(
      String token, int id) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/getNotificationById"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: {"id": id.toString()},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("فشل في جلب الإشعار");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل الإشعار")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchNotificationById(token, notificationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("⚠️ ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["title"] ?? "بدون عنوان",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(data["content"] ?? "لا يوجد محتوى"),
                  // const SizedBox(height: 12),
                  // Text("الحالة: ${data["is_read"] == true ? "مقروء" : "غير مقروء"}",
                  //     style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
