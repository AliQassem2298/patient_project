// // lib/widget/TreatmentDetailsScreen.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:helloworld/ConstantURL.dart';
// import 'package:helloworld/models/treatment_model.dart';

// class TreatmentDetailsScreen extends StatefulWidget {
//   final Treatment treatment;
//   final String token;

//   const TreatmentDetailsScreen({
//     Key? key,
//     required this.treatment,
//     required this.token,
//   }) : super(key: key);

//   @override
//   State<TreatmentDetailsScreen> createState() => _TreatmentDetailsScreenState();
// }

// class _TreatmentDetailsScreenState extends State<TreatmentDetailsScreen> {
//   // استخدام حالة محلية للمعالجة لإدارة حالة الدفع
//   late Treatment _treatment;
//   bool _isPaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _treatment = widget.treatment;
//   }

//   Future<void> _payBill() async {
//     setState(() {
//       _isPaying = true;
//     });

//     final url = Uri.parse('$baseUrl/cashPaid');
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer ${widget.token}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'treatment_id': _treatment.id,
//         }),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _treatment.paid = 1;
//         });
//         _showSnackBar('تم الدفع بنجاح!');
//       } else {
//         final responseBody = jsonDecode(response.body);
//         _showSnackBar('فشل الدفع: ${responseBody['message']}');
//       }
//     } catch (e) {
//       _showSnackBar('حدث خطأ أثناء الدفع: $e');
//     } finally {
//       setState(() {
//         _isPaying = false;
//       });
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("تفاصيل المعالجة", style: GoogleFonts.cairo()),
//         backgroundColor: const Color.fromARGB(255, 129, 237, 194),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildInfoCard(
//               "معلومات المعالجة",
//               [
//                 _buildInfoRow('ID:', _treatment.id.toString()),
//                 _buildInfoRow('الوصف:', _treatment.description),
//                 _buildInfoRow('المرض المشخص:', _treatment.diagnosedDisease),
//                 _buildInfoRow(
//                     'المرض الذي شفي منه:', _treatment.recoveredDisease),
//                 _buildInfoRow(
//                     'صورة إشعاعية:', _treatment.xRay == 1 ? 'نعم' : 'لا'),
//                 _buildInfoRow(
//                     'الفاتورة:', '${_treatment.bill.toStringAsFixed(2)}'),
//                 _buildInfoRow(
//                     'الحالة:', _treatment.paid == 1 ? 'مدفوعة' : 'غير مدفوعة'),
//               ],
//             ),
//             const SizedBox(height: 20),
//             if (_treatment.paid == 0)
//               _isPaying
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _payBill,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             const Color.fromARGB(255, 129, 237, 194),
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         "دفع الفاتورة",
//                         style: GoogleFonts.cairo(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/widget/TreatmentDetailsScreen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:patient_project/ConstantURL.dart';
import 'package:patient_project/models/treatment_model.dart';

class TreatmentDetailsScreen extends StatefulWidget {
  final Treatment treatment;
  final String token;

  const TreatmentDetailsScreen({
    super.key,
    required this.treatment,
    required this.token,
  });

  @override
  State<TreatmentDetailsScreen> createState() => _TreatmentDetailsScreenState();
}

class _TreatmentDetailsScreenState extends State<TreatmentDetailsScreen> {
  // استخدام حالة محلية للمعالجة لإدارة حالة الدفع
  late Treatment _treatment;
  bool _isPaying = false;

  @override
  void initState() {
    super.initState();
    _treatment = widget.treatment;
  }

  Future<void> _payBill() async {
    setState(() {
      _isPaying = true;
    });

    final url = Uri.parse('$baseUrl/cashPaid');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'treatment_id': _treatment.id,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _treatment.paid = 1;
        });
        _showSnackBar('Payment successful!');
      } else {
        final responseBody = jsonDecode(response.body);
        _showSnackBar('Payment failed: ${responseBody['message']}');
      }
    } catch (e) {
      _showSnackBar('An error occurred during payment: $e');
    } finally {
      setState(() {
        _isPaying = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Treatment Details", style: GoogleFonts.cairo()),
        backgroundColor: const Color.fromARGB(255, 129, 237, 194),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(
              "Treatment Information",
              [
                _buildInfoRow('ID:', _treatment.id.toString()),
                _buildInfoRow('Description:', _treatment.description),
                _buildInfoRow(
                    'Diagnosed Disease:', _treatment.diagnosedDisease),
                _buildInfoRow(
                    'Recovered Disease:', _treatment.recoveredDisease),
                _buildInfoRow('X-ray:', _treatment.xRay == 1 ? 'Yes' : 'No'),
                _buildInfoRow('Bill:', _treatment.bill.toStringAsFixed(2)),
                _buildInfoRow(
                    'Status:', _treatment.paid == 1 ? 'Paid' : 'Unpaid'),
              ],
            ),
            const SizedBox(height: 20),
            if (_treatment.paid == 0)
              _isPaying
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _payBill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 129, 237, 194),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Pay Bill",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}
