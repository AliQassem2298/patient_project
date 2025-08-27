import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/get_treatments_model.dart';

class GetTreatmentsService {
  Future<List<GetTreatmentsModel>> getTreatments() async {
    List<dynamic> data = await Api().get(
      url: '$baseUrl/getTreatments',
      token: sharedPreferences!.getString('token'),
    );
    return data.map((item) => GetTreatmentsModel.fromJson(item)).toList();
  }
}
