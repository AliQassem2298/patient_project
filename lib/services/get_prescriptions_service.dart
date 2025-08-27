import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/get_prescriptions_model.dart';

class GetPrescriptionsService {
  Future<List<GetPrescriptionsModel>> getPrescriptions() async {
    List<dynamic> data = await Api().get(
      url: '$baseUrl/getPrescriptions',
      token: sharedPreferences!.getString('token'),
    );
    return data.map((item) => GetPrescriptionsModel.fromJson(item)).toList();
  }
}
