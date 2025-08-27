import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/doctor_profile_model.dart';

class GetdoctorbyidService {
  Future<DoctorProfileResponse> getdoctorbyid({
    required int doctorId,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/getDoctorById',
      body: {
        "doctor_id": doctorId,
      },
      token: sharedPreferences!.getString('token'),
    );
    return DoctorProfileResponse.fromJson(data);
  }
}
