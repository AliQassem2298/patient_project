// models/get_notifications_model.dart

class GetNotificationsModel {
  final List<TransactionModel> transactions;

  GetNotificationsModel({required this.transactions});

  factory GetNotificationsModel.fromJson(List<dynamic> json) {
    if (json.isEmpty) {
      return GetNotificationsModel(transactions: []);
    }

    // نأخذ أول عنصر، وهو القائمة الداخلية
    final List<dynamic> innerList = json[0] is List ? json[0] : json;

    final List<TransactionModel> transactions = innerList
        .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return GetNotificationsModel(transactions: transactions);
  }
}

class TransactionModel {
  final int id;
  final int userId;
  final String title;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.title,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
    );
  }
}
