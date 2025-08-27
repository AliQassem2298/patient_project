import 'package:flutter/material.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/screens/DepartmentsScreen .dart';
import 'package:patient_project/screens/LoginScreen.dart';
import 'package:patient_project/screens/PatientAppointmentsScreen.dart';
import 'dart:async';
import 'package:patient_project/screens/PatientInfoPage.dart';
import 'package:patient_project/services/Personal_info_service.dart';
import 'package:patient_project/services/get_prescriptions_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:patient_project/screens/MedicalFilePage.dart';

class centerBage extends StatefulWidget {
  const centerBage({super.key});

  @override
  State<centerBage> createState() => _centerBageState();
}

class _centerBageState extends State<centerBage> {
  final PageController _pageController = PageController(initialPage: 0);
  late Timer _timer;
  int _currentPage = 0;
  int _selectedIndex = 0;

  // هنا تم استبدال الصور النائبة بصور حقيقية وجذابة.
  final List<String> _imageUrls = [
    'lib/images/clinic_images/image.jpg', // صورة طبيب
    'lib/images/clinic_images/image.jpg', // صورة طبيب
    'lib/images/clinic_images/image.jpg', // صورة طبيب
    'lib/images/clinic_images/image.jpg', // صورة طبيب
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Home button pressed')),
        );
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wallet button pressed')),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DepartmentsScreen()),
        );
        break;
    }
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications button pressed!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // الدالة الجديدة لتسجيل الخروج.
  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // مسح جميع بيانات المستخدم.
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                const LoginScreen()), // استبدل بصفحة تسجيل الدخول الخاصة بك.
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.abc, color: Colors.white),
            onPressed: () async {
              await GetPrescriptionsService().getPrescriptions();
              print('${sharedPreferences!.getString('token')}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              sharedPreferences!.clear();
              _showNotifications();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('User Name'),
              accountEmail: Text('user@example.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFF4CAF50),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.folder_shared),
              title: const Text('Patient File'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PatientInfoPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Medical Form'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MedicalFilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('السجل الطبي'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PatientAppointmentsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: _logout, // استدعاء دالة تسجيل الخروج الجديدة.
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Home Page Content',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _imageUrls.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(_imageUrls[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _imageUrls.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _pageController.animateToPage(entry.key,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == entry.key
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Departments',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4CAF50),
        onTap: _onItemTapped,
      ),
    );
  }
}
