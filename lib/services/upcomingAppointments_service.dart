// services/upcomingappointments_service.dart

import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/upcoming_appointments_model.dart';

class UpcomingappointmentsService {
  Future<UpcomingAppointmentsResponse> getUpcomingAppointments(int page) async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/upcomingAppointments?page=$page',
      token: sharedPreferences!.getString('token'),
    );
    return UpcomingAppointmentsResponse.fromJson(data);
  }
}
