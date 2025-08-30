// file: lib/widget/ProfileScreen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient_project/ConstantURL.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// Helper function
String formatImageUrl(String? path) {
  if (path == null) {
    return '';
  }
  return path.startsWith('http') ? path : '$baseUrl/storage/$path';
}

class ProfileScreen extends StatefulWidget {
  final String token;
  const ProfileScreen({super.key, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  final Color primaryColor = const Color(0xFF4CAF50); // لون أخضر مناسب
  final Color accentColor = const Color(0xFF8BC34A); // لون أخضر فاتح

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final url = Uri.parse("$baseUrl/api/secretary_profile");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      if (mounted) {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            userData = data['secretary_profile'];
            isLoading = false;
            print("Profile Data fetched successfully: $userData");
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print("Failed to fetch data: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        print("Error fetching profile: $e");
      }
    }
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Hero(
          tag: "secretaryImage",
          child: CircleAvatar(
            radius: 80,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: userData?['image'] != null
                  ? Image.network(
                      formatImageUrl(userData!['image']),
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person,
                            size: 80, color: Colors.grey[400]);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    )
                  : Icon(Icons.person, size: 80, color: Colors.grey[400]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          userData?['name'] ?? 'No Name',
          style: GoogleFonts.cairo(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Secretary",
          style: GoogleFonts.cairo(
            fontSize: 18,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      {required String title, required IconData icon, required String value}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: primaryColor, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificatesSection(List<String> certificates) {
    if (certificates.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          'Certificates',
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        ...certificates.map(
          (cert) => Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading:
                  Icon(Icons.school_outlined, color: accentColor, size: 28),
              title: Text(cert, style: GoogleFonts.cairo(fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const CircleAvatar(radius: 80, backgroundColor: Colors.white),
              const SizedBox(height: 20),
              Container(width: 200, height: 25, color: Colors.white),
              const SizedBox(height: 10),
              Container(width: 150, height: 20, color: Colors.white),
              const SizedBox(height: 40),
              for (int i = 0; i < 4; i++)
                Container(
                  height: 70,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (userData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              "No Profile Data Available",
              style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final certificates = (userData?['certificates'] as List<dynamic>? ?? [])
        .map((c) => c['name'].toString())
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 500),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            _buildProfileSection(),
            const SizedBox(height: 30),
            _buildInfoCard(
              title: "Birth Date",
              icon: Icons.cake_outlined,
              value: userData?['birth_date'] ?? 'N/A',
            ),
            _buildInfoCard(
              title: "Shift",
              icon: Icons.access_time_outlined,
              value: userData?['shift'] ?? 'N/A',
            ),
            _buildInfoCard(
              title: "Salary",
              icon: Icons.attach_money_outlined,
              value: userData?['salary']?.toString() ?? 'N/A',
            ),
            _buildInfoCard(
              title: "Vacation Number",
              icon: Icons.flight_takeoff_outlined,
              value: userData?['vaccation_number']?.toString() ?? 'N/A',
            ),
            _buildCertificatesSection(certificates),
          ],
        ),
      ),
    );
  }
}
