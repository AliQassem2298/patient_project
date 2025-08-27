// screens/treatments_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_project/models/get_treatments_model.dart';
import 'package:patient_project/models/get_balance_model.dart';
import 'package:patient_project/services/get_treatments_service.dart';
import 'package:patient_project/services/pay_service.dart';
import 'package:patient_project/services/get_balance_service.dart';

class TreatmentsScreen extends StatefulWidget {
  const TreatmentsScreen({super.key});

  @override
  State<TreatmentsScreen> createState() => _TreatmentsScreenState();
}

class _TreatmentsScreenState extends State<TreatmentsScreen> {
  late Future<List<MedicalRecordModel>> _treatmentsFuture;
  late Future<GetBalanceModel> _balanceFuture;
  final GetTreatmentsService _treatmentsService = GetTreatmentsService();
  final PayService _payService = PayService();
  final GetBalanceService _balanceService = GetBalanceService();

  @override
  void initState() {
    super.initState();
    _treatmentsFuture = _loadTreatments();
    _balanceFuture = _balanceService.getBalance();
  }

  Future<List<MedicalRecordModel>> _loadTreatments() async {
    try {
      final response = await _treatmentsService.getTreatments();
      return response.records;
    } catch (e) {
      throw Exception('فشل جلب السجلات: $e');
    }
  }

  // دالة الدفع
  Future<void> _payForTreatment(int treatmentId, int bill) async {
    try {
      final result = await _payService.pay(treatmentId: treatmentId);

      // تحديث القائمة والرصيد
      setState(() {
        _treatmentsFuture = _loadTreatments();
        _balanceFuture = _balanceService.getBalance();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('${result.message}\nالرصيد المتبقي: ${result.balance} ل.س'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الدفع: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // تأكيد الدفع
  void _confirmPayment(int treatmentId, int bill) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الدفع'),
        content: Text('هل تريد دفع مبلغ $bill ل.س؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _payForTreatment(treatmentId, bill);
            },
            child: const Text('تأكيد الدفع'),
          ),
        ],
      ),
    );
  }

  // تنسيق التاريخ
  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMMM yyyy', 'ar_SA').format(date);
    } catch (e) {
      return 'تاريخ غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العلاجات'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          FutureBuilder<GetBalanceModel>(
            future: _balanceFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '؟؟؟',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                final balance = snapshot.data!.balance;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'رصيدك: ${balance.toStringAsFixed(0)} ل.س',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _treatmentsFuture = _loadTreatments();
            _balanceFuture = _balanceService.getBalance();
          });
        },
        child: FutureBuilder<List<MedicalRecordModel>>(
          future: _treatmentsFuture,
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
                          _treatmentsFuture = _loadTreatments();
                        });
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_information,
                        size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'لا توجد علاجات بعد',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final records = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: records.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final record = records[index];
                final isPaid = record.paid == 1;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // التاريخ + حالة الدفع
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(record.createdAt),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Chip(
                              label: Text(
                                isPaid ? 'مدفوع' : 'غير مدفوع',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor:
                                  isPaid ? Colors.green : Colors.orange,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // التشخيص
                        _buildDetail('التشخيص', record.diagnosedDisease),

                        // الحالة الحالية
                        _buildDetail(
                            'الحالة الحالية',
                            record.recoveredDisease.isEmpty
                                ? 'لا يوجد'
                                : record.recoveredDisease),

                        // الوصف
                        if (record.description.isNotEmpty)
                          _buildDetail('الوصف', record.description),

                        // الأشعة
                        _buildDetail(
                            'الأشعة', record.xRay == 1 ? 'مطلوب' : 'غير مطلوب'),

                        // المبلغ
                        _buildDetail(
                          'المبلغ',
                          '${record.bill} ل.س',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // زر الدفع (فقط إذا غير مدفوع)
                        if (!isPaid)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _confirmPayment(record.id, record.bill),
                              icon: const Icon(Icons.payment, size: 18),
                              label: const Text('ادفع الآن'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: style ?? const TextStyle(color: Colors.grey),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
