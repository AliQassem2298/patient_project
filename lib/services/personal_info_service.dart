import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/patient_profile_model.dart';

class PersonalInfoService {
  Future<PatientProfileModel> personalInfo() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/Personal_info',
      token: sharedPreferences!.getString('token'),
    );
    return PatientProfileModel.fromJson(data);
  }
}
