// import 'package:flutter/material.dart';

// // Department details page
// class DepartmentDetailsPage extends StatelessWidget {
//   final String departmentName;
//   final String departmentImage;
//   final List<String> doctors;

//   const DepartmentDetailsPage({
//     super.key,
//     required this.departmentName,
//     required this.departmentImage,
//     required this.doctors,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(departmentName, style: const TextStyle(color: Colors.white)),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Department image
//             Image.network(
//               departmentImage,
//               width: double.infinity,
//               height: 250,
//               fit: BoxFit.cover,
//               // Fallback image in case the network image fails to load
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   color: Colors.grey[200],
//                   height: 250,
//                   child: const Center(
//                     child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
//                   ),
//                 );
//               },
//             ),
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'أسماء الأطباء:',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             // List of doctors
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: doctors.length,
//               itemBuilder: (context, index) {
//                 return Card(
//                   elevation: 4,
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: ListTile(
//                     leading: const Icon(Icons.medical_services, color: Colors.blue),
//                     title: Text(
//                       doctors[index],
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DepartmentsScreen extends StatelessWidget {
//   const DepartmentsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // A list of medical departments with their names and images.
//     // The image URLs have been updated to represent each department.
//     final List<Map<String, dynamic>> departments = [
//       {
//         'name': 'قسم الجراحة',
//         'image': 'https://images.unsplash.com/photo-1576091160550-21735c0f1c9c?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
//         'doctors': ['د. أحمد سعيد', 'د. محمود علي']
//       },
//       {
//         'name': 'قسم الليزر',
//         'image': 'https://images.unsplash.com/photo-1628104868213-3a1b1a7c7c34?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
//         'doctors': ['د. سارة فؤاد', 'د. مريم ناصر']
//       },
//       {
//         'name': 'فحص عام',
//         'image': 'https://images.unsplash.com/photo-1579684385150-e7f0170a7b97?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
//         'doctors': ['د. يوسف خالد', 'د. فاطمة الزهراء']
//       },
//       {
//         'name': 'قسم زراعة العدسات',
//         'image': 'https://images.unsplash.com/photo-1549419137-7707e7702f5a?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80',
//         'doctors': ['د. علي محمد', 'د. نور حسين']
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الأقسام الطبية', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: departments.length,
//         itemBuilder: (context, index) {
//           final department = departments[index];
//           return Card(
//             elevation: 6,
//             margin: const EdgeInsets.symmetric(vertical: 12),
//             child: InkWell(
//               // Handle tap to navigate to the new page
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DepartmentDetailsPage(
//                       departmentName: department['name']!,
//                       departmentImage: department['image']!,
//                       doctors: List<String>.from(department['doctors']!),
//                     ),
//                   ),
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   department['name']!,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
