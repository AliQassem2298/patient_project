import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:patient_project/homeDoctor.dart' hide formatImageUrl;
import 'package:patient_project/token.dart';
import 'package:patient_project/ConstantURL.dart';

class profile extends StatefulWidget {
  final items;
  const profile({super.key, this.items});
  @override
  State<profile> createState() => _profile();
}

class _profile extends State<profile> {
  void showAddCashDialog(BuildContext context) {
    TextEditingController newPhoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "\$add your cash",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newPhoneController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "\$add your cash",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق النافذة
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                newPhoneController.hashCode; // إضافة الرقم الجديد
                Navigator.of(context).pop(); // إغلاق النافذة بعد الإضافة
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void showCustomDialog(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    Future<void> Edit() async {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/api/auth/editUserProfile'),
      );
      request.fields['first_name'] = firstNameController.text;
      request.fields['last_name'] = lastNameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['password'] = passwordController.text;
      request.fields['location'] = locationController.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("updated your profile successfully"
                //languageCode=="E"?"updated your profile successfully":"تم تحديث ملفك الشخصي بنجاح")),
                )));
        await Future.delayed(const Duration(seconds: 0));
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Update User Information",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                checkTokenAndFetchUserData();

                _loadToken();
                Edit();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic>? userData;
  String? token;
  Future<Map<String, dynamic>?> UserProfile(String token) async {
    final url = Uri.parse('$baseUrl/api/auth/showUserProfile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching user profile: $e');
    }

    return null;
  }

  Future<void> checkTokenAndFetchUserData() async {
    final token = await tokenManager.getToken();

    if (token != null) {
      final profile = await UserProfile(token);
      if (profile != null) {
        setState(() {
          userData = profile;
        });
      } else {
        print("Failed to fetch user profile.");
      }
    } else {
      print("No token found.");
    }
  }

  Future<void> _loadToken() async {
    final fetchedToken = await tokenManager.getToken();
    setState(() {
      token = fetchedToken;
    });

    if (token == null || token!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Token is missing or invalid.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    checkTokenAndFetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "      your profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: userData?['personal_photo'] != null
                    ? Image.network(
                        formatImageUrl(userData!['personal_photo']),
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      )
                    : const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Text(
                  "${userData?['first_name'] ?? 'Guest'}"
                  " "
                  "${userData?['last_name'] ?? ''}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${userData?['phone'] ?? 'No phone'}",
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ProfileDetailTile(
                  icon: Icons.location_on_outlined,
                  title: "${userData?['location'] ?? 'Unknown location'}",
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          MaterialButton(
            color: Colors.black54,
            onPressed: () {
              showCustomDialog(
                context,
              );
            },
            child: const Text(
              "Edit Your Porfile",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              showAddCashDialog(context);
            },
            child: const Text(
              "\$add your cash",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileDetailTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
//هذه الدالة ستقوم بإرسال الرقم الجديد إلى الخادم (API) لتحديث بيانات المستخدم.
// Future<void> addNewPhoneNumber(String newPhoneNumber) async {
//   var request = http.MultipartRequest(
//     'PUT',
//     Uri.parse('$baseUrl/api/auth/editUserProfile'),
//   );
//
//   // إضافة الرقم الجديد إلى الطلب
//   request.fields['phone'] = newPhoneNumber;
//
//   // إضافة التوكن إلى الطلب
//   request.headers['Authorization'] = 'Bearer $token';
//
//   var response = await request.send();
//
//   if (response.statusCode == 200) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Phone number added successfully")),
//     );
//
//     // تحديث واجهة المستخدم بعد الإضافة
//     checkTokenAndFetchUserData();
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Failed to add phone number")),
//     );
//   }
// }

//////////////////////////////
// void showAddPhoneDialog(BuildContext context) {
//   TextEditingController newPhoneController = TextEditingController();
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         title: const Text(
//           "Add New Phone Number",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: newPhoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(
//                   labelText: "New Phone Number",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // إغلاق النافذة
//             },
//             child: const Text(
//               "Cancel",
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               addNewPhoneNumber(newPhoneController.text); // إضافة الرقم الجديد
//               Navigator.of(context).pop(); // إغلاق النافذة بعد الإضافة
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       );
//     },
//   );
// }