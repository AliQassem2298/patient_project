// screens/patient_appointments_screen.dart

import 'package:flutter/material.dart';
import 'package:patient_project/models/ali_appointment_model.dart';
import 'package:patient_project/services/deleteAppointment%20service.dart';

import 'package:patient_project/services/pastappointments_service.dart';
import 'package:patient_project/services/upcomingappointments_service.dart';

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // بيانات المواعيد
  final List<AliAppointment> _upcomingAppointments = [];
  final List<AliAppointment> _pastAppointments = [];

  // حالة التحميل
  bool _loadingUpcoming = false;
  bool _loadingPast = false;
  bool _hasMoreUpcoming = true;
  bool _hasMorePast = true;

  // الصفحات
  int _upcomingPage = 1;
  int _pastPage = 1;

  // الخدمات
  final UpcomingappointmentsService _upcomingService =
      UpcomingappointmentsService();
  final PastappointmentsService _pastService = PastappointmentsService();
  final DeleteappointmentService _deleteService = DeleteappointmentService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // تحميل المواعيد اللاحقة عند الفتح
    _loadUpcomingAppointments();

    // تحميل المواعيد السابقة عند تغيير التبويب
    _tabController.addListener(() {
      if (_tabController.index == 1 &&
          _pastAppointments.isEmpty &&
          !_loadingPast) {
        _loadPastAppointments();
      }
    });
  }

  Future<void> _loadUpcomingAppointments() async {
    if (!_hasMoreUpcoming || _loadingUpcoming) return;

    setState(() {
      _loadingUpcoming = true;
    });

    try {
      final result =
          await _upcomingService.getUpcomingAppointments(_upcomingPage);
      if (result.appointments.isNotEmpty) {
        _upcomingAppointments.addAll(result.appointments);
        _hasMoreUpcoming = result.nextPageUrl != null;
        _upcomingPage++;
      } else {
        _hasMoreUpcoming = false;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تحميل المواعيد اللاحقة: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingUpcoming = false;
        });
      }
    }
  }

  Future<void> _loadPastAppointments() async {
    if (!_hasMorePast || _loadingPast) return;

    setState(() {
      _loadingPast = true;
    });

    try {
      final result = await _pastService.getPastAppointments(_pastPage);
      if (result.appointments.isNotEmpty) {
        _pastAppointments.addAll(result.appointments);
        _hasMorePast = result.nextPageUrl != null;
        _pastPage++;
      } else {
        _hasMorePast = false;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تحميل المواعيد السابقة: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingPast = false;
        });
      }
    }
  }

  Future<void> _refreshUpcoming() async {
    _upcomingAppointments.clear();
    _upcomingPage = 1;
    _hasMoreUpcoming = true;
    await _loadUpcomingAppointments();
  }

  Future<void> _refreshPast() async {
    _pastAppointments.clear();
    _pastPage = 1;
    _hasMorePast = true;
    await _loadPastAppointments();
  }

  // ✅ إلغاء الحجز
  Future<void> _cancelAppointment(int appointmentId) async {
    try {
      final result =
          await _deleteService.deleteappointment(appointmentId: appointmentId);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(result.message)));
      }
      _upcomingAppointments.removeWhere((appt) => appt.id == appointmentId);
      if (mounted) setState(() {});
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الإلغاء: ${e.toString()}')),
        );
      }
    }
  }

  void _showCancelDialog(AliAppointment appointment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الإلغاء'),
        content: Text(
            'هل أنت متأكد أنك تريد إلغاء موعدك مع الطبيب رقم ${appointment.doctorId}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _cancelAppointment(appointment.id);
            },
            child: const Text('تأكيد', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواعيدي'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'اللاحقة'),
            Tab(text: 'السابقة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // المواعيد اللاحقة
          RefreshIndicator(
            onRefresh: _refreshUpcoming,
            child: _upcomingAppointments.isEmpty && !_loadingUpcoming
                ? const Center(child: Text('لا توجد مواعيد قادمة'))
                : NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo is ScrollEndNotification) {
                        final metrics = scrollInfo.metrics;
                        if (metrics.extentAfter == 0 && _hasMoreUpcoming) {
                          _loadUpcomingAppointments();
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _upcomingAppointments.length +
                          (_loadingUpcoming && _hasMoreUpcoming ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _upcomingAppointments.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final appt = _upcomingAppointments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calendar_today,
                                  color: Colors.blue),
                            ),
                            title: Text(
                              '${appt.date} - ${appt.time}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('رقم الطبيب: ${appt.doctorId}'),
                                Text(
                                  appt.isBooked == 1 ? '✅ محجوز' : '🟢 متاح',
                                  style: TextStyle(
                                    color: appt.isBooked == 1
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            // ✅ تمكين النقر على الكارت
                            onTap: () {
                              if (appt.isBooked == 1) {
                                _showCancelDialog(appt);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('هذا الموعد غير محجوز')),
                                );
                              }
                            },
                            // ✅ زر الحذف يظهر فقط إذا كان محجوزًا
                            trailing: appt.isBooked == 1
                                ? ElevatedButton.icon(
                                    icon: const Icon(Icons.cancel, size: 16),
                                    label: const Text('إلغاء'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                    ),
                                    onPressed: () => _showCancelDialog(appt),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
          ),

          // المواعيد السابقة
          RefreshIndicator(
            onRefresh: _refreshPast,
            child: _pastAppointments.isEmpty && !_loadingPast
                ? const Center(child: Text('لا توجد مواعيد سابقة'))
                : NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo is ScrollEndNotification) {
                        final metrics = scrollInfo.metrics;
                        if (metrics.extentAfter == 0 && _hasMorePast) {
                          _loadPastAppointments();
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _pastAppointments.length +
                          (_loadingPast && _hasMorePast ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _pastAppointments.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final appt = _pastAppointments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calendar_today,
                                  color: Colors.grey),
                            ),
                            title: Text(
                              '${appt.date} - ${appt.time}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('رقم الطبيب: ${appt.doctorId}'),
                            trailing: const Icon(Icons.history,
                                size: 16, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
