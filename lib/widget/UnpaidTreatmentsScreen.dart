// // lib/screens/UnpaidTreatmentsScreen.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:helloworld/ConstantURL.dart';
// import 'package:helloworld/models/treatment_model.dart';
// import 'package:helloworld/widget/TreatmentDetailsScreen.dart';

// class UnpaidTreatmentsScreen extends StatefulWidget {
//   final String token;
//   const UnpaidTreatmentsScreen({Key? key, required this.token})
//       : super(key: key);

//   @override
//   State<UnpaidTreatmentsScreen> createState() => _UnpaidTreatmentsScreenState();
// }

// class _UnpaidTreatmentsScreenState extends State<UnpaidTreatmentsScreen> {
//   late Future<List<Treatment>> futureUnpaidTreatments;

//   @override
//   void initState() {
//     super.initState();
//     futureUnpaidTreatments = _fetchUnpaidTreatments();
//   }

//   Future<List<Treatment>> _fetchUnpaidTreatments() async {
//     final url = Uri.parse('$baseUrl/getPatientTreatments');
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer ${widget.token}',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data != null && data.isNotEmpty && data[0] is List) {
//           final List<dynamic> treatmentsJson = data[0];
//           return treatmentsJson
//               .map((json) => Treatment.fromJson(json))
//               .toList();
//         }
//         return [];
//       } else {
//         throw Exception(
//             'Failed to load unpaid treatments. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load unpaid treatments: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Treatment>>(
//       future: futureUnpaidTreatments,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(
//               child:
//                   Text("خطأ: ${snapshot.error}", style: GoogleFonts.cairo()));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(
//               child: Text("لا توجد فواتير غير مدفوعة حالياً.",
//                   style: GoogleFonts.cairo()));
//         } else {
//           final unpaidTreatments = snapshot.data!;
//           return ListView.builder(
//             itemCount: unpaidTreatments.length,
//             itemBuilder: (context, index) {
//               final treatment = unpaidTreatments[index];
//               return Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: ListTile(
//                   leading: const Icon(Icons.credit_card,
//                       color: Color.fromARGB(255, 237, 129, 129)),
//                   title: Text(
//                     // تم تغيير الحقل هنا
//                     '${treatment.description}',
//                     style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     'الفاتورة: ${treatment.bill.toStringAsFixed(2)}',
//                     style: GoogleFonts.cairo(),
//                   ),
//                   trailing: const Icon(Icons.arrow_forward_ios, size: 18),
//                   onTap: () async {
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TreatmentDetailsScreen(
//                           treatment: treatment,
//                           token: widget.token,
//                         ),
//                       ),
//                     );
//                     // تحديث القائمة عند العودة بعد الدفع
//                     setState(() {
//                       futureUnpaidTreatments = _fetchUnpaidTreatments();
//                     });
//                   },
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }

// lib/screens/UnpaidTreatmentsScreen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:patient_project/ConstantURL.dart';
import 'package:patient_project/models/treatment_model.dart';
import 'package:patient_project/widget/TreatmentDetailsScreen.dart';

class UnpaidTreatmentsScreen extends StatefulWidget {
  final String token;
  const UnpaidTreatmentsScreen({super.key, required this.token});

  @override
  State<UnpaidTreatmentsScreen> createState() => _UnpaidTreatmentsScreenState();
}

class _UnpaidTreatmentsScreenState extends State<UnpaidTreatmentsScreen> {
  late Future<List<Treatment>> futureUnpaidTreatments;

  @override
  void initState() {
    super.initState();
    futureUnpaidTreatments = _fetchUnpaidTreatments();
  }

  Future<List<Treatment>> _fetchUnpaidTreatments() async {
    final url = Uri.parse('$baseUrl/getPatientTreatments');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data.isNotEmpty && data[0] is List) {
          final List<dynamic> treatmentsJson = data[0];
          return treatmentsJson
              .map((json) => Treatment.fromJson(json))
              .toList();
        }
        return [];
      } else {
        throw Exception(
            'Failed to load unpaid treatments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load unpaid treatments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Treatment>>(
      future: futureUnpaidTreatments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child:
                  Text("Error: ${snapshot.error}", style: GoogleFonts.cairo()));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text("No unpaid bills at the moment.",
                  style: GoogleFonts.cairo()));
        } else {
          final unpaidTreatments = snapshot.data!;
          return ListView.builder(
            itemCount: unpaidTreatments.length,
            itemBuilder: (context, index) {
              final treatment = unpaidTreatments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.credit_card,
                      color: Color.fromARGB(255, 237, 129, 129)),
                  title: Text(
                    // تم تغيير الحقل هنا
                    treatment.description,
                    style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Bill: ${treatment.bill.toStringAsFixed(2)}',
                    style: GoogleFonts.cairo(),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TreatmentDetailsScreen(
                          treatment: treatment,
                          token: widget.token,
                        ),
                      ),
                    );
                    // تحديث القائمة عند العودة بعد الدفع
                    setState(() {
                      futureUnpaidTreatments = _fetchUnpaidTreatments();
                    });
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
