// screens/centerBage.dart

import 'package:flutter/material.dart';
import 'package:patient_project/main.dart';
import 'package:patient_project/models/email_model.dart';
import 'package:patient_project/models/get_balance_model.dart';
import 'package:patient_project/screens/DepartmentsScreen .dart';
import 'package:patient_project/screens/PatientAppointmentsScreen.dart';
import 'dart:async';
import 'package:patient_project/screens/PatientInfoPage.dart';
import 'package:patient_project/screens/chronic_conditions_screen.dart';
import 'package:patient_project/screens/favorites_screen.dart';
import 'package:patient_project/screens/pages.dart';
import 'package:patient_project/screens/prescriptions_screen.dart';
import 'package:patient_project/screens/treatments_screen.dart';
import 'package:patient_project/screens/notifications_screen.dart'; // ✅ جديد
import 'package:patient_project/services/Security_info_service.dart';
import 'package:patient_project/services/get_balance_service.dart';
import 'package:patient_project/services/get_prescriptions_service.dart';
import 'package:patient_project/services/unread_notifications_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class centerBage extends StatefulWidget {
  const centerBage({super.key});
  static String id = '/centerBage';
  @override
  State<centerBage> createState() => _centerBageState();
}

class _centerBageState extends State<centerBage> {
  late Future<int> _unreadCountFuture;
  final UnreadNotificationsService _unreadService =
      UnreadNotificationsService();

  final PageController _pageController = PageController(initialPage: 0);
  late Timer _timer;
  int _currentPage = 0;
  int _selectedIndex = 0;
  late Future<GetBalanceModel> _balanceFuture;
  final GetBalanceService _balanceService = GetBalanceService();
  late Future<EmailModel> _emailFuture;
  final SecurityInfoService _securityService = SecurityInfoService();

  final List<String> _imageUrls = [
    'lib/images/clinic_images/photo_2025-08-25_21-13-53.jpg',
    'lib/images/clinic_images/photo_2025-08-25_21-13-54.jpg',
    'lib/images/clinic_images/photo_2025-08-25_21-13-55.jpg',
    'lib/images/clinic_images/photo_2025-08-25_21-13-56 (2).jpg',
    'lib/images/clinic_images/photo_2025-08-25_21-13-56.jpg',
    'lib/images/clinic_images/photo_2025-08-25_21-13-57 (2).jpg',
    'lib/images/clinic_images/photo_2025-08-25_21-13-57.jpg',
    'lib/images/clinic_images/photo_2025-08-25_21-13-58 (2).jpg',
    'lib/images/clinic_images/photo_2025-08-25_21-13-58.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _emailFuture = _securityService.securityInfo();
    _balanceFuture = _balanceService.getBalance();
    _unreadCountFuture = _unreadService.unreadNotifications(); // ✅ تحميل العدد
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DepartmentsScreen()),
        );
        break;
    }
  }

  // الدالة الجديدة لتسجيل الخروج.
  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // مسح جميع بيانات المستخدم.
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginScreenN(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  Widget _buildBalanceCard({
    required String title,
    required String balance,
    bool isLoading = false,
    bool isError = false,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color:
              isError ? Colors.red : (isLoading ? Colors.grey : Colors.green),
          width: 1.5,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: !isError && !isLoading
              ? const LinearGradient(
                  colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 70,
              color: isError
                  ? Colors.red
                  : (isLoading ? Colors.grey : Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              balance,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isError
                    ? Colors.red
                    : (isLoading ? Colors.grey : Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 16),
            if (!isLoading && !isError)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _balanceFuture = _balanceService.getBalance();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.refresh, size: 18, color: Colors.white),
                label: const Text(
                  'تحديث الرصيد',
                  style: TextStyle(color: Colors.white),
                ),
              )
            else if (isError)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _balanceFuture = _balanceService.getBalance();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.refresh, size: 18, color: Colors.white),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(color: Colors.white),
                ),
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
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
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.abc, color: Colors.white),
            onPressed: () async {
              await GetPrescriptionsService().getPrescriptions();
              print('${sharedPreferences!.getString('token')}');
            },
          ),
          // --- أيقونة الإشعارات مع البادج ---
          FutureBuilder<int>(
            future: _unreadCountFuture,
            builder: (context, snapshot) {
              final int unreadCount = snapshot.data ?? 0;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      ).then((_) {
                        // بعد الرجوع، نُحدث العدد
                        if (mounted) {
                          setState(() {
                            _unreadCountFuture =
                                _unreadService.unreadNotifications();
                          });
                        }
                      });
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder<EmailModel>(
          future: _emailFuture,
          builder: (context, snapshot) {
            Widget emailWidget;

            if (snapshot.connectionState == ConnectionState.waiting) {
              emailWidget = const Text(
                'جاري التحميل...',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              );
            } else if (snapshot.hasError) {
              emailWidget = const Text(
                'خطأ في التحميل',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              );
            } else if (snapshot.hasData) {
              emailWidget = Text(
                snapshot.data!.email,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              );
            } else {
              emailWidget = const Text(
                'no-email@example.com',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              );
            }

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: const Text(''),
                  accountEmail: emailWidget,
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.folder_shared),
                  title: const Text('ملفي الشخصي'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatientInfoPage()),
                    ).then((_) {
                      if (mounted) {
                        setState(() {
                          _unreadCountFuture =
                              _unreadService.unreadNotifications();
                        });
                      }
                    });
                  },
                ),
                // ListTile(
                //   leading: const Icon(Icons.assignment),
                //   title: const Text('الملف الطبي'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const MedicalFilePage()),
                //     ).then((_) {
                //       if (mounted) {
                //         setState(() {
                //           _unreadCountFuture =
                //               _unreadService.unreadNotifications();
                //         });
                //       }
                //     });
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.assignment),
                  title: const Text('السجل الطبي'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PatientAppointmentsScreen()),
                    ).then((_) {
                      if (mounted) {
                        setState(() {
                          _unreadCountFuture =
                              _unreadService.unreadNotifications();
                        });
                      }
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('المفضلة'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavoritesScreen()),
                    ).then((_) {
                      if (mounted) {
                        setState(() {
                          _unreadCountFuture =
                              _unreadService.unreadNotifications();
                        });
                      }
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.healing),
                  title: const Text('الأمراض المزمنة'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ChronicConditionsScreen()),
                    ).then((_) {
                      if (mounted) {
                        setState(() {
                          _unreadCountFuture =
                              _unreadService.unreadNotifications();
                        });
                      }
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.healing),
                  title: const Text('العلاجات والدفع'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TreatmentsScreen()),
                    ).then((_) {
                      if (mounted) {
                        setState(() {
                          _balanceFuture = _balanceService.getBalance();
                          _unreadCountFuture =
                              _unreadService.unreadNotifications();
                        });
                      }
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.medication),
                  title: const Text('الوصفات الطبية'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrescriptionsScreen()),
                    ).then((_) {
                      if (mounted) {
                        setState(() {
                          _unreadCountFuture =
                              _unreadService.unreadNotifications();
                        });
                      }
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('تسجيل الخروج'),
                  onTap: _logout,
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
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
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: FutureBuilder<GetBalanceModel>(
              future: _balanceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildBalanceCard(
                    title: 'جاري التحميل...',
                    balance: '',
                    isLoading: true,
                  );
                } else if (snapshot.hasError) {
                  return _buildBalanceCard(
                    title: 'خطأ في التحميل',
                    balance: '',
                    isError: true,
                  );
                } else if (!snapshot.hasData) {
                  return _buildBalanceCard(
                    title: 'رصيد محفظتك الحالي:',
                    balance: '0 ل.س',
                  );
                }

                final balance = snapshot.data!.balance;
                return _buildBalanceCard(
                  title: 'رصيد محفظتك الحالي:',
                  balance: '${balance.toStringAsFixed(0)} ل.س',
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'الأقسام',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4CAF50),
        onTap: _onItemTapped,
      ),
    );
  }
}
