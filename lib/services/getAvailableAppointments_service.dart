import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/ali_appointment_model.dart';

class GetavailableappointmentsService {
  Future<AliAppointmentModel> getavailableappointments({
    required int doctorId,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/appointments/available',
      body: {
        "doctor_id": doctorId,
      },
      token: sharedPreferences!.getString('token'),
    );
    return AliAppointmentModel.fromJson(data);
  }
}
