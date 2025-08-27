// في الخدمة
import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';

class UnreadNotificationsService {
  Future<int> unreadNotifications() async {
    List<dynamic> response = await Api().get(
      url: '$baseUrl/unread',
      token: sharedPreferences!.getString('token'),
    );

    if (response.isNotEmpty) {
      final dynamic count = response[0];
      if (count is int) {
        return count;
      } else if (count is String) {
        return int.tryParse(count) ?? 0;
      }
    }

    return 0;
  }
}
