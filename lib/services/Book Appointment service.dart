import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/massage_model.dart';

class Bookappointmentservice {
  Future<MassageModel> bookAppointment({
    required int doctorId,
    required int appointmentId,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/appointments/booked',
      body: {
        "doctor_id": doctorId,
        "appointment_id": appointmentId,
      },
      token: sharedPreferences!.getString('token'),
    );
    return MassageModel.fromJson(data);
  }
}
