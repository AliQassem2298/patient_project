// screens/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient_project/models/get_notifications_model.dart';
import 'package:patient_project/services/get_notifications_service.dart';
import 'package:patient_project/services/get_notificationbyid_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<TransactionModel>> _notificationsFuture;
  final GetNotificationsService _getNotifService = GetNotificationsService();
  final GetNotificationbyidService _getByIdService =
      GetNotificationbyidService();

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _loadNotifications();
  }

  Future<List<TransactionModel>> _loadNotifications() async {
    try {
      final response = await _getNotifService.getNotifications();
      return response.transactions;
    } catch (e) {
      throw Exception('فشل جلب الإشعارات: $e');
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMMM yyyy - hh:mm a').format(date);
    } catch (e) {
      return 'تاريخ غير معروف';
    }
  }

  Future<void> _showNotificationDetails(int notificationId) async {
    try {
      final details = await _getByIdService.getNotificationbyid(
          notificationId: notificationId);

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(details.title,
              style: const TextStyle(color: Colors.deepPurple)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('الرسالة: ${details.content}'),
                if (details.response != null)
                  Text('الرد: ${details.response!}'),
                if (details.date != null) Text('التاريخ: ${details.date!}'),
                if (details.doctorId != null)
                  Text('رقم الطبيب: ${details.doctorId!}'),
                const SizedBox(height: 8),
                Text(
                  'Created date: ${_formatDate(details.createdAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      );

      // تحديث القائمة
      if (mounted) {
        setState(() {
          _notificationsFuture = _loadNotifications();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في جلب التفاصيل: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _notificationsFuture = _loadNotifications();
          });
        },
        child: FutureBuilder<List<TransactionModel>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 60),
                    const SizedBox(height: 10),
                    Text('خطأ: ${snapshot.error}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _notificationsFuture = _loadNotifications();
                        });
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'لا توجد إشعارات',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final notifications = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.notifications,
                        color: Colors.deepPurple),
                    title: Text(
                      notif.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('اضغط لعرض التفاصيل'),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                    onTap: () => _showNotificationDetails(notif.id),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
