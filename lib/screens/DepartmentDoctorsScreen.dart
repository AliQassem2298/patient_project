// screens/department_doctors_screen.dart

import 'package:flutter/material.dart';
import 'package:patient_project/helper/api.dart';
import 'package:patient_project/models/department_info_model.dart';
import 'package:patient_project/screens/DoctorProfileScreen.dart';
import 'package:patient_project/services/department_info_service.dart';

class DepartmentDoctorsScreen extends StatefulWidget {
  final int departmentId;
  final String departmentName;

  const DepartmentDoctorsScreen({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  State<DepartmentDoctorsScreen> createState() =>
      _DepartmentDoctorsScreenState();
}

class _DepartmentDoctorsScreenState extends State<DepartmentDoctorsScreen> {
  late Future<DepartmentInfoModel> _departmentFuture;
  final DepartmentInfoService _service = DepartmentInfoService();
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _departmentFuture = _service.departmentInfo(id: widget.departmentId);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.departmentName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DepartmentInfoModel>(
        future: _departmentFuture,
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
                    onPressed: () => setState(() {
                      _departmentFuture =
                          _service.departmentInfo(id: widget.departmentId);
                    }),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('لا توجد بيانات'));
          }

          final department = snapshot.data!;
          final images = department.images;

          return RefreshIndicator(
            onRefresh: () async => setState(() {
              _departmentFuture =
                  _service.departmentInfo(id: widget.departmentId);
            }),
            child: CustomScrollView(
              slivers: [
                // السلايدر الخاص بالصور
                if (images.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final image = images[index];
                              final imageUrl = '$baseUrlImage${image.path}';

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                          // مؤشرات النقاط (Dots)
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: images.asMap().entries.map((entry) {
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == entry.key
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'لا توجد صور لهذا القسم',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  ),

                // العنوان "الأطباء المتخصصون"
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'الأطباء المتخصصون',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),

                // قائمة الأطباء
                SliverList.builder(
                  itemCount: department.doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = department.doctors[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Hero(
                          tag: 'doctor_${doctor.id}',
                          child: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: Text(
                              doctor.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          doctor.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text('طبيب متخصص في ${widget.departmentName}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DoctorProfileScreen(doctorId: doctor.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
              ],
            ),
          );
        },
      ),
    );
  }
}
