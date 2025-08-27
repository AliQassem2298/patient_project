import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/email_model.dart';

class SecurityInfoService {
  Future<EmailModel> securityInfo() async {
    Map<String, dynamic> data = await Api().get(
      url: '$baseUrl/Security_info',
      token: sharedPreferences!.getString('token'),
    );
    return EmailModel.fromJson(data);
  }
}
