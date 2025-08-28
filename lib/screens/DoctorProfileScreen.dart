// // screens/doctor_profile_screen.dart

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:patient_project/models/doctor_profile_model.dart';
// import 'package:patient_project/screens/AvailableAppointmentsScreen.dart';
// import 'package:patient_project/services/getdoctorbyid_service.dart';
// import 'package:patient_project/services/add_comment_service.dart';
// import 'package:patient_project/services/delete_comment_service.dart';
// import 'package:patient_project/services/add_ratings_service.dart';
// import 'package:patient_project/services/add_favorite_service.dart';
// import 'package:patient_project/services/remove_favorite_service.dart';
// import 'package:patient_project/models/massage_model.dart';

// class DoctorProfileScreen extends StatefulWidget {
//   final int doctorId;

//   const DoctorProfileScreen({super.key, required this.doctorId});

//   @override
//   State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
// }

// class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
//   late Future<DoctorProfileResponse> _profileFuture;
//   final GetdoctorbyidService _getDoctorService = GetdoctorbyidService();
//   final AddCommentService _addCommentService = AddCommentService();
//   final DeleteCommentService _deleteCommentService = DeleteCommentService();
//   final AddRatingsService _addRatingService = AddRatingsService();
//   final AddFavoriteService _addFavoriteService = AddFavoriteService();
//   final RemoveFavoriteService _removeFavoriteService = RemoveFavoriteService();

//   bool _isFavorite = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadFavoriteStatus();
//     _profileFuture = _getDoctorService.getdoctorbyid(doctorId: widget.doctorId);
//   }

//   // تحميل حالة المفضلة من الـ SharedPreferences
//   Future<void> _loadFavoriteStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'favorite_doctor_${widget.doctorId}';
//     final isFav = prefs.getBool(key) ?? false;
//     if (mounted) {
//       setState(() {
//         _isFavorite = isFav;
//       });
//     }
//   }

//   // حفظ حالة المفضلة
//   Future<void> _saveFavoriteStatus(bool isFav) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('favorite_doctor_${widget.doctorId}', isFav);
//   }

//   // دالة لتحديث الصفحة (إعادة جلب البيانات)
//   Future<void> _refreshProfile() async {
//     if (mounted) {
//       setState(() {
//         _profileFuture =
//             _getDoctorService.getdoctorbyid(doctorId: widget.doctorId);
//       });
//     }
//   }

//   // إضافة تعليق
//   Future<void> _showAddCommentDialog() async {
//     final TextEditingController controller = TextEditingController();

//     late Widget dialogContent;

//     void updateDialog() {
//       if (mounted) {
//         Navigator.pop(context); // نزيل القديم
//         showDialog(
//             context: context,
//             builder: (_) => dialogContent); // نعيد إظهار المحدّث
//       }
//     }

//     dialogContent = StatefulBuilder(
//       builder: (ctx, setStateDialog) {
//         controller.addListener(() {
//           if (ctx.mounted) {
//             setStateDialog(() {}); // نُعيد بناء الـ Dialog فقط
//           }
//         });

//         return AlertDialog(
//           title: const Text('أضف تعليقك'),
//           content: TextField(
//             controller: controller,
//             maxLength: 200,
//             maxLines: 3,
//             autofocus: true,
//             decoration: const InputDecoration(
//               hintText: 'اكتب تعليقك هنا...',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: const Text('إلغاء'),
//             ),
//             ElevatedButton(
//               onPressed: controller.text.trim().isNotEmpty
//                   ? () async {
//                       final text = controller.text.trim();
//                       Navigator.pop(ctx);
//                       try {
//                         await _addCommentService.addComment(
//                           doctorId: widget.doctorId,
//                           content: text,
//                         );
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('تم إضافة التعليق بنجاح'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                         _refreshProfile();
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('خطأ: ${e.toString()}'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     }
//                   : null,
//               child: const Text('إرسال'),
//             ),
//           ],
//         );
//       },
//     );

//     return showDialog(context: context, builder: (_) => dialogContent);
//   }

//   // تعديل تعليق
//   Future<void> _showEditCommentDialog(int commentId, String oldContent) async {
//     final TextEditingController controller =
//         TextEditingController(text: oldContent);

//     return showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('عدّل تعليقك'),
//         content: TextField(
//           controller: controller,
//           maxLength: 200,
//           maxLines: 3,
//           autofocus: true,
//           decoration: const InputDecoration(
//             hintText: 'عدّل تعليقك هنا...',
//             border: OutlineInputBorder(),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: controller.text.trim().isNotEmpty
//                 ? () async {
//                     final text = controller.text.trim();
//                     Navigator.pop(ctx);
//                     try {
//                       // ملاحظة: نفترض أن الخدمة تستخدم نفس endpoint مع PUT
//                       // لو عندك خدمة updateComment، استخدمها هنا
//                       // مؤقتًا: سنحذف ثم نضيف (إذا ما في خيار تعديل)
//                       // لكن الأفضل: إضافة updateCommentService
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content:
//                               Text('تم تعديل التعليق (مؤقتًا بالحذف والإضافة)'),
//                           backgroundColor: Colors.orange,
//                         ),
//                       );
//                       // مؤقتًا: لا يوجد خدمة تعديل، لكن يمكن تطويرها لاحقًا
//                       // نحذف القديم
//                       await _deleteCommentService.deleteComment(
//                           commentId: commentId);
//                       // نضيف الجديد
//                       await _addCommentService.addComment(
//                         doctorId: widget.doctorId,
//                         content: text,
//                       );
//                       _refreshProfile();
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('خطأ: ${e.toString()}'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                     }
//                   }
//                 : null,
//             child: const Text('تحديث'),
//           ),
//         ],
//       ),
//     );
//   }

//   // حذف تعليق
//   Future<void> _confirmDeleteComment(int commentId) async {
//     return showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('تأكيد الحذف'),
//         content: const Text('هل أنت متأكد أنك تريد حذف هذا التعليق؟'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text('إلغاء'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(ctx);
//               try {
//                 await _deleteCommentService.deleteComment(commentId: commentId);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('تم حذف التعليق'),
//                     backgroundColor: Colors.blue,
//                   ),
//                 );
//                 _refreshProfile();
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('خطأ: ${e.toString()}'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('حذف'),
//           ),
//         ],
//       ),
//     );
//   }

//   // إضافة تقييم بنجوم
//   Future<void> _showRatingDialog() async {
//     int rating = 0;

//     await showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (dialogContext, setStateDialog) => AlertDialog(
//           title: const Text('قيّم الطبيب'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'اضغط على النجوم لتقييم الطبيب',
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(5, (index) {
//                   return IconButton(
//                     icon: Icon(
//                       index < rating ? Icons.star : Icons.star_border,
//                       color: Colors.orange,
//                       size: 36,
//                     ),
//                     onPressed: () {
//                       setStateDialog(() {
//                         rating = index + 1;
//                       });
//                     },
//                   );
//                 }),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext),
//               child: const Text('إلغاء'),
//             ),
//             ElevatedButton(
//               onPressed: rating == 0
//                   ? null
//                   : () async {
//                       // أغلق الـ Dialog أولاً
//                       Navigator.pop(dialogContext);

//                       // الآن استخدم الـ context الخارجي الآمن
//                       try {
//                         await _addRatingService.addRatings(
//                           doctorId: widget.doctorId,
//                           stars: rating,
//                         );
//                         // ✅ هذا آمن: لأننا خارج الـ Dialog
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('تم التقييم بنجوم: $rating'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                         _refreshProfile();
//                       } catch (e) {
//                         // ✅ آمن أيضاً
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('خطأ: ${e.toString()}'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//               child: const Text('تقييم'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _toggleFavorite(bool current) async {
//     try {
//       if (current) {
//         await _removeFavoriteService.removeFavorite(doctorId: widget.doctorId);
//         _isFavorite = false;
//       } else {
//         await _addFavoriteService.addFavorite(doctorId: widget.doctorId);
//         _isFavorite = true;
//       }
//       await _saveFavoriteStatus(_isFavorite);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               _isFavorite ? 'تمت الإضافة للمفضلة' : 'تمت الإزالة من المفضلة'),
//           backgroundColor: _isFavorite ? Colors.blue : Colors.grey,
//         ),
//       );
//       _refreshProfile();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('خطأ: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ملف الطبيب'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(
//               _isFavorite ? Icons.favorite : Icons.favorite_border,
//               color: _isFavorite ? Colors.red : Colors.white,
//             ),
//             onPressed: () => _toggleFavorite(_isFavorite),
//             tooltip: _isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshProfile,
//         child: FutureBuilder<DoctorProfileResponse>(
//           future: _profileFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.error, color: Colors.red, size: 60),
//                     const SizedBox(height: 10),
//                     Text('خطأ: ${snapshot.error}', textAlign: TextAlign.center),
//                     const SizedBox(height: 10),
//                     ElevatedButton(
//                       onPressed: _refreshProfile,
//                       child: const Text('إعادة المحاولة'),
//                     ),
//                   ],
//                 ),
//               );
//             } else if (!snapshot.hasData) {
//               return const Center(child: Text('لا توجد بيانات'));
//             }

//             final doctor = snapshot.data!.doctorProfile;

//             // تحديث حالة المفضلة من البيانات
//             if (mounted && _isFavorite != doctor.isFavorite) {
//               setState(() {
//                 _isFavorite = doctor.isFavorite;
//               });
//             }

//             return ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 // صورة الطبيب
//                 Hero(
//                   tag: 'doctor_${doctor.id}',
//                   child: CircleAvatar(
//                     radius: 70,
//                     backgroundColor: Colors.deepPurple[100],
//                     child: Text(
//                       doctor.name[0].toUpperCase(),
//                       style: const TextStyle(
//                         fontSize: 48,
//                         color: Colors.deepPurple,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // الاسم
//                 Text(
//                   doctor.name,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),

//                 // الخبرة
//                 Text(
//                   '${doctor.yearsOfExperience} سنة خبرة',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // --- أزرار الخدمات ---
//                 Card(
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         // زر التقييم
//                         _buildActionChip(
//                           icon: Icons.star,
//                           label: 'قيّم',
//                           color: Colors.orange,
//                           onPressed: _showRatingDialog,
//                         ),
//                         Container(
//                             width: 1, height: 40, color: Colors.grey[300]),
//                         // زر التعليق
//                         _buildActionChip(
//                           icon: Icons.comment,
//                           label: 'أضف',
//                           color: Colors.blue,
//                           onPressed: _showAddCommentDialog,
//                         ),
//                         Container(
//                             width: 1, height: 40, color: Colors.grey[300]),
//                         // زر الحجز
//                         _buildActionChip(
//                           icon: Icons.calendar_today,
//                           label: 'احجز',
//                           color: Colors.deepPurple,
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     AvailableAppointmentsScreen(
//                                         doctorId: widget.doctorId),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // التقييم بنجوم
//                 _buildDetailTile(
//                   'التقييم',
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: List.generate(5, (index) {
//                       return Icon(
//                         index < doctor.stars ? Icons.star : Icons.star_border,
//                         color: Colors.orange,
//                         size: 18,
//                       );
//                     }),
//                   ),
//                 ),

//                 _buildDetailTile('التخصص', 'طب عام'),
//                 _buildDetailTile('سنة التخرج', doctor.graduationDate),
//                 _buildDetailTile('مكان الدراسة', doctor.studyPlace),
//                 _buildDetailTile('المفضل', _isFavorite ? 'نعم' : 'لا'),

//                 const SizedBox(height: 30),

//                 // الشهادات
//                 const Text(
//                   'الشهادات',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 if (doctor.certificates.isNotEmpty)
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: doctor.certificates.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 8),
//                     itemBuilder: (context, index) {
//                       final cert = doctor.certificates[index];
//                       return Card(
//                         color: Colors.blue[50],
//                         child: Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: Text(
//                             cert.name,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 else
//                   const Text('لا توجد شهادات',
//                       style: TextStyle(color: Colors.grey)),

//                 const SizedBox(height: 30),

//                 // القسم: التعليقات
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'التعليقات من المرضى',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.add, color: Colors.blue),
//                       onPressed: _showAddCommentDialog,
//                       tooltip: 'أضف تعليق',
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 if (doctor.comments.isNotEmpty)
//                   ListView.separated(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: doctor.comments.length,
//                     separatorBuilder: (_, __) => const SizedBox(height: 12),
//                     itemBuilder: (context, index) {
//                       final comment = doctor.comments[index];
//                       final date = _formatDate(comment.createdAt);
//                       return Card(
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(14),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   const Icon(Icons.person_outline,
//                                       size: 16, color: Colors.grey),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     'مريض #${comment.patientId}',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 comment.content,
//                                 style:
//                                     const TextStyle(fontSize: 15, height: 1.4),
//                               ),
//                               const SizedBox(height: 6),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'في: $date',
//                                     style: TextStyle(
//                                         fontSize: 12, color: Colors.grey[600]),
//                                   ),
//                                   Row(
//                                     children: [
//                                       // IconButton(
//                                       //   icon: const Icon(Icons.edit,
//                                       //       size: 18, color: Colors.blue),
//                                       //   onPressed: () => _showEditCommentDialog(
//                                       //       comment.id, comment.content),
//                                       //   tooltip: 'تعديل',
//                                       // ),
//                                       IconButton(
//                                         icon: const Icon(Icons.delete,
//                                             size: 18, color: Colors.red),
//                                         onPressed: () =>
//                                             _confirmDeleteComment(comment.id),
//                                         tooltip: 'حذف',
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 else
//                   const Text(
//                     'لا توجد تعليقات بعد',
//                     style: TextStyle(
//                         color: Colors.grey, fontStyle: FontStyle.italic),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildActionChip({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return Expanded(
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           elevation: 2,
//         ),
//         icon: Icon(icon, size: 18, color: Colors.white),
//         label: Text(
//           label,
//           style:
//               const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailTile(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Text(
//             '$label: ',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           Expanded(
//             child: value is Widget
//                 ? value
//                 : Text(
//                     value.toString(),
//                     style: const TextStyle(color: Colors.grey),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   // تنسيق التاريخ
//   String _formatDate(String isoDate) {
//     try {
//       final date = DateTime.parse(isoDate);
//       return DateFormat('dd MMMM yyyy - hh:mm a').format(date);
//     } catch (e) {
//       return 'تاريخ غير معروف';
//     }
//   }
// }

// screens/doctor_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:patient_project/models/doctor_profile_model.dart';
import 'package:patient_project/screens/AvailableAppointmentsScreen.dart';
import 'package:patient_project/services/getdoctorbyid_service.dart';
import 'package:patient_project/services/add_comment_service.dart';
import 'package:patient_project/services/delete_comment_service.dart';
import 'package:patient_project/services/add_ratings_service.dart';
import 'package:patient_project/services/add_favorite_service.dart';
import 'package:patient_project/services/remove_favorite_service.dart';

class DoctorProfileScreen extends StatefulWidget {
  final int doctorId;

  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  late Future<DoctorProfileResponse> _profileFuture;
  final GetdoctorbyidService _getDoctorService = GetdoctorbyidService();
  final AddCommentService _addCommentService = AddCommentService();
  final DeleteCommentService _deleteCommentService = DeleteCommentService();
  final AddRatingsService _addRatingService = AddRatingsService();
  final AddFavoriteService _addFavoriteService = AddFavoriteService();
  final RemoveFavoriteService _removeFavoriteService = RemoveFavoriteService();

  @override
  void initState() {
    super.initState();
    _profileFuture = _getDoctorService.getdoctorbyid(doctorId: widget.doctorId);
  }

  // حفظ حالة المفضلة في SharedPreferences
  Future<void> _saveFavoriteStatus(bool isFav) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('favorite_doctor_${widget.doctorId}', isFav);
  }

  // دالة لتحديث الصفحة
  Future<void> _refreshProfile() async {
    if (mounted) {
      setState(() {
        _profileFuture =
            _getDoctorService.getdoctorbyid(doctorId: widget.doctorId);
      });
    }
  }

  // إضافة تعليق
  Future<void> _showAddCommentDialog() async {
    final TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setStateDialog) {
          controller.addListener(() {
            if (dialogContext.mounted) setStateDialog(() {});
          });

          return AlertDialog(
            title: const Text('أضف تعليقك'),
            content: TextField(
              controller: controller,
              maxLength: 200,
              maxLines: 3,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'اكتب تعليقك هنا...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: controller.text.trim().isNotEmpty
                    ? () async {
                        final text = controller.text.trim();
                        Navigator.pop(dialogContext);
                        try {
                          await _addCommentService.addComment(
                            doctorId: widget.doctorId,
                            content: text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم إضافة التعليق بنجاح'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _refreshProfile();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('خطأ: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('إرسال'),
              ),
            ],
          );
        },
      ),
    );
  }

  // حذف تعليق
  Future<void> _confirmDeleteComment(int commentId) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا التعليق؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _deleteCommentService.deleteComment(commentId: commentId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف التعليق'),
                    backgroundColor: Colors.blue,
                  ),
                );
                _refreshProfile();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('خطأ: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  // إضافة تقييم بنجوم
  Future<void> _showRatingDialog() async {
    int rating = 0;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setStateDialog) => AlertDialog(
          title: const Text('قيّم الطبيب'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اضغط على النجوم لتقييم الطبيب',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 36,
                    ),
                    onPressed: () {
                      setStateDialog(() {
                        rating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: rating == 0
                  ? null
                  : () async {
                      Navigator.pop(dialogContext);
                      try {
                        await _addRatingService.addRatings(
                          doctorId: widget.doctorId,
                          stars: rating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم التقييم بنجوم: $rating'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        _refreshProfile();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('خطأ: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
              child: const Text('تقييم'),
            ),
          ],
        ),
      ),
    );
  }

  // تبديل المفضلة
  Future<void> _toggleFavorite(bool current) async {
    try {
      if (current) {
        await _removeFavoriteService.removeFavorite(doctorId: widget.doctorId);
      } else {
        await _addFavoriteService.addFavorite(doctorId: widget.doctorId);
      }

      // حفظ الحالة المحلية
      await _saveFavoriteStatus(!current);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !current ? 'تمت الإضافة للمفضلة' : 'تمت الإزالة من المفضلة',
          ),
          backgroundColor: !current ? Colors.blue : Colors.grey,
        ),
      );

      _refreshProfile(); // تحديث البيانات من الـ API
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
        title: const Text('ملف الطبيب'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: const [
          // لا نستخدم _isFavorite هنا، نعتمد على doctor.isFavorite من الـ API
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: FutureBuilder<DoctorProfileResponse>(
          future: _profileFuture,
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
                      onPressed: _refreshProfile,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(child: Text('لا توجد بيانات'));
            }

            final doctor = snapshot.data!.doctorProfile;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // زر المفضلة في الأعلى
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        doctor.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: doctor.isFavorite ? Colors.red : null,
                      ),
                      onPressed: () => _toggleFavorite(doctor.isFavorite),
                      tooltip: doctor.isFavorite
                          ? 'إزالة من المفضلة'
                          : 'إضافة للمفضلة',
                    ),
                  ],
                ),

                // صورة الطبيب
                Hero(
                  tag: 'doctor_${doctor.id}',
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.deepPurple[100],
                    child: Text(
                      doctor.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 48,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // الاسم
                Text(
                  doctor.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // الخبرة
                Text(
                  '${doctor.yearsOfExperience} سنة خبرة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 24),

                // --- أزرار الخدمات ---
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionChip(
                          icon: Icons.star,
                          label: 'قيّم',
                          color: Colors.orange,
                          onPressed: _showRatingDialog,
                        ),
                        Container(
                            width: 1, height: 40, color: Colors.grey[300]),
                        _buildActionChip(
                          icon: Icons.comment,
                          label: 'أضف',
                          color: Colors.blue,
                          onPressed: _showAddCommentDialog,
                        ),
                        Container(
                            width: 1, height: 40, color: Colors.grey[300]),
                        _buildActionChip(
                          icon: Icons.calendar_today,
                          label: 'احجز',
                          color: Colors.deepPurple,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AvailableAppointmentsScreen(
                                        doctorId: widget.doctorId),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // التقييم بنجوم
                _buildDetailTile(
                  'التقييم',
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < doctor.stars ? Icons.star : Icons.star_border,
                        color: Colors.orange,
                        size: 18,
                      );
                    }),
                  ),
                ),

                _buildDetailTile('التخصص', 'طب عام'),
                _buildDetailTile('سنة التخرج', doctor.graduationDate),
                _buildDetailTile('مكان الدراسة', doctor.studyPlace),
                _buildDetailTile('المفضل', doctor.isFavorite ? 'نعم' : 'لا'),

                const SizedBox(height: 30),

                // الشهادات
                const Text('الشهادات',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (doctor.certificates.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctor.certificates.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final cert = doctor.certificates[index];
                      return Card(
                        color: Colors.blue[50],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(cert.name,
                              style: const TextStyle(fontSize: 16)),
                        ),
                      );
                    },
                  )
                else
                  const Text('لا توجد شهادات',
                      style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 30),

                // التعليقات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'التعليقات من المرضى',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.blue),
                      onPressed: _showAddCommentDialog,
                      tooltip: 'أضف تعليق',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (doctor.comments.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: doctor.comments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final comment = doctor.comments[index];
                      final date = _formatDate(comment.createdAt);
                      return Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_outline,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text(
                                    'مريض #${comment.patientId}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(comment.content,
                                  style: const TextStyle(
                                      fontSize: 15, height: 1.4)),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('في: $date',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600])),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 18, color: Colors.red),
                                    onPressed: () =>
                                        _confirmDeleteComment(comment.id),
                                    tooltip: 'حذف',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  const Text('لا توجد تعليقات بعد',
                      style: TextStyle(
                          color: Colors.grey, fontStyle: FontStyle.italic)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(
          label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Expanded(
            child: value is Widget
                ? value
                : Text(
                    value.toString(),
                    style: const TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMMM yyyy - hh:mm a').format(date);
    } catch (e) {
      return 'تاريخ غير معروف';
    }
  }
}
