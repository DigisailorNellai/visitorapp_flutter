import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:visitor_app_flutter/pages/QR.dart';
import 'package:visitor_app_flutter/pages/user.dart';

class BookAppointmentScreen extends StatefulWidget {
  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedStaff;
  String? _selectedDepartment;
  List<String> _availableTimes = [];
  List<String> _staffList = [];
  List<String> _departmentsList = [
    'HR',
    'Engineering',
    'Marketing',
    'Finance',
    'Sales',
  ];
  Map<String, String> _staffDepartments = {}; // Map to store staff and their departments

  @override
  void initState() {
    super.initState();
    _fetchStaffList();
  }

  // Fetch staff names based on selected department
  void _fetchStaffList() async {
    if (_selectedDepartment == null) return; // Avoid fetching staff if department is not selected

    // Sample staff data (In a real app, this data will be fetched from Firestore)
    final staffData = {
      'John Doe': 'HR',
      'Jane Smith': 'Engineering',
      'Mike Johnson': 'Marketing',
      'Emily Davis': 'Finance',
      'Chris Brown': 'Sales',
    };

    List<String> staffNames = [];
    Map<String, String> staffDepartments = {};

    staffData.forEach((name, department) {
      if (department == _selectedDepartment) {
        staffDepartments[name] = department;
        staffNames.add(name);
      }
    });

    setState(() {
      _staffDepartments = staffDepartments;
      _staffList = staffNames;
      _selectedStaff = null;  // Reset selected staff when department changes
      _selectedTime = null;   // Reset selected time when department changes
      _availableTimes.clear(); // Clear available times when department changes
    });
  }

  // Fetch available times based on selected date and staff
  void _fetchAvailableTimes() async {
    if (_selectedDate == null || _selectedStaff == null) return; // Avoid fetching available times if date or staff is not selected

    // Sample available times data (In a real app, this data will be fetched from Firestore)
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
        _selectedStaff != null &&
        _selectedDepartment != null) {
      await FirebaseFirestore.instance.collection('appointments').add({
        'visitorId': FirebaseAuth.instance.currentUser?.uid,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'time': _selectedTime!.format(context),
        'staffId': _selectedStaff,
        'staffDepartment': _selectedDepartment,
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
            staffDepartment: _selectedDepartment!,
            onAccept: (bool accepted) {
              if (accepted) {
                // Navigate to QR Code screen
                String qrData =
                    'Visitor ID: ${FirebaseAuth.instance.currentUser?.uid}, Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}, Time: ${_selectedTime!.format(context)}, Staff ID: $_selectedStaff, Department: $_selectedDepartment';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrCodeScreen(qrData: qrData),
                  ),
                );
              } else {
                // Handle decline logic
                // Update appointment status to 'declined' in Firestore
                // Show decline message
              }
            },
            onDecline: (bool declined) {
              // Update appointment status to 'declined' in Firestore
              // Show decline message
            },
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pick a Date for Appointment',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today),
                  ),
                  SizedBox(width: 10),
                  Text(
                    _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : 'Pick a Date',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Department',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                hint: const Text('Select Department'),
                value: _selectedDepartment,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDepartment = newValue!;
                    _fetchStaffList();  // Fetch staff based on the selected department
                  });
                },
                items: _departmentsList.map((department) {
                  return DropdownMenuItem(
                    child: Text(department),
                    value: department,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Staff',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                hint: Text('Select Staff'),
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
                'Select Time',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                hint: const Text('Select Time'),
                value: _selectedTime == null
                    ? null
                    : formatTimeOfDay(_selectedTime!),
                onChanged: _selectedDate != null && _selectedStaff != null
                    ? _selectTime
                    : null, // Disable time selection if date or staff is not selected
                items: _availableTimes.map((time) {
                  return DropdownMenuItem(
                    child: Text(time),
                    value: time,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 15, 66, 107),
                )),
                onPressed: _submitForm,
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
