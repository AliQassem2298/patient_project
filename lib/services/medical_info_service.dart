import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/medical_info_model.dart';

class MedicalInfoService {
  Future<MedicalInfoModel> medicalInfo() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/medical_info',
      token: sharedPreferences!.getString('token'),
    );
    return MedicalInfoModel.fromJson(data);
  }
}
