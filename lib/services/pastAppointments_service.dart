// services/pastappointments_service.dart

import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/past_appointments_model.dart';

class PastappointmentsService {
  Future<PastAppointmentsResponse> getPastAppointments(int page) async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/pastAppointments?page=$page',
      token: sharedPreferences!.getString('token'),
    );
    return PastAppointmentsResponse.fromJson(data);
  }
}
