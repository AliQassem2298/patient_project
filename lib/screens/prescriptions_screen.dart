// screens/prescriptions_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_project/helper/api.dart';
import 'package:patient_project/models/get_prescriptions_model.dart';
import 'package:patient_project/services/get_prescriptions_service.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  late Future<GetPrescriptionsModel> _prescriptionsFuture;
  final GetPrescriptionsService _service = GetPrescriptionsService();

  @override
  void initState() {
    super.initState();
    _prescriptionsFuture = _service.getPrescriptions();
  }

  Future<GetPrescriptionsModel> _loadPrescriptions() async {
    try {
      return await _service.getPrescriptions();
    } catch (e) {
      throw Exception('فشل جلب الوصفات: $e');
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return 'تاريخ غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الوصفات الطبية'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _prescriptionsFuture = _loadPrescriptions();
          });
        },
        child: FutureBuilder<GetPrescriptionsModel>(
          future: _prescriptionsFuture,
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
                          _prescriptionsFuture = _loadPrescriptions();
                        });
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData ||
                snapshot.data!.prescriptions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'لا توجد وصفات طبية بعد',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final prescriptions = snapshot.data!.prescriptions;

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: prescriptions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final prescription = prescriptions[index];
                final hasMedicines = prescription.medicines.isNotEmpty;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: hasMedicines
                      ? ExpansionTile(
                          title: _buildPrescriptionHeader(prescription),
                          subtitle: Text(
                            'عدد الأدوية: ${prescription.medicines.length}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: const Icon(Icons.arrow_drop_down,
                              color: Colors.deepPurple),
                          children: [
                            const Divider(height: 1),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount: prescription.medicines.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, medIndex) {
                                final med = prescription.medicines[medIndex];
                                return _buildMedicineItem(med);
                              },
                            ),
                          ],
                        )
                      : ListTile(
                          title: _buildPrescriptionHeader(prescription),
                          subtitle: const Text(
                            'لا توجد أدوية في هذه الوصفة',
                            style: TextStyle(color: Colors.grey),
                          ),
                          leading: const Icon(Icons.description_outlined,
                              color: Colors.grey),
                        ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrescriptionHeader(Prescription prescription) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recipe date: ${_formatDate(prescription.date)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'الطبيب: د. ${prescription.doctorId}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineItem(Medicine medicine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.deepPurple[100],
            image: medicine.image.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage('$baseUrlImage${medicine.image}'),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: medicine.image.isEmpty
              ? Center(
                  child: Text(
                    medicine.tradeName.isNotEmpty
                        ? medicine.tradeName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicine.tradeName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'الاسم العلمي: ${medicine.scientificName}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                'الجرعة: ${medicine.dose} مرة/يوم',
                style: const TextStyle(fontSize: 13, color: Colors.blue),
              ),
              Text(
                'التعليمات: ${medicine.instructions}',
                style:
                    const TextStyle(fontSize: 13, fontStyle: FontStyle.normal),
              ),
              Text(
                'Finish date: ${_formatDate(medicine.finishDate)}',
                style: const TextStyle(fontSize: 13, color: Colors.orange),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
