// screens/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:patient_project/models/get_favorites_model.dart';
import 'package:patient_project/screens/DoctorProfileScreen.dart';
import 'package:patient_project/services/get_favorites_service.dart';
import 'package:patient_project/services/remove_favorite_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<GetFavoritesModel>> _favoritesFuture;
  final GetFavoritesService _getFavoritesService = GetFavoritesService();
  final RemoveFavoriteService _removeFavoriteService = RemoveFavoriteService();

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _getFavoritesService.getFavorites();
  }

  Future<void> _refreshFavorites() async {
    setState(() {
      _favoritesFuture = _getFavoritesService.getFavorites();
    });
  }

  Future<void> _removeFromFavorites(int doctorId) async {
    try {
      await _removeFavoriteService.removeFavorite(doctorId: doctorId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم الحذف من المفضلة'),
          backgroundColor: Colors.blue,
        ),
      );
      _refreshFavorites(); // تحديث القائمة
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأطباء المفضلون'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFavorites,
        child: FutureBuilder<List<GetFavoritesModel>>(
          future: _favoritesFuture,
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
                    Text('خطأ: ${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _refreshFavorites,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'لا يوجد أطباء في المفضلة بعد',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final favorites = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final doctor = favorites[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DoctorProfileScreen(doctorId: doctor.id),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // صورة الطبيب (حرف أول)
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.deepPurple[100],
                            child: Text(
                              doctor.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // التفاصيل
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'خبرة: ${doctor.yearsOfExperience} سنة',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'تخرج: ${doctor.graduationDate}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // زر الحذف
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'حذف من المفضلة',
                            onPressed: () =>
                                _showDeleteConfirmation(doctor.id, doctor.name),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // منبثق تأكيد الحذف
  void _showDeleteConfirmation(int doctorId, String doctorName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريد حذف "$doctorName" من المفضلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _removeFromFavorites(doctorId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
