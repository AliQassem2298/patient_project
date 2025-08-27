import 'package:patient_project/helper/api.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/get_favorites_model.dart';

class GetFavoritesService {
  Future<List<GetFavoritesModel>> getFavorites() async {
    List<dynamic> data = await Api().get(
      url: '$baseUrl/get_favorites',
      token: sharedPreferences!.getString('token'),
    );
    return data.map((item) => GetFavoritesModel.fromJson(item)).toList();
  }
}
