import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/get_notificationById_model.dart';

class GetNotificationbyidService {
  Future<GetNotificationbyidModel> getNotificationbyid({
    required int notificationId,
  }) async {
    Map<String, dynamic> data = await Api().post(
      url: '$baseUrl/getNotificationById',
      body: {
        "id": notificationId,
      },
      token: sharedPreferences!.getString('token'),
    );
    return GetNotificationbyidModel.fromJson(data);
  }
}
