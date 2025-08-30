import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'AddMedicineScreen.dart';
import 'ConstantURL.dart';

class PatientDetailsPage extends StatefulWidget {
  final int patientId;
  final String token;
  final int doctor_id;
  final int appointment_id1;
  const PatientDetailsPage({
    super.key,
    required this.patientId,
    required this.token,
    required this.doctor_id,
    required this.appointment_id1,
  });

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, dynamic>? patient;
  bool hasError = false;
  bool showDiseases = false;
  List<String> prescribedDrugs = [];
  List<dynamic> previousAppointments = [];
  List<dynamic> medicines = [];
  List<dynamic> items = [];
  List<dynamic> prescribedMedicines = [];
  bool isLoading = false;
  bool isPrescribedMedicinesLoading = false;
  int? prescriptionId;
  List<String> upcomingAppointments = [];

  @override
  void initState() {
    super.initState();
    fetchPatientData();
    fetchMedicines();
  }

  Future<void> fetchPrescribedMedicines() async {
    if (prescriptionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لا توجد وصفة طبية لهذا المريض',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => isPrescribedMedicinesLoading = true);

    final url = Uri.parse('$baseUrl/api/get_list');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({'prescription_id': prescriptionId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          prescribedMedicines = data['medicines'] ?? [];
        });
      } else {
        throw Exception('فشل في تحميل الأدوية الموصوفة');
      }
    } catch (e) {
      print("خطأ أثناء جلب الأدوية الموصوفة: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ في تحميل الأدوية الموصوفة',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isPrescribedMedicinesLoading = false);
    }
  }

  Future<void> fetchPreviousAppointments(int patientId) async {
    final url = Uri.parse("$baseUrl/api/appointments/past/$patientId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        previousAppointments = data['appointments'];
      } else {
        print("فشل في تحميل المواعيد: Failed to load ${response.statusCode}");
      }
    } catch (e) {
      print("خطأ أثناء الاتصال: $e");
    }
  }

  Future<void> fetchUpcomingAppointments(int patientId) async {
    final url = Uri.parse("$baseUrl/api/appointments/upcoming/$patientId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          upcomingAppointments = List<String>.from(
            (data['appointments'] as List).map((a) => a['appointment_time']),
          );
        });
      } else {
        print("فشل في تحميل المواعيد اللاحقة: ${response.statusCode}");
      }
    } catch (e) {
      print("خطأ أثناء الاتصال بالمواعيد اللاحقة: $e");
    }
  }

  Future<void> fetchMedicines() async {
    final url = Uri.parse('$baseUrl/api/get_medicines');
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({'patient_id': widget.patientId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        prescriptionId = data['prescription_id'];
        items = data['medicines'];
      } else {
        print('Failed to load medicines');
      }
      setState(() => isLoading = false);
    } catch (e) {
      print("خطأ أثناء الاتصال: $e");
    }
  }

  Future<void> fetchPatientData() async {
    final url = Uri.parse('$baseUrl/api/getPatientById');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({'id': widget.patientId}),
      );
      if (response.statusCode == 200) {
        setState(() {
          patient = json.decode(response.body)['patient'];
          isLoading = false;
        });
      } else {
        throw Exception('فشل التحميل');
      }
    } catch (_) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> showDiseaseDialog(String key, String title) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'تحديث الحالة',
      desc: 'هل يعاني من $title؟',
      btnCancelText: 'لا',
      btnCancelOnPress: () => setState(() => patient![key] = 0),
      btnOkText: 'نعم',
      btnOkOnPress: () => setState(() => patient![key] = 1),
    ).show();
  }

  void showAppointmentModal(String type, int patientId) async {
    if (type == 'previous') {
      await fetchPreviousAppointments(patientId);
    } else if (type == 'upcoming') {
      await fetchUpcomingAppointments(patientId);
    }

    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (context, setModalState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type == 'previous' ? 'المواعيد السابقة' : 'المواعيد اللاحقة',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (type == 'upcoming') ...[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة موعد جديد'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 129, 237, 194),
                    ),
                    onPressed: () async {
                      final response = await http.post(
                        Uri.parse("$baseUrl/api/appointments/available"),
                        headers: {
                          "Authorization": "Bearer ${widget.token}",
                          "Accept": "application/json",
                        },
                        body: jsonEncode({
                          "patient_id": widget.patientId,
                        }),
                      );

                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);
                        final appointments = data['appointments'];

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "اختر موعدًا",
                              style: GoogleFonts.cairo(),
                            ),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  final appointment = appointments[index];
                                  final id =
                                      appointment['id'];
                                  final date1 = appointment['appointment_time'];

                                  return ListTile(
                                    leading: const Icon(
                                      Icons.calendar_today,
                                      color: Color.fromARGB(255, 129, 237, 194),
                                    ),
                                    title: Text(
                                      "موعد متاح",
                                      style: GoogleFonts.cairo(),
                                    ),
                                    subtitle: Text("تاريخ: $date1"),
                                    trailing: ElevatedButton(
                                      onPressed: () async {
                                        print(id);
                                        print(widget.patientId);
                                        final bookResponse = await http.post(
                                          Uri.parse(
                                            "$baseUrl/api/appointments/booked",
                                          ),
                                          headers: {
                                            "Authorization":
                                                "Bearer ${widget.token}",
                                            "Accept": "application/json",
                                            "Content-Type": "application/json",
                                          },
                                          body: jsonEncode({
                                            "appointment_id": id,
                                            "patient_id": widget.patientId,
                                          }),
                                        );

                                        if (bookResponse.statusCode == 200) {
                                          Navigator.pop(
                                            context,
                                          );
                                          setModalState(() {
                                            upcomingAppointments.add(date1);
                                          });
                                        } else {
                                          final msg = jsonDecode(
                                            bookResponse.body,
                                          )['message'];
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(content: Text(msg)),
                                          );
                                        }
                                      },
                                      child: const Text("تأكيد"),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("فشل في جلب المواعيد")),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                ],
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (type == 'previous')
                          ...previousAppointments.map((appointment) {
                            final date = appointment['appointment_time'];
                            final doctorId = appointment['doctor_id'];
                            return ListTile(
                              leading: const Icon(
                                Icons.calendar_today,
                                color: Color.fromARGB(255, 129, 237, 194),
                              ),
                              title: Text(
                                "دكتور رقم $doctorId",
                                style: GoogleFonts.cairo(),
                              ),
                              subtitle: Text(
                                "تاريخ الموعد: $date",
                                style: GoogleFonts.cairo(),
                              ),
                            );
                          }),
                        if (type == 'upcoming')
                          ...upcomingAppointments.map(
                            (date) => ListTile(
                              leading: const Icon(
                                Icons.calendar_today,
                                color: Color.fromARGB(255, 129, 237, 194),
                              ),
                              title: Text(
                                'موعد قادم',
                                style: GoogleFonts.cairo(),
                              ),
                              subtitle: Text('تاريخ: $date'),
                            ),
                          ),
                        const SizedBox(height: 10),
                        if (prescribedDrugs.isNotEmpty) ...[
                          const Divider(),
                          Text(
                            'الأدوية الموصوفة:',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            children: prescribedDrugs
                                .map((drug) => Chip(label: Text(drug)))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text("إغلاق"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitTreatment(String description, bool xRay,
      String recovered, String diagnosed) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/addTreatment'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "description": description,
          "appointment_id":widget.appointment_id1,
          "x_ray": xRay,
          "recovered_disease": recovered,
          "diagnosed_disease": diagnosed,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "✅ تمت إضافة العلاج بنجاح");
      } else {
        Fluttertoast.showToast(msg: "❌ فشل في إضافة العلاج");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "⚠️ خطأ في الاتصال: $e");
    }
  }


  void _showAddTreatmentForm(BuildContext context) {
    final TextEditingController descriptionController = TextEditingController();
  //  final TextEditingController appointmentIdController = TextEditingController();
    final TextEditingController recoveredController = TextEditingController();
    final TextEditingController diagnosedController = TextEditingController();
    bool xRay = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[50],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "إضافة علاج جديد",
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // الوصف
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "الوصف",
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // // رقم الموعد
                  // TextField(
                  //   controller: appointmentIdController,
                  //   decoration: InputDecoration(
                  //     labelText: "رقم الموعد",
                  //     labelStyle: GoogleFonts.cairo(),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.number,
                  // ),
                  // const SizedBox(height: 15),

                  // المرض الذي تم الشفاء منه
                  TextField(
                    controller: recoveredController,
                    decoration: InputDecoration(
                      labelText: "المرض الذي تم الشفاء منه",
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // المرض الذي تم تشخيصه
                  TextField(
                    controller: diagnosedController,
                    decoration: InputDecoration(
                      labelText: "المرض الذي تم تشخيصه",
                      labelStyle: GoogleFonts.cairo(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // X-Ray switch
                  SwitchListTile(
                    title: Text("هل تم عمل أشعة X-Ray؟",
                        style: GoogleFonts.cairo(fontSize: 16)),
                    value: xRay,
                    onChanged: (val) {
                      setState(() {
                        xRay = val;
                      });
                    },
                    activeColor: Colors.teal,
                  ),

                  const SizedBox(height: 20),

                  // زر الحفظ
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: Text(
                      "حفظ العلاج",
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      if (descriptionController.text.isEmpty )
                   //     ||appointmentIdController.text.isEmpty)
                      {
                        Fluttertoast.showToast(
                          msg: "⚠️ يرجى إدخال جميع الحقول المطلوبة",
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                        );
                        return;
                      }

                      _submitTreatment(
                        descriptionController.text,
                        //int.tryParse(appointmentIdController.text) ?? 0,
                        xRay,
                        recoveredController.text,
                        diagnosedController.text,
                      );

                      // Fluttertoast.showToast(
                      //   msg: "✅ تمت إضافة العلاج بنجاح",
                      //   backgroundColor: Colors.green,
                      //   textColor: Colors.white,
                      // );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDrugPicker() async {
    setState(() {
      isLoading = true;
    });

    await fetchMedicines();

    setState(() {
      isLoading = false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'قائمة الأدوية',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showPrescribedMedicines();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 129, 237, 194),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.medication, size: 18),
                        const SizedBox(width: 5),
                        Text(
                          'عرض الأدوية الموصوفة',
                          style: GoogleFonts.cairo(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              isLoading
                  ? ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              color: Colors.white,
                            ),
                            title: Container(
                              width: 80,
                              height: 10,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                            ),
                            subtitle: Container(
                              width: 50,
                              height: 10,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final med = items[index];

                          String? imageUrl;
                          String? path;
                          if (med['image'] != null &&
                              med['image'].toString().isNotEmpty) {
                            path = med['image'];
                            imageUrl = "$baseUrl$path";
                          }

                          return ListTile(
                            leading: (imageUrl != null && imageUrl.isNotEmpty)
                                ? Image.network(
                                    imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.medication,
                                        color: Color.fromARGB(255, 129, 237, 194,),
                                      );
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const Icon(
                                    Icons.medication,
                                    color: Color.fromARGB(255, 129, 237, 194),
                                  ),

                            title: Text(
                              med['name']?.toString() ?? "بدون اسم",
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              "Dose: ${med['dose']?.toString() ?? 'غير متوفر'}",
                              style: GoogleFonts.cairo(),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Color.fromARGB(255, 129, 237, 194),
                              ),
                              onPressed: () async {
                                final bottomSheetContext = context;
                                final result = await Navigator.push(
                                  bottomSheetContext,
                                  MaterialPageRoute(
                                    builder: (context) => AddMedicineScreen(
                                      baseUrl: baseUrl,
                                      medicineId: med['id'],
                                      token: widget.token,
                                      prescription_id: prescriptionId,
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  ScaffoldMessenger.of(
                                    bottomSheetContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'تم إضافة ${med['name']?.toString() ?? "الدواء"} بنجاح',
                                        style: GoogleFonts.cairo(),
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        129,
                                        237,
                                        194,
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),

                            onTap: () {
                              setState(() {
                                String drugName =
                                    med['name']?.toString() ?? "دواء غير محدد";
                                if (!prescribedDrugs.contains(drugName)) {
                                  prescribedDrugs.add(drugName);
                                }
                              });

                              Navigator.pop(context);

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //     content: Text('تم إضافة ${med['name']?.toString() ?? "الدواء"} بنجاح',
                              //       style: GoogleFonts.cairo(),),
                              //     backgroundColor: Color.fromARGB(255, 129, 237, 194,),
                              //     duration: Duration(seconds: 2),
                              //   ),
                              // );
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrescribedMedicines() async {
    if (prescriptionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لا يوجد وصفة طبية لهذا المريض',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => isPrescribedMedicinesLoading = true);

    try {
      await fetchPrescribedMedicines();
      _showPrescribedMedicinesList();
    } catch (e) {
      print("خطأ أثناء جلب الأدوية الموصوفة: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء تحميل الأدوية',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isPrescribedMedicinesLoading = false);
    }
  }

  void _showPrescribedMedicinesList() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 129, 237, 194).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Color.fromARGB(255, 129, 237, 194),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الأدوية الموصوفة',
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 129, 237, 194),
                        ),
                      ),
                      Text(
                        'قائمة الأدوية المحددة للمريض',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: isPrescribedMedicinesLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 129, 237, 194),
                      ),
                    )
                  : prescribedMedicines.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medication_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد أدوية موصوفة',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: prescribedMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = prescribedMedicines[index];
                        return _buildMedicineItem(medicine, index);
                      },
                    ),
            ),
            const SizedBox(height: 16),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    if (prescriptionId == null) {
                      Navigator.pop(context);
                      return;
                    }

                    try {
                      final url = Uri.parse(
                        '$baseUrl/api/delete_prescription/$prescriptionId',
                      );
                      final response = await http.delete(
                        url,
                        headers: {'Authorization': 'Bearer ${widget.token}'},
                      );

                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم حذف الوصفة الطبية بنجاح',
                              style: GoogleFonts.cairo(),
                            ),
                            backgroundColor: const Color.fromARGB(255, 129, 237, 194),
                          ),
                        );
                        setState(() {
                          prescribedMedicines = [];
                          prescriptionId = null;
                        });
                      } else {
                        throw Exception('فشل في حذف الوصفة');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'حدث خطأ أثناء حذف الوصفة',
                            style: GoogleFonts.cairo(),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    "Delete",
                    style: GoogleFonts.cairo(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: Text(
                    "تأكيد",
                    style: GoogleFonts.cairo(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 129, 237, 194),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineItem(Map<String, dynamic> medicine, int index) {
    String? imageUrl;
    if (medicine['image'] != null && medicine['image'].toString().isNotEmpty) {
      imageUrl = "$baseUrl${medicine['image']}";
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.medication,
                    color: Color.fromARGB(255, 129, 237, 194),
                  ),
                ),
              )
            : const Icon(Icons.medication, color: Color.fromARGB(255, 129, 237, 194)),
        title: Text(
          medicine['name'] ?? 'بدون اسم',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Dose: ${medicine['dose']?.toString() ?? 'غير محدد'}",
          style: GoogleFonts.cairo(),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 129, 237, 194).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '#${index + 1}',
            style: GoogleFonts.cairo(
              color: const Color.fromARGB(255, 129, 237, 194),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoTile(
    String title,
    String value,
    IconData icon, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color ?? Colors.teal[200],
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value, style: GoogleFonts.cairo()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 129, 237, 194),
          title: Text('تفاصيل المريض', style: GoogleFonts.cairo(fontSize: 22)),
          centerTitle: true,
        ),
        body: isLoading
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                        ),
                        title: Container(
                          height: 10,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                        ),
                        subtitle: Container(height: 10, color: Colors.white),
                      ),
                    ),
                  );
                },
              )
            : hasError
            ? const Center(child: Text("⚠️ حدث خطأ أثناء تحميل البيانات"))
            : AnimationLimiter(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 500),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.teal[100],
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: DefaultTextStyle(
                          style: GoogleFonts.cairo(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 129, 237, 194),
                          ),
                          child: SizedBox(
                            height: 50,
                            child: Center(
                              child:
                                  const Text(
                                        "Patient Medical Record",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                      .animate()
                                      .slide(
                                        begin: const Offset(-1, 0),
                                        end: const Offset(0, 0),
                                        duration: 5000.ms,
                                        curve: Curves.easeOut,
                                      ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildInfoTile(
                        "Name",
                        patient!['name'] ?? 'null',
                        Icons.person,
                      ),
                      buildInfoTile(
                        "Phone",
                        patient!['phone'],
                        Icons.phone,
                        color: Colors.greenAccent,
                      ),
                      buildInfoTile(
                        "City",
                        patient!['location'],
                        Icons.location_city,
                        color: Colors.orangeAccent,
                      ),
                      buildInfoTile(
                        "Gender",
                        patient!['gender'],
                        Icons.transgender,
                        color: Colors.purpleAccent,
                      ),
                      buildInfoTile(
                        "Birth Date",
                        patient!['birth_date'],
                        Icons.cake,
                        color: Colors.pinkAccent,
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => showDiseases = !showDiseases),
                        child: buildInfoTile(
                          "Diseases",
                          showDiseases ? "Tap to hide" : "Tap to view details",
                          FontAwesomeIcons.notesMedical, // أيقونة عامة للأمراض
                          color: Colors.redAccent,
                        ),
                      ),
                      if (showDiseases) ...[
                        buildInfoTile(
                          "Eyestrain",
                          patient!['Eyestrain'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.eye,
                          color: Colors.blue,
                        ),
                        buildInfoTile(
                          "Astigmatism",
                          patient!['Astigmatism'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.eyeDropper,
                          color: Colors.deepOrange,
                        ),
                        buildInfoTile(
                          "Pressure",
                          patient!['pressure'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.heartPulse,
                          color: Colors.red,
                        ),
                        buildInfoTile(
                          "Diabetes",
                          patient!['diabtes'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.prescription,
                          color: Colors.orange,
                        ),
                        buildInfoTile(
                          "Color Blindness",
                          patient!['Color_blindness'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.palette,
                          color: Colors.purple,
                        ),
                        buildInfoTile(
                          "Strabismus",
                          patient!['Strabismus'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.eyeSlash,
                          color: Colors.teal,
                        ),
                        buildInfoTile(
                          "Allergy",
                          patient!['allergy'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.allergies,
                          color: Colors.green,
                        ),
                        buildInfoTile(
                          "Dry Eye",
                          patient!['Dry_eye'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.droplet,
                          color: Colors.cyan,
                        ),
                        buildInfoTile(
                          "Retinal Detachment",
                          patient!['Retinal_detachment'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.eyeSlash,
                          color: Colors.redAccent,
                        ),
                        buildInfoTile(
                          "Keratoconus",
                          patient!['Keratoconus'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.eye,
                          color: Colors.orangeAccent,
                        ),
                        buildInfoTile(
                          "Conjunctivitis",
                          patient!['Conjunctivitis'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.hospital,
                          color: Colors.pink,
                        ),
                        buildInfoTile(
                          "Cataract",
                          patient!['Cataract'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.solidEye,
                          color: Colors.grey,
                        ),
                        buildInfoTile(
                          "Glaucoma",
                          patient!['Glaucoma'] == 1 ? "Yes" : "No",
                          FontAwesomeIcons.eye,
                          color: Colors.deepPurple,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          activeIcon: Icons.close,
          backgroundColor: const Color.fromARGB(255, 129, 237, 194),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.refresh),
              label: 'تحديث البيانات',
              onTap: () {
                setState(() {
                  isLoading = true;
                  hasError = false;
                });
                fetchPatientData();
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.event_available),
              label: 'المواعيد القادمة',
              onTap: () => showAppointmentModal('upcoming', widget.patientId),
            ),
            SpeedDialChild(
              child: const Icon(Icons.history),
              label: 'المواعيد السابقة',
              onTap: () => showAppointmentModal('previous', widget.patientId),
            ),
            SpeedDialChild(
              child: const Icon(Icons.medical_services),
              label: 'وصف دواء جديد',
              onTap: () => showDrugPicker(),
            ),
            SpeedDialChild(
              child: const Icon(Icons.healing),
              label: 'إضافة علاج',
              onTap: () => _showAddTreatmentForm(context),
            ),

          ],
        ),
      ),
    );
  }
}
