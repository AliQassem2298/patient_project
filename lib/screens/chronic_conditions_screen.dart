// screens/chronic_conditions_screen.dart

import 'package:flutter/material.dart';
import 'package:patient_project/models/medical_info_model.dart';
import 'package:patient_project/services/medical_info_service.dart';

class ChronicConditionsScreen extends StatefulWidget {
  const ChronicConditionsScreen({super.key});

  @override
  State<ChronicConditionsScreen> createState() =>
      _ChronicConditionsScreenState();
}

class _ChronicConditionsScreenState extends State<ChronicConditionsScreen> {
  late Future<MedicalInfoModel> _medicalInfoFuture;
  final MedicalInfoService _service = MedicalInfoService();

  @override
  void initState() {
    super.initState();
    _medicalInfoFuture = _service.medicalInfo();
  }

  // دالة لتحويل الرقم إلى أيقونة
  Widget _buildStatusIcon(int value) {
    return value == 1
        ? const Icon(Icons.check_circle, color: Colors.green, size: 24)
        : const Icon(Icons.cancel, color: Colors.red, size: 24);
  }

  // دالة لترجمة اسم المرض

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأمراض المزمنة'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _medicalInfoFuture = _service.medicalInfo();
          });
        },
        child: FutureBuilder<MedicalInfoModel>(
          future: _medicalInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 60),
                    const SizedBox(height: 10),
                    Text('خطأ: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _medicalInfoFuture = _service.medicalInfo();
                        });
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(child: Text('لا توجد بيانات'));
            }

            final data = snapshot.data!;

            // تحويل البيانات إلى قائمة
            final conditions = [
              {'label': 'إجهاد العين', 'value': data.eyeStrain},
              {'label': 'استجماتيزم', 'value': data.astigmatism},
              {'label': 'ارتفاع ضغط العين', 'value': data.pressure},
              {'label': 'سكري', 'value': data.diabetes},
              {'label': 'عمى الألوان', 'value': data.colorBlindness},
              {'label': 'حول العين', 'value': data.strabismus},
              {'label': 'جفاف العين', 'value': data.dryEye},
              {'label': 'حساسية العين', 'value': data.allergy},
              {'label': 'انفصال الشبكية', 'value': data.retinalDetachment},
              {'label': 'التهاب العين (حمرة)', 'value': data.conjunctivitis},
              {'label': 'تقرن مخروطي', 'value': data.keratoconus},
              {'label': 'المياه الزرقاء', 'value': data.glaucoma},
              {'label': 'الماء الأبيض', 'value': data.cataract},
            ];

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: conditions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final condition = conditions[index];
                return ListTile(
                  title: Text(
                    condition['label'] as String,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: _buildStatusIcon(condition['value'] as int),
                  visualDensity: VisualDensity.comfortable,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
