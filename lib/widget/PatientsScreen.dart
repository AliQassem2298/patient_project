// // lib/screens/patients_screen.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:helloworld/widget/PatientDetailsScreen.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// import 'package:helloworld/ConstantURL.dart';
// import 'package:helloworld/models/patient_model.dart';

// class PatientsScreen extends StatefulWidget {
//   final String token;

//   const PatientsScreen({Key? key, required this.token}) : super(key: key);

//   @override
//   State<PatientsScreen> createState() => _PatientsScreenState();
// }

// class _PatientsScreenState extends State<PatientsScreen> {
//   late Future<List<Patient>> futurePatients;
//   final ScrollController _scrollController = ScrollController();
//   int currentPage = 1;
//   bool hasMore = true;

//   @override
//   void initState() {
//     super.initState();
//     futurePatients = fetchAllPatients(widget.token, currentPage);
//     _scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent &&
//         hasMore) {
//       _loadMorePatients();
//     }
//   }

//   Future<void> _loadMorePatients() async {
//     if (!hasMore) return;

//     setState(() {
//       currentPage++;
//     });

//     try {
//       final newPatients = await fetchAllPatients(widget.token, currentPage);
//       setState(() {
//         if (newPatients.isEmpty) {
//           hasMore = false;
//         }
//         futurePatients = futurePatients.then((existingPatients) {
//           return existingPatients..addAll(newPatients);
//         });
//       });
//     } catch (e) {
//       print('Error loading more patients: $e');
//       setState(() {
//         hasMore = false;
//       });
//     }
//   }

//   Future<List<Patient>> fetchAllPatients(String token, int page) async {
//     final url = Uri.parse("$baseUrl/getAllPatients?page=$page");
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final List<dynamic> patientsJson = data['patients'];
//         hasMore = data['next_page_url'] != null; // Check for more pages
//         return patientsJson.map((json) => Patient.fromJson(json)).toList();
//       } else {
//         throw Exception(
//             'Failed to load patients. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load patients: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Patient>>(
//       future: futurePatients,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text("error: ${snapshot.error}"));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text("No patient data available."));
//         } else {
//           final patients = snapshot.data!;
//           return AnimationLimiter(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: patients.length + (hasMore ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == patients.length) {
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 20),
//                     child: Center(child: CircularProgressIndicator()),
//                   );
//                 }
//                 final patient = patients[index];
//                 return AnimationConfiguration.staggeredList(
//                   position: index,
//                   duration: const Duration(milliseconds: 375),
//                   child: SlideAnimation(
//                     verticalOffset: 50.0,
//                     child: FadeInAnimation(
//                       child: Card(
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 8),
//                         child: ListTile(
//                           leading: const Icon(Icons.person,
//                               color: Color.fromARGB(255, 129, 237, 194)),
//                           title: Text(patient.name,
//                               style: GoogleFonts.cairo(
//                                   fontWeight: FontWeight.bold)),
//                           // subtitle: Text(
//                           //     'رصيد المحفظة: ${patient.walletBalance.toStringAsFixed(2)}',
//                           //     style: GoogleFonts.cairo()),
//                           trailing:
//                               const Icon(Icons.arrow_forward_ios, size: 18),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => PatientDetailsScreen(
//                                   patient: patient,
//                                   token: widget.token,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// lib/screens/patients_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:patient_project/ConstantURL.dart';
import 'package:patient_project/models/patient_model.dart';
import 'package:patient_project/widget/PatientDetailsScreen.dart';

class PatientsScreen extends StatefulWidget {
  final String token;

  const PatientsScreen({super.key, required this.token});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  late Future<List<Patient>> futurePatients;
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    futurePatients = fetchAllPatients(widget.token, currentPage);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        hasMore) {
      _loadMorePatients();
    }
  }

  Future<void> _loadMorePatients() async {
    if (!hasMore) return;

    setState(() {
      currentPage++;
    });

    try {
      final newPatients = await fetchAllPatients(widget.token, currentPage);
      setState(() {
        if (newPatients.isEmpty) {
          hasMore = false;
        }
        futurePatients = futurePatients.then((existingPatients) {
          return existingPatients..addAll(newPatients);
        });
      });
    } catch (e) {
      print('Error loading more patients: $e');
      setState(() {
        hasMore = false;
      });
    }
  }

  Future<List<Patient>> fetchAllPatients(String token, int page) async {
    final url = Uri.parse("$baseUrl/getAllPatients?page=$page");
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> patientsJson = data['patients'];
        hasMore = data['next_page_url'] != null; // Check for more pages
        return patientsJson.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load patients. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load patients: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients', style: GoogleFonts.cairo()),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PatientSearchDelegate(widget.token),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Patient>>(
        future: futurePatients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No patient data available."));
          } else {
            final patients = snapshot.data!;
            return AnimationLimiter(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: patients.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == patients.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final patient = patients[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.person,
                                color: Color.fromARGB(255, 129, 237, 194)),
                            title: Text(patient.name,
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold)),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 18),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientDetailsScreen(
                                    patient: patient,
                                    token: widget.token,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class PatientSearchDelegate extends SearchDelegate<String> {
  final String token;

  PatientSearchDelegate(this.token);

  Future<List<Patient>> searchPatients(String query) async {
    final url = Uri.parse("$baseUrl/secretary_search");
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'search': query,
        }),
      );

      // ✅ التعديل هنا: معالجة حالة 404
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => Patient.fromJson(json)).toList();
        } else {
          // يمكن أن يحدث هذا إذا كان الـ API يرجع هيكلاً مختلفاً
          return [];
        }
      } else if (response.statusCode == 404) {
        // ✅ إذا كانت النتيجة 404، لا ترمي خطأ بل أعد قائمة فارغة
        return [];
      } else {
        // إذا كان أي خطأ آخر غير 404، ارمِ استثناء
        throw Exception(
            'Failed to search patients. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search patients: $e');
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Patient>>(
      future: searchPatients(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // ✅ عرض الخطأ العام في حال فشل الاتصال أو خطأ غير 404
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // ✅ عرض رسالة "لم يتم العثور على مريض" في حال كانت القائمة فارغة
          return const Center(child: Text('No patient found.'));
        } else {
          // ... (بقية الكود كما هو لعرض النتائج)
          final searchResults = snapshot.data!;
          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final patient = searchResults[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.person,
                      color: Color.fromARGB(255, 129, 237, 194)),
                  title: Text(patient.name,
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailsScreen(
                          patient: patient,
                          token: token,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // You can add suggestions based on a limited list here if needed
    return const Center(
      child: Text('Search for a patient by name...',
          style: TextStyle(color: Colors.grey)),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }
}
