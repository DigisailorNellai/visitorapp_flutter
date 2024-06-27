import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:visitor_app_flutter/pages/QR.dart';

class BookAppointmentScreen extends StatefulWidget {
  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedStaff;
  String? _selectedStaffDepartment;
  List<String> _availableTimes = [];
  List<String> _staffList = [];
  List<String> _staffDepartmentsList = [];

  @override
  void initState() {
    super.initState();
    _fetchStaffList();
    _fetchDepartmentList();
  }

  void _fetchStaffList() async {
    QuerySnapshot staffSnapshot =
        await FirebaseFirestore.instance.collection('staff').get();
    setState(() {
      _staffList =
          staffSnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  void _fetchDepartmentList() async {
    QuerySnapshot staffSnapshot = await FirebaseFirestore.instance.collection('staff').get();
    setState(() {
      _staffDepartmentsList = staffSnapshot.docs.map((doc) => doc['department'] as String ).toList();
    });
  }

  void _fetchAvailableTimes() async {
    if (_selectedDate != null && _selectedStaff != null) {
      QuerySnapshot appointmentsSnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('staffId', isEqualTo: _selectedStaff)
          .where('date', isEqualTo: _selectedDate)
          .get();
      List bookedTimes =
          appointmentsSnapshot.docs.map((doc) => doc['time']).toList();
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
        _availableTimes =
            allTimes.where((time) => !bookedTimes.contains(time)).toList();
      });
    }
  }

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
        _selectedTime = null; // Reset selected time when date changes
      });
      _fetchAvailableTimes();
    }
  }

  void _selectTime(String? newValue) {
    setState(() {
      _selectedTime = parseTime(newValue!);
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectedStaff != null) {
      await FirebaseFirestore.instance.collection('appointments').add({
        'visitorId': FirebaseAuth.instance.currentUser?.uid,
        'date': _selectedDate,
        'time': _selectedTime!.format(context),
        'staffId': _selectedStaff,
        'staffDepartment': _selectedStaffDepartment,
        'status': 'pending',
      });
      String qrData =
          'Visitor ID: ${FirebaseAuth.instance.currentUser?.uid}, Date: $_selectedDate, Time: ${_selectedTime!.format(context)}, Staff ID: $_selectedStaff';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrCodeScreen(qrData: qrData),
        ),
      );
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hourOfPeriod.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hours:$minutes $period';
  }

  TimeOfDay parseTime(String time) {
    final parts = time.split(':');
    final hourPart = int.parse(parts[0]);
    final minutePart = int.parse(parts[1].split(' ')[0]);
    final period = parts[1].split(' ')[1];
    final isPM = period == 'PM';
    final hour =
        isPM ? (hourPart == 12 ? 12 : hourPart + 12) : (hourPart == 12 ? 0 : hourPart);
    return TimeOfDay(hour: hour, minute: minutePart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pick a date for Appointment',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _selectDate,
                    icon: Icon(Icons.calendar_today),
                  ),
                  SizedBox(width: 10),
                  Text(
                    _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : 'Pick a Date',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Select Staff',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                hint: Text('Select Staff'),
                value: _selectedStaff,
                onChanged: (newValue) {
                  setState(() {
                    _selectedStaff = newValue!;
                  });
                  _fetchAvailableTimes();
                },
                items: _staffList.map((staff) {
                  return DropdownMenuItem(
                    child: Text(staff),
                    value: staff,
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Select the department',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                hint: Text('Select Department'),
                value: _selectedStaffDepartment,
                onChanged: (newValue) {
                  setState(() {
                    _selectedStaffDepartment = newValue!;
                  });
                  _fetchAvailableTimes();
                },
                items: _staffDepartmentsList.map((Department) {
                  return DropdownMenuItem(
                    child: Text(Department),
                    value: Department,
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Select Time',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                hint: Text('Select Time'),
                value: _selectedTime == null ? null : formatTimeOfDay(_selectedTime!),
                onChanged: _selectedDate != null
                    ? _selectTime
                    : null, // Disable time selection if date is not selected
                items: _availableTimes.map((time) {
                  return DropdownMenuItem(
                    child: Text(time),
                    value: time,
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Book Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


