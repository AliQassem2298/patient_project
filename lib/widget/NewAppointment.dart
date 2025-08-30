import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:patient_project/ConstantURL.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewAppointmentPage extends StatefulWidget {
  const NewAppointmentPage({super.key});

  @override
  State<NewAppointmentPage> createState() => _NewAppointmentPageState();
}

class _NewAppointmentPageState extends State<NewAppointmentPage> {
  List<dynamic> departments = [];
  String? selectedDepartmentId;

  List<dynamic> doctors = [];
  String? selectedDoctorId;

  final TextEditingController patientIdController = TextEditingController();
  String? patientId;

  List<dynamic> appointments = [];
  String? selectedAppointmentId;
  String? selectedAppointmentDateTime;

  bool isLoadingDepartments = true;
  bool isLoadingDoctors = false;
  bool isLoadingAppointments = false;
  bool isBooking = false;
  String? errorMessage;
  String? successMessage;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  @override
  void dispose() {
    patientIdController.dispose();
    super.dispose();
  }

  Future<void> fetchDepartments() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        isLoadingDepartments = false;
        errorMessage = 'Token not found again login';
      });
      return;
    }

    const url = '$baseUrl/get_all_departments';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          departments = data;
          isLoadingDepartments = false;
        });
      } else {
        setState(() {
          isLoadingDepartments = false;
          errorMessage =
              'Unable to load categories. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoadingDepartments = false;
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  Future<void> fetchDoctors(String departmentId) async {
    setState(() {
      isLoadingDoctors = true;
      doctors = [];
      selectedDoctorId = null;
      appointments = [];
      selectedAppointmentId = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        isLoadingDoctors = false;
        errorMessage = 'Token not found';
      });
      return;
    }

    const url = '$baseUrl/department_info';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': int.parse(departmentId)}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          doctors = data['doctors'];
          isLoadingDoctors = false;
        });
      } else {
        setState(() {
          isLoadingDoctors = false;
          errorMessage =
              'Failed to load doctors. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoadingDoctors = false;
        errorMessage = 'An error occurred while fetching doctors: $e';
      });
    }
  }

  Future<void> fetchAppointments() async {
    if (selectedDoctorId == null || patientId == null || patientId!.isEmpty) {
      setState(() {
        appointments = [];
        selectedAppointmentId = null;
      });
      return;
    }

    setState(() {
      isLoadingAppointments = true;
      appointments = [];
      selectedAppointmentId = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        isLoadingAppointments = false;
        errorMessage = 'Token not found';
      });
      return;
    }

    const url = '$baseUrl/appointments/available';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'doctor_id': int.parse(selectedDoctorId!),
          'patient_id': int.parse(patientId!),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          appointments = data['appointments'];
          isLoadingAppointments = false;
        });
      } else {
        setState(() {
          isLoadingAppointments = false;
          errorMessage =
              'Failed to load appointments. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoadingAppointments = false;
        errorMessage = 'An error occurred while fetching appointments: $e';
      });
    }
  }

  Future<void> bookAppointment() async {
    if (selectedAppointmentId == null) {
      setState(() {
        errorMessage = 'Please select an appointment to confirm the booking.';
        successMessage = null;
      });
      return;
    }

    setState(() {
      isBooking = true;
      errorMessage = null;
      successMessage = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        isBooking = false;
        errorMessage = 'Token not found. Please log in again.';
      });
      return;
    }

    const url = '$baseUrl/appointments/booked';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'appointment_id': int.parse(selectedAppointmentId!)}),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        setState(() {
          successMessage = 'Appointment booked successfully';
          isBooking = false;
        });
        print('Appointment booked successfully!');
      } else {
        setState(() {
          errorMessage = responseData['message'] ??
              'Failed to confirm appointment. Status code: ${response.statusCode}';
          isBooking = false;
        });
        print('Failed to book appointment: ${responseData['message']}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while confirming the booking: $e';
        isBooking = false;
      });
      print('Booking error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Appointment'),
        backgroundColor: const Color.fromARGB(255, 129, 237, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoadingDepartments
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(errorMessage!,
                        style: const TextStyle(color: Colors.red)))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('اختر القسم',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text('Select a Department'),
                            value: selectedDepartmentId,
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDepartmentId = newValue;
                                print(
                                    'Selected Department ID: $selectedDepartmentId');
                                if (newValue != null) {
                                  fetchDoctors(newValue);
                                }
                              });
                            },
                            items: departments
                                .map<DropdownMenuItem<String>>((department) {
                              return DropdownMenuItem<String>(
                                  value: department['id'].toString(),
                                  child: Text(department['name']));
                            }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (selectedDepartmentId != null) ...[
                        const Text('Select a Doctor',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        isLoadingDoctors
                            ? const Center(child: CircularProgressIndicator())
                            : doctors.isEmpty
                                ? const Center(
                                    child: Text(
                                        'There are no doctors available in this department.'))
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        hint: const Text('ًSelect a Doctor'),
                                        value: selectedDoctorId,
                                        isExpanded: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedDoctorId = newValue;
                                            print(
                                                'Selected Doctor ID: $selectedDoctorId');
                                            fetchAppointments();
                                          });
                                        },
                                        items: doctors
                                            .map<DropdownMenuItem<String>>(
                                                (doctor) {
                                          return DropdownMenuItem<String>(
                                              value: doctor['id'].toString(),
                                              child: Text(doctor['name']));
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                      ],

                      const SizedBox(height: 20),

                      // حقل إدخال patient_id
                      if (selectedDoctorId != null) ...[
                        const Text('Patient ID',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: patientIdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Enter the ID number here',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                          onChanged: (value) {
                            setState(() {
                              patientId = value;
                              print('Patient ID: $patientId');
                              fetchAppointments();
                            });
                          },
                        ),
                      ],

                      const SizedBox(height: 20),

                      if (selectedDoctorId != null &&
                          patientId != null &&
                          patientId!.isNotEmpty) ...[
                        const Text('Available appointment',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        isLoadingAppointments
                            ? const Center(child: CircularProgressIndicator())
                            : appointments.isEmpty
                                ? const Center(
                                    child: Text('No available appointment'))
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        hint:
                                            const Text('Choose an appointment'),
                                        value: selectedAppointmentId,
                                        isExpanded: true,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedAppointmentId = newValue;
                                            final selectedAppointment =
                                                appointments
                                                    .firstWhere((appt) =>
                                                        appt['id'].toString() ==
                                                        newValue);
                                            selectedAppointmentDateTime =
                                                '${selectedAppointment['date']} - ${selectedAppointment['time']}';
                                            print(
                                                'Selected Appointment ID: $selectedAppointmentId');
                                            print(
                                                'Selected Appointment Date/Time: $selectedAppointmentDateTime');
                                          });
                                        },
                                        items: appointments
                                            .map<DropdownMenuItem<String>>(
                                                (appointment) {
                                          return DropdownMenuItem<String>(
                                              value:
                                                  appointment['id'].toString(),
                                              child: Text(
                                                  '${appointment['date']} - ${appointment['time']}'));
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                      ],

                      const SizedBox(height: 20),

                      if (selectedAppointmentId != null && !isBooking)
                        ElevatedButton(
                          onPressed: bookAppointment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 129, 237, 194),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: const Text(
                            'Confirm Appointment',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      if (isBooking)
                        const Center(child: CircularProgressIndicator()),

                      const SizedBox(height: 20),

                      if (successMessage != null)
                        Center(
                          child: Text(
                            successMessage!,
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (errorMessage != null)
                        Center(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}
