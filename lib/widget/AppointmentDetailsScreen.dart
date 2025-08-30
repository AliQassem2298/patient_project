// lib/widget/AppointmentDetailsScreen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/modelSecretary_appointment.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details', style: GoogleFonts.cairo()),
        backgroundColor: const Color.fromARGB(255, 129, 237, 194),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(
              title: 'Appointment ID',
              content: appointment.id.toString(),
              icon: Icons.confirmation_number,
            ),
            _buildDetailCard(
              title: 'Doctor ID',
              content: appointment.doctorId.toString(),
              icon: Icons.local_hospital,
            ),
            _buildDetailCard(
              title: 'Patient ID',
              content: appointment.patientId.toString(),
              icon: Icons.person,
            ),
            _buildDetailCard(
              title: 'Date',
              content: appointment.date,
              icon: Icons.calendar_today,
            ),
            _buildDetailCard(
              title: 'Time',
              content: appointment.time,
              icon: Icons.access_time,
            ),
            _buildDetailCard(
              title: 'Booking Status',
              content: appointment.isBooked == 1 ? 'Booked' : 'Not Booked',
              icon: Icons.check_circle,
            ),
            _buildDetailCard(
              title: 'Appointment Time (UTC)',
              content: appointment.appointmentTime?.toIso8601String() ?? 'N/A',
              icon: Icons.schedule,
            ),
            _buildDetailCard(
              title: 'Created At',
              content: appointment.createdAt?.toIso8601String() ?? 'N/A',
              icon: Icons.history,
            ),
            _buildDetailCard(
              title: 'Updated At',
              content: appointment.updatedAt?.toIso8601String() ?? 'N/A',
              icon: Icons.update,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      {required String title,
      required String content,
      required IconData icon}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 129, 237, 194)),
        title:
            Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        subtitle: Text(content, style: GoogleFonts.cairo(fontSize: 16)),
      ),
    );
  }
}
