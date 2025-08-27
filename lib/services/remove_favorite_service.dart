import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/massage_model.dart';

class RemoveFavoriteService {
  Future<MassageModel> removeFavorite({
    required int doctorId,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/favorites/remove',
      body: {
        "doctor_id": doctorId,
      },
      token: sharedPreferences!.getString('token'),
    );
    return MassageModel.fromJson(data);
  }
}
