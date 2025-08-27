import 'package:flutter/material.dart';

// A new page for patient information
class PatientInfoPage extends StatefulWidget {
  const PatientInfoPage({super.key});

  @override
  State<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  // A key to uniquely identify the form
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  String? _gender; // State variable for gender

  // State variable to toggle between read-only and editable mode
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    // Simulate loading data. In a real app, this would be a database call.
    _loadPatientInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  // Function to simulate loading patient information
  void _loadPatientInfo() {
    // Example data to pre-fill the form
    _nameController.text = 'John Doe';
    _phoneController.text = '123-456-7890';
    _addressController.text = '123 Main St, Anytown, USA';
    _dateOfBirthController.text = '15-05-1990';
    _gender = 'Male';
  }

  // Function to show a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        // Format the date to display in the text field
        _dateOfBirthController.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  // Function to handle form submission (update info)
  void _updatePatientInfo() {
    if (_formKey.currentState!.validate()) {
      // Display a snackbar with the updated information
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Updated: Name: ${_nameController.text}, Phone: ${_phoneController.text}, Address: ${_addressController.text}, Gender: $_gender',
          ),
          backgroundColor: Colors.blue,
        ),
      );
      // Disable editing mode after saving
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient File', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4CAF50),
        // Add an explicit back button for reliable navigation
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // This will pop the current page from the navigation stack
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Patient Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Name text field
              TextFormField(
                controller: _nameController,
                readOnly: !_isEditing,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Gender selection
              const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: _isEditing ? (value) {
                        setState(() {
                          _gender = value;
                        });
                      } : null,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: _isEditing ? (value) {
                        setState(() {
                          _gender = value;
                        });
                      } : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Date of Birth text field with date picker
              TextFormField(
                controller: _dateOfBirthController,
                readOnly: !_isEditing,
                onTap: _isEditing ? () => _selectDate(context) : null,
                decoration: InputDecoration(
                  labelText: 'Date of Birth (Day-Month-Year)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient\'s date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Phone number text field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                readOnly: !_isEditing,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Address text field
              TextFormField(
                controller: _addressController,
                readOnly: !_isEditing,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Conditional buttons based on editing state
              _isEditing
                  ? ElevatedButton.icon(
                      onPressed: _updatePatientInfo,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Information'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Information'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
