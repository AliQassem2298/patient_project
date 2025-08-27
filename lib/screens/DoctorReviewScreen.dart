import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Doctor {
  final String id;
  final String name;
  final String department;

  Doctor({required this.id, required this.name, required this.department});
}

class Review {
  final String doctorId;
  final String comment;
  final int rating;
  final DateTime timestamp;

  Review({
    required this.doctorId,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });
}

class DoctorReviewScreen extends StatefulWidget {
  final String doctor;
  final String department;

  const DoctorReviewScreen({
    super.key,
    required this.doctor,
    required this.department,
  });

  @override
  State<DoctorReviewScreen> createState() => _DoctorReviewScreenState();
}

class _DoctorReviewScreenState extends State<DoctorReviewScreen> {
  late Doctor selectedDoctor;
  final List<Review> reviews = [];
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDoctor = Doctor(
      id: widget.doctor.hashCode.toString(),
      name: widget.doctor,
      department: widget.department,
    );
  }

  bool canComment() {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    final doctorReviews = reviews.where((r) =>
        r.doctorId == selectedDoctor.id && r.timestamp.isAfter(oneWeekAgo));
    return doctorReviews.length < 2;
  }

  void submitReview() {
    final comment = commentController.text.trim();

    if (selectedRating == 0 || comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار التقييم وكتابة تعليق')),
      );
      return;
    }

    if (comment.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('التعليق لا يمكن أن يتجاوز ٥٠ حرفًا')),
      );
      return;
    }

    if (!canComment()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكنك إضافة أكثر من تعليقين لهذا الطبيب خلال أسبوع')),
      );
      return;
    }

    final newReview = Review(
      doctorId: selectedDoctor.id,
      comment: comment,
      rating: selectedRating,
      timestamp: DateTime.now(),
    );

    setState(() {
      reviews.add(newReview);
      commentController.clear();
      selectedRating = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إضافة التعليق بنجاح')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تقييم ${selectedDoctor.name}'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('${selectedDoctor.name} - ${selectedDoctor.department}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: selectedRating >= starIndex ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRating = starIndex;
                    });
                  },
                );
              }),
            ),
            TextField(
              controller: commentController,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'اكتب تعليقك (حد أقصى ٥٠ حرف)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: submitReview,
              child: const Text('إرسال التقييم'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('آخر التعليقات:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: reviews.map((r) {
                  final formattedDate = DateFormat('yyyy/MM/dd').format(r.timestamp);
                  return ListTile(
                    title: Text('${selectedDoctor.name} (${r.rating} ⭐)'),
                    subtitle: Text('${r.comment} - $formattedDate'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}