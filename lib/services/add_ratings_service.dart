import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/massage_model.dart';

class AddRatingsService {
  Future<MassageModel> addRatings({
    required int doctorId,
    required int stars,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/add_ratings',
      body: {
        "doctor_id": doctorId,
        "stars": stars,
      },
      token: sharedPreferences!.getString('token'),
    );
    return MassageModel.fromJson(data);
  }
}
