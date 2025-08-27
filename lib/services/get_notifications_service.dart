// services/get_notifications_service.dart

import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/get_notifications_model.dart';

class GetNotificationsService {
  Future<GetNotificationsModel> getNotifications() async {
    List<dynamic> data = await Api().get(
      url: '$baseUrl/getNotifications',
      token: sharedPreferences!.getString('token'),
    );

    return GetNotificationsModel.fromJson(data);
  }
}
