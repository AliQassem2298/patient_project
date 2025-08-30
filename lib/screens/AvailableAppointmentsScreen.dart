// available_appointments_screen.dart

import 'package:flutter/material.dart';
import 'package:patient_project/models/ali_appointment_model.dart';
import 'package:patient_project/services/Book%20Appointment%20service.dart';
import 'package:patient_project/services/deleteAppointment%20service.dart';
import 'package:patient_project/services/getAvailableAppointments_service.dart';

class AvailableAppointmentsScreen extends StatefulWidget {
  final int doctorId;

  const AvailableAppointmentsScreen({super.key, required this.doctorId});

  @override
  State<AvailableAppointmentsScreen> createState() =>
      _AvailableAppointmentsScreenState();
}

class _AvailableAppointmentsScreenState
    extends State<AvailableAppointmentsScreen> {
  late Future<AliAppointmentModel> _appointmentsFuture;
  final GetavailableappointmentsService _getAppointmentsService =
      GetavailableappointmentsService();
  final Bookappointmentservice _bookService = Bookappointmentservice();
  final DeleteappointmentService _deleteService = DeleteappointmentService();

  @override
  void initState() {
    super.initState();
    _refreshAppointments();
  }

  void _refreshAppointments() {
    setState(() {
      _appointmentsFuture = _getAppointmentsService.getavailableappointments(
          doctorId: widget.doctorId);
    });
  }

  Future<void> _bookAppointment(int appointmentId) async {
    try {
      final result = await _bookService.bookAppointment(
        doctorId: widget.doctorId,
        appointmentId: appointmentId,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
      _refreshAppointments(); // تحديث القائمة بعد الحجز
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الحجز: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _deleteAppointment(int appointmentId) async {
    try {
      final result =
          await _deleteService.deleteappointment(appointmentId: appointmentId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
      _refreshAppointments(); // تحديث القائمة بعد الإلغاء
    } on Exception catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل الإلغاء: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المواعيد المتاحة'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshAppointments(),
        child: FutureBuilder<AliAppointmentModel>(
          future: _appointmentsFuture,
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
                    Text(
                      'خطأ في جلب البيانات',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _refreshAppointments,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData ||
                snapshot.data!.appointments.isEmpty) {
              return const Center(
                child: Text('لا توجد مواعيد متاحة'),
              );
            }

            final appointments = snapshot.data!.appointments;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appt = appointments[index];
                final isBooked = appt.isBooked == 1;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(
                      '${appt.date} - ${appt.time}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('رقم الموعد: ${appt.id}'),
                        Text(isBooked ? '✅ محجوز' : '🟢 متاح'),
                      ],
                    ),
                    trailing: isBooked
                        ? ElevatedButton.icon(
                            icon: const Icon(Icons.cancel, size: 16),
                            label: const Text('إلغاء'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _deleteAppointment(appt.id),
                          )
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.book, size: 16),
                            label: const Text('حجز'),
                            onPressed: () => _bookAppointment(appt.id),
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
}
