import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:visitor_app_flutter/pages/appoinment_details.dart';

class BookAppointmentScreen extends StatefulWidget {
  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedStaff;
  String? _appointmentReason;  // Reason for the appointment
  String? _whatWillYouTake;  // What will you be taking with you
  bool _isTakingSomeone = false;  // Whether the visitor is taking someone with them
  int _numberOfPeople = 0;  // Number of people coming with the visitor
  List<String?> _emails = [];  // List to store email addresses of people coming with the visitor
  List<String> _availableTimes = [];
  List<String> _staffList = [];  // List of staff members

  @override
  void initState() {
    super.initState();
    _fetchStaffList();
  }

  // Fetch staff names (Sample data, replace with actual Firestore data fetching)
  void _fetchStaffList() async {
    // Sample staff data
    final staffData = {
      'John Doe': 'HR',
      'Jane Smith': 'Engineering',
      'Mike Johnson': 'Marketing',
      'Emily Davis': 'Finance',
      'Chris Brown': 'Sales',
    };

    List<String> staffNames = [];
    staffData.forEach((name, _) {
      staffNames.add(name);
    });

    setState(() {
      _staffList = staffNames;
      _selectedStaff = null;  // Reset selected staff when fetching new staff
      _selectedTime = null;   // Reset selected time when fetching new staff
      _availableTimes.clear(); // Clear available times when fetching new staff
    });
  }

  // Fetch available times based on selected date and staff
  void _fetchAvailableTimes() async {
    if (_selectedDate == null || _selectedStaff == null) return; // Avoid fetching available times if date or staff is not selected

    // Sample available times data
    List<String> bookedTimes = []; // Sample empty booked times list
    List<String> allTimes = [
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM'
    ];
    setState(() {
      _availableTimes = allTimes.where((time) => !bookedTimes.contains(time)).toList();
    });
  }

  // Handle date selection
  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _fetchAvailableTimes();  // Fetch available times after selecting a new date
      });
    }
  }

  // Handle time selection
  void _selectTime(String? newValue) {
    setState(() {
      _selectedTime = parseTime(newValue!);
    });
  }

  // Submit the form and book the appointment
  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectedStaff != null) {
      DocumentReference appointmentRef = await FirebaseFirestore.instance.collection('appointments').add({
        'visitorId': FirebaseAuth.instance.currentUser?.uid,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'time': _selectedTime!.format(context),
        'staffId': _selectedStaff,
        'reason': _appointmentReason,  // Add the reason for the appointment
        'whatWillYouTake': _whatWillYouTake,  // Add what the visitor will be taking
        'isTakingSomeone': _isTakingSomeone,  // Whether the visitor is taking someone with them
        'numberOfPeople': _numberOfPeople,  // Number of people coming with the visitor
        'emails': _emails,  // Email addresses of people coming with the visitor
        'status': 'pending',
      });

      // Navigate to AppointmentDetailsScreen after booking
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppointmentDetailsScreen(
            visitorName:
                FirebaseAuth.instance.currentUser?.displayName ?? 'Visitor',
            appointmentDate: _selectedDate!,
            appointmentTime: _selectedTime!,
            staffName: _selectedStaff!,
            appointmentId: appointmentRef.id, 
            onAccept: (bool ) {  }, 
            onDecline: (bool ) {  }, // Pass the appointmentId
              // Pass the appointmentId
          ),
        ),
      );
    }
  }

  // Convert TimeOfDay to string
  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hourOfPeriod.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }

  // Parse string to TimeOfDay
  TimeOfDay parseTime(String time) {
    final parts = time.split(':');
    final hourPart = int.parse(parts[0]);
    final minutePart = int.parse(parts[1].split(' ')[0]);
    final period = parts[1].split(' ')[1];
    final isPM = period == 'PM';
    final hour = isPM
        ? (hourPart == 12 ? 12 : hourPart + 12)
        : (hourPart == 12 ? 0 : hourPart);
    return TimeOfDay(hour: hour, minute: minutePart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Staff',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select Staff',
                  ),
                  value: _selectedStaff,
                  onChanged: _staffList.isNotEmpty
                      ? (newValue) {
                          setState(() {
                            _selectedStaff = newValue!;
                            _fetchAvailableTimes();  // Fetch available times for the selected staff
                          });
                        }
                      : null, // Disable staff selection if no staff available
                  items: _staffList.map((staff) {
                    return DropdownMenuItem(
                      child: Text(staff),
                      value: staff,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Reason for Appointment',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the reason for the appointment',
                  ),
                  maxLines: 3,  // Allow multiple lines for the reason
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason for the appointment';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _appointmentReason = value;  // Update the reason when the text changes
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'What will you be taking with you?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter what you will be taking with you',
                  ),
                  maxLines: 1,  // Allow multiple lines for the response
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter what you will be taking with you';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _whatWillYouTake = value;  // Update what the visitor will be taking
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Are you taking anyone with you?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildYesNoButton('Yes', true),
                    const SizedBox(width: 10),
                    _buildYesNoButton('No', false),                                                 
                  ],
                ),
                if (_isTakingSomeone) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'How many are coming with you?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter number of people',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of people';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _numberOfPeople = int.tryParse(value) ?? 0;
                        _emails = List.generate(
                          _numberOfPeople,
                          (index) => '',
                        );  // Initialize list with empty strings
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(
                    _numberOfPeople,
                        (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email ID of Person ${index + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter Email ID of Person ${index + 1}',
                          ),
                          onChanged: (value) {
                            if (index < _emails.length) {
                              _emails[index] = value;  // Update email addresses
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                const Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: _selectedDate == null
                            ? 'Select Date'
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      ),
                      validator: (value) {
                        if (_selectedDate == null) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select Time',
                  ),
                  value: _selectedTime == null
                      ? null
                      : formatTimeOfDay(_selectedTime!),
                  onChanged: _availableTimes.isNotEmpty
                      ? (newValue) {
                          _selectTime(newValue);
                        }
                      : null, // Disable time selection if no times available
                  items: _availableTimes.map((time) {
                    return DropdownMenuItem(
                      child: Text(time),
                      value: time,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 38, 49, 95),  // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),  // Button shape
                        ),
                        fixedSize: Size(400, 40),  // Button size
                      ),
                  child: const Text('Book Appointment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYesNoButton(String text, bool value) {
    return Expanded(
      child: Row(
        children: [
          Radio<bool>(
            value: value,
            groupValue: _isTakingSomeone,
            onChanged: (bool? newValue) {
              setState(() {
                _isTakingSomeone = newValue!;
                if (!_isTakingSomeone) {
                  _numberOfPeople = 0;
                  _emails.clear();  // Clear emails if "No" is selected
                }
              });
            },
          ),
          Text(text),
        ],
      ),
    );
  }
}