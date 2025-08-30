// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:helloworld/models/patient_model.dart';
// import 'package:helloworld/models/appointment_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:helloworld/ConstantURL.dart'; // تأكد من أن المسار صحيح

// class PatientDetailsScreen extends StatefulWidget {
//   final Patient patient;
//   final String token; // يجب تمرير الرمز (token) إلى هذه الشاشة

//   const PatientDetailsScreen({
//     Key? key,
//     required this.patient,
//     required this.token, // أضف هذا إلى الباني (constructor)
//   }) : super(key: key);

//   @override
//   State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
// }

// class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
//   // استخدم حالة محلية لإدارة قائمة المواعيد
//   late List<Appointment> _appointments;

//   @override
//   void initState() {
//     super.initState();
//     _appointments = List.from(widget.patient.appointments);
//   }

//   Future<void> _deleteAppointment(int appointmentId) async {
//     // عرض مربع حوار (dialog) للتأكيد
//     final bool confirmDelete = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('تأكيد الحذف', style: GoogleFonts.cairo()),
//         content: Text('هل أنت متأكد أنك تريد حذف هذا الموعد؟',
//             style: GoogleFonts.cairo()),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: Text('حذف', style: GoogleFonts.cairo(color: Colors.white)),
//           ),
//         ],
//       ),
//     );

//     if (!confirmDelete) return;

//     final url = Uri.parse('$baseUrl/deleteAppointment');
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer ${widget.token}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'appointment_id': appointmentId,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // تم الحذف بنجاح، قم بتحديث الواجهة
//         setState(() {
//           _appointments.removeWhere((appt) => appt.id == appointmentId);
//         });
//         _showSnackBar('تم حذف الموعد بنجاح.');
//       } else {
//         final responseBody = jsonDecode(response.body);
//         _showSnackBar('فشل الحذف: ${responseBody['message']}');
//       }
//     } catch (e) {
//       _showSnackBar('حدث خطأ: $e');
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message, style: GoogleFonts.cairo()),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("تفاصيل المريض", style: GoogleFonts.cairo()),
//         backgroundColor: const Color.fromARGB(255, 129, 237, 194),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundColor: Colors.grey[300],
//                 child: const Icon(Icons.person, size: 60, color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildInfoCard(
//               'معلومات أساسية',
//               [
//                 _buildInfoRow('الاسم:', widget.patient.name),
//                 _buildInfoRow('رقم الهاتف:', widget.patient.phone),
//                 _buildInfoRow('تاريخ الميلاد:', widget.patient.birthDate),
//                 _buildInfoRow('رصيد المحفظة:',
//                     '${widget.patient.walletBalance.toStringAsFixed(2)}'),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildInfoCard(
//               'حالات المريض',
//               [
//                 _buildDiseaseRow('إجهاد العين', widget.patient.eyestrain),
//                 _buildDiseaseRow('اللابؤرية', widget.patient.astigmatism),
//                 _buildDiseaseRow('الضغط', widget.patient.pressure),
//                 _buildDiseaseRow('السكري', widget.patient.diabtes),
//                 _buildDiseaseRow('عمى الألوان', widget.patient.colorBlindness),
//                 _buildDiseaseRow('الحول', widget.patient.strabismus),
//                 _buildDiseaseRow('الحساسية', widget.patient.allergy),
//                 _buildDiseaseRow('جفاف العين', widget.patient.dryEye),
//                 _buildDiseaseRow(
//                     'انفصال الشبكية', widget.patient.retinalDetachment),
//                 _buildDiseaseRow(
//                     'القرنية المخروطية', widget.patient.keratoconus),
//                 _buildDiseaseRow(
//                     'التهاب الملتحمة', widget.patient.conjunctivitis),
//                 _buildDiseaseRow(
//                     'إعتام عدسة العين (الماء الأبيض)', widget.patient.cataract),
//                 _buildDiseaseRow(
//                     'الزرق (الماء الأزرق)', widget.patient.glaucoma),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildAppointmentsCard(_appointments),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard(String title, List<Widget> children) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: GoogleFonts.cairo(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: const Color.fromARGB(255, 129, 237, 194),
//               ),
//             ),
//             const Divider(color: Colors.grey),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.cairo(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             value,
//             style: GoogleFonts.cairo(
//               fontSize: 18,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDiseaseRow(String diseaseName, bool hasDisease) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(
//             hasDisease ? Icons.check_circle : Icons.cancel,
//             color: hasDisease ? Colors.green : Colors.red,
//           ),
//           const SizedBox(width: 10),
//           Text(
//             diseaseName,
//             style: GoogleFonts.cairo(
//               fontSize: 16,
//               decoration:
//                   hasDisease ? TextDecoration.none : TextDecoration.lineThrough,
//               color: hasDisease ? Colors.black : Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppointmentsCard(List<Appointment> appointments) {
//     return _buildInfoCard(
//       'المواعيد القادمة',
//       appointments.isEmpty
//           ? [
//               Center(
//                 child: Text(
//                   'لا توجد مواعيد قادمة لهذا المريض.',
//                   style: GoogleFonts.cairo(
//                     fontSize: 16,
//                     fontStyle: FontStyle.italic,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ),
//             ]
//           : appointments.map((appointment) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'ID: ${appointment.id}',
//                           style: GoogleFonts.cairo(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           '${appointment.date} - ${appointment.time}',
//                           style: GoogleFonts.cairo(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => _deleteAppointment(appointment.id),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//     );
//   }
// }

// lib/screens/patient_details_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
 import 'package:http/http.dart' as http;
import 'package:patient_project/ConstantURL.dart';
import 'package:patient_project/models/appointment_model.dart';
import 'package:patient_project/models/patient_model.dart';
 
class PatientDetailsScreen extends StatefulWidget {
  final Patient patient;
  final String token; // The token must be passed to this screen

  const PatientDetailsScreen({
    super.key,
    required this.patient,
    required this.token, // Add this to the constructor
  });

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  // Use a local state to manage the list of appointments
  late List<Appointment> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = List.from(widget.patient.appointments);
  }

  Future<void> _deleteAppointment(int appointmentId) async {
    // Show a confirmation dialog
    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion', style: GoogleFonts.cairo()),
        content: Text('Are you sure you want to delete this appointment?',
            style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                Text('Delete', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );

    if (!confirmDelete) return;

    final url = Uri.parse('$baseUrl/deleteAppointment');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'appointment_id': appointmentId,
        }),
      );

      if (response.statusCode == 200) {
        // Deletion successful, update the UI
        setState(() {
          _appointments.removeWhere((appt) => appt.id == appointmentId);
        });
        _showSnackBar('Appointment deleted successfully.');
      } else {
        final responseBody = jsonDecode(response.body);
        _showSnackBar('Deletion failed: ${responseBody['message']}');
      }
    } catch (e) {
      _showSnackBar('An error occurred: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Details", style: GoogleFonts.cairo()),
        backgroundColor: const Color.fromARGB(255, 129, 237, 194),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'Basic Information',
              [
                _buildInfoRow('Name:', widget.patient.name),
                _buildInfoRow('Phone Number:', widget.patient.phone),
                _buildInfoRow('Date of Birth:', widget.patient.birthDate),
                // _buildInfoRow('Wallet Balance:',
                //     '${widget.patient.walletBalance.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'Patient Conditions',
              [
                _buildDiseaseRow('Eyestrain', widget.patient.eyestrain),
                _buildDiseaseRow('Astigmatism', widget.patient.astigmatism),
                _buildDiseaseRow('Pressure', widget.patient.pressure),
                _buildDiseaseRow('Diabetes', widget.patient.diabtes),
                _buildDiseaseRow(
                    'Color Blindness', widget.patient.colorBlindness),
                _buildDiseaseRow('Strabismus', widget.patient.strabismus),
                _buildDiseaseRow('Allergy', widget.patient.allergy),
                _buildDiseaseRow('Dry Eye', widget.patient.dryEye),
                _buildDiseaseRow(
                    'Retinal Detachment', widget.patient.retinalDetachment),
                _buildDiseaseRow('Keratoconus', widget.patient.keratoconus),
                _buildDiseaseRow(
                    'Conjunctivitis', widget.patient.conjunctivitis),
                _buildDiseaseRow('Cataract', widget.patient.cataract),
                _buildDiseaseRow('Glaucoma', widget.patient.glaucoma),
              ],
            ),
            const SizedBox(height: 20),
            _buildAppointmentsCard(_appointments),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 129, 237, 194),
              ),
            ),
            const Divider(color: Colors.grey),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseRow(String diseaseName, bool hasDisease) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            hasDisease ? Icons.check_circle : Icons.cancel,
            color: hasDisease ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Text(
            diseaseName,
            style: GoogleFonts.cairo(
              fontSize: 16,
              decoration:
                  hasDisease ? TextDecoration.none : TextDecoration.lineThrough,
              color: hasDisease ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsCard(List<Appointment> appointments) {
    return _buildInfoCard(
      'Upcoming Appointments',
      appointments.isEmpty
          ? [
              Center(
                child: Text(
                  'No upcoming appointments for this patient.',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ]
          : appointments.map((appointment) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: ${appointment.id}',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${appointment.date} - ${appointment.time}',
                          style: GoogleFonts.cairo(fontSize: 16),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAppointment(appointment.id),
                    ),
                  ],
                ),
              );
            }).toList(),
    );
  }
}
