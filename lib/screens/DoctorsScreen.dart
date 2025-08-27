import 'package:flutter/material.dart';
import 'package:patient_project/screens/DoctorReviewScreen.dart';


class DoctorsScreen extends StatelessWidget {
  final String departmentName;

  const DoctorsScreen({super.key, required this.departmentName});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> doctorsByDepartment = {
      'Surgery Department': [
        {
          'name': 'Dr. Alice Smith',
          'study': 'Graduated from Harvard Medical School. Specialized in general surgery.',
          'image': 'https://placehold.co/100x100/4CAF50/FFFFFF?text=Alice'
        },
        {
          'name': 'Dr. John Doe',
          'study': 'Studied at Oxford University. Expert in orthopedic surgery.',
          'image': 'https://placehold.co/100x100/81C784/FFFFFF?text=John'
        },
      ],
      'Laser Department': [
        {
          'name': 'Dr. Sarah Lee',
          'study': 'Laser skin specialist. Trained in Seoul and Los Angeles.',
          'image': 'https://placehold.co/100x100/66BB6A/FFFFFF?text=Sarah'
        },
        {
          'name': 'Dr. Omar Khan',
          'study': 'Performed over 500 LASIK procedures. Graduate of Cairo University.',
          'image': 'https://placehold.co/100x100/8BC34A/FFFFFF?text=Omar'
        },
      ],
      'General Checkup': [
        {
          'name': 'Dr. Emily Clark',
          'study': 'Family medicine expert. Studied in Toronto.',
          'image': 'https://placehold.co/100x100/A5D6A7/FFFFFF?text=Emily'
        },
        {
          'name': 'Dr. Michael Brown',
          'study': 'Internal medicine specialist. Graduate of Johns Hopkins.',
          'image': 'https://placehold.co/100x100/C8E6C9/FFFFFF?text=Michael'
        },
      ],
      'Lens Implant Department': [
        {
          'name': 'Dr. Linda White',
          'study': 'Ophthalmologist specialized in lens implants. Studied in Berlin.',
          'image': 'https://placehold.co/100x100/388E3C/FFFFFF?text=Linda'
        },
        {
          'name': 'Dr. David Green',
          'study': 'Pioneer in advanced lens technologies. Trained in Tokyo and New York.',
          'image': 'https://placehold.co/100x100/2E7D32/FFFFFF?text=David'
        },
      ],
    };

    final doctors = doctorsByDepartment[departmentName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('$departmentName Doctors'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: doctors.isEmpty
          ? const Center(child: Text('No doctors available in this department'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            doctor['image']!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor['name']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                doctor['study']!,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorReviewScreen(
                                        doctor: doctor['name']!,
                                        department: departmentName,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Review Doctor'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}