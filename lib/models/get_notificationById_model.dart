// models/notification_model.dart

class GetNotificationbyidModel {
  final int id;
  final int userId;
  final bool isRead;
  final String title;
  final String content;
  final String? response; // يمكن أن تكون null
  final String? date; // يمكن أن تكون null
  final int? doctorId; // يمكن أن تكون null
  final String createdAt;
  final String updatedAt;

  GetNotificationbyidModel({
    required this.id,
    required this.userId,
    required this.isRead,
    required this.title,
    required this.content,
    this.response,
    this.date,
    this.doctorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetNotificationbyidModel.fromJson(Map<String, dynamic> json) {
    return GetNotificationbyidModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      isRead: json['is_read'] as bool,
      title: json['title'] as String,
      content: json['content'] as String,
      response: json['response'] as String?,
      date: json['date'] as String?,
      doctorId: json['doctor_id'] as int?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
