import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/massage_model.dart';

class DeleteappointmentService {
  Future<MassageModel> deleteappointment({
    required int appointmentId,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/deleteAppointment',
      body: {
        "appointment_id": appointmentId,
      },
      token: sharedPreferences!.getString('token'),
    );
    return MassageModel.fromJson(data);
  }
}
