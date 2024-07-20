// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:intl/intl.dart';
// // class BookAppointmentScreen extends StatefulWidget {
// //   @override
// //   _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
// // }
// // class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   DateTime? _selectedDate;
// //   TimeOfDay? _selectedTime;
// //   String? _selectedStaff;
// //   String? _appointmentReason; // Reason for the appointment
// //   String? _whatWillYouTake; // What will you be taking with you
// //   bool _isTakingSomeone =
// //       false; // Whether the visitor is taking someone with them
// //   int _numberOfPeople = 0; // Number of people coming with the visitor
// //   List<String?> _emails =
// //       []; // List to store email addresses of people coming with the visitor
// //   List<String> _availableTimes = [];
// //   List<String> _staffList = []; // List of staff members
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchStaffList();
// //   }
// //   // Fetch staff names from Firestore
// //   void _fetchStaffList() async {
// //     try {
// //       QuerySnapshot querySnapshot =
// //           await FirebaseFirestore.instance.collection('staffs').get();
// //       List<String> staffNames =
// //           querySnapshot.docs.map((doc) => doc['name'] as String).toList();
// //       setState(() {
// //         _staffList = staffNames;
// //         _selectedStaff = null; // Reset selected staff when fetching new staff
// //         _selectedTime = null; // Reset selected time when fetching new staff
// //         _availableTimes
// //             .clear(); // Clear available times when fetching new staff
// //       });
// //     } catch (e) {
// //       print('Error fetching staff list: $e');
// //     }
// //   }
// //   // Fetch available times based on selected date and staff
// //   void _fetchAvailableTimes() async {
// //     if (_selectedDate == null || _selectedStaff == null)
// //       return; // Avoid fetching available times if date or staff is not selected
// //     // Sample available times data
// //     List<String> bookedTimes = []; // Sample empty booked times list
// //     List<String> allTimes = [
// //       '09:00 AM',
// //       '10:00 AM',
// //       '11:00 AM',
// //       '12:00 PM',
// //       '01:00 PM',
// //       '02:00 PM',
// //       '03:00 PM',
// //       '04:00 PM'
// //     ];
// //     setState(() {
// //       _availableTimes =
// //           allTimes.where((time) => !bookedTimes.contains(time)).toList();
// //     });
// //   }
// //   // Handle date selection
// //   void _selectDate() async {
// //     DateTime? pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime.now(),
// //       lastDate: DateTime(2101),
// //     );
// //     if (pickedDate != null) {
// //       setState(() {
// //         _selectedDate = pickedDate;
// //         _fetchAvailableTimes(); // Fetch available times after selecting a new date
// //       });
// //     }
// //   }
// //   // Handle time selection
// //   void _selectTime(String? newValue) {
// //     setState(() {
// //       _selectedTime = parseTime(newValue!);
// //     });
// //   }
// //   // Submit the form and book the appointment
// //   void _submitForm() async {
// //     if (_formKey.currentState!.validate() &&
// //         _selectedDate != null &&
// //         _selectedTime != null &&
// //         _selectedStaff != null) {
// //       DocumentReference appointmentRef =
// //           await FirebaseFirestore.instance.collection('appointments').add({
// //         'visitorId': FirebaseAuth.instance.currentUser?.uid,
// //         'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
// //         'time': _selectedTime!.format(context),
// //         'staffId': _selectedStaff,
// //         'reason': _appointmentReason, // Add the reason for the appointment
// //         'whatWillYouTake':
// //             _whatWillYouTake, // Add what the visitor will be taking
// //         'isTakingSomeone':
// //             _isTakingSomeone, // Whether the visitor is taking someone with them
// //         'numberOfPeople':
// //             _numberOfPeople, // Number of people coming with the visitor
// //         'emails': _emails, // Email addresses of people coming with the visitor
// //         'status': 'pending',
// //       });
// //     }
// //   }
// //   // Convert TimeOfDay to string
// //   String formatTimeOfDay(TimeOfDay time) {
// //     final hours = time.hourOfPeriod.toString().padLeft(2, '0');
// //     final minutes = time.minute.toString().padLeft(2, '0');
// //     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
// //     return '$hours:$minutes $period';
// //   }
// //   // Parse string to TimeOfDay
// //   TimeOfDay parseTime(String time) {
// //     final parts = time.split(':');
// //     final hourPart = int.parse(parts[0]);
// //     final minutePart = int.parse(parts[1].split(' ')[0]);
// //     final period = parts[1].split(' ')[1];
// //     final isPM = period == 'PM';
// //     final hour = isPM
// //         ? (hourPart == 12 ? 12 : hourPart + 12)
// //         : (hourPart == 12 ? 0 : hourPart);
// //     return TimeOfDay(hour: hour, minute: minutePart);
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Book Appointment')),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.all(20),
// //           child: Form(
// //             key: _formKey,
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   'Select Staff',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 DropdownButtonFormField<String>(
// //                   decoration: const InputDecoration(
// //                     border: OutlineInputBorder(),
// //                     hintText: 'Select Staff',
// //                   ),
// //                   value: _selectedStaff,
// //                   onChanged: _staffList.isNotEmpty
// //                       ? (newValue) {
// //                           setState(() {
// //                             _selectedStaff = newValue!;
// //                             _fetchAvailableTimes(); // Fetch available times for the selected staff
// //                           });
// //                         }
// //                       : null, // Disable staff selection if no staff available
// //                   items: _staffList.map((staff) {
// //                     return DropdownMenuItem(
// //                       child: Text(staff),
// //                       value: staff,
// //                     );
// //                   }).toList(),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 const Text(
// //                   'Reason for Appointment',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 TextFormField(
// //                   decoration: const InputDecoration(
// //                     border: OutlineInputBorder(),
// //                     hintText: 'Enter the reason for the appointment',
// //                   ),
// //                   maxLines: 3, // Allow multiple lines for the reason
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter a reason for the appointment';
// //                     }
// //                     return null;
// //                   },
// //                   onChanged: (value) {
// //                     _appointmentReason =
// //                         value; // Update the reason when the text changes
// //                   },
// //                 ),
// //                 const SizedBox(height: 20),
// //                 const Text(
// //                   'What will you be taking with you?',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 TextFormField(
// //                   decoration: const InputDecoration(
// //                     border: OutlineInputBorder(),
// //                     hintText: 'Enter what you will be taking with you',
// //                   ),
// //                   maxLines: 1, // Allow multiple lines for the response
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter what you will be taking with you';
// //                     }
// //                     return null;
// //                   },
// //                   onChanged: (value) {
// //                     _whatWillYouTake =
// //                         value; // Update what the visitor will be taking
// //                   },
// //                 ),
// //                 const SizedBox(height: 20),
// //                 const Text(
// //                   'Are you taking anyone with you?',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 Row(
// //                   children: [
// //                     _buildYesNoButton('Yes', true),
// //                     const SizedBox(width: 10),
// //                     _buildYesNoButton('No', false),
// //                   ],
// //                 ),
// //                 if (_isTakingSomeone) ...[
// //                   const SizedBox(height: 20),
// //                   const Text(
// //                     'How many are coming with you?',
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   TextFormField(
// //                     decoration: const InputDecoration(
// //                       border: OutlineInputBorder(),
// //                       hintText: 'Enter number of people',
// //                     ),
// //                     keyboardType: TextInputType.number,
// //                     validator: (value) {
// //                       if (value == null || value.isEmpty) {
// //                         return 'Please enter the number of people';
// //                       }
// //                       return null;
// //                     },
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _numberOfPeople = int.tryParse(value) ?? 0;
// //                         _emails = List.generate(
// //                           _numberOfPeople,
// //                           (index) => '',
// //                         ); // Initialize list with empty strings
// //                       });
// //                     },
// //                   ),
// //                   const SizedBox(height: 20),
// //                   ...List.generate(
// //                     _numberOfPeople,
// //                     (index) => Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         Text(
// //                           'Email ID of Person ${index + 1}',
// //                           style: TextStyle(
// //                               fontWeight: FontWeight.bold, fontSize: 16),
// //                         ),
// //                         TextFormField(
// //                           decoration: InputDecoration(
// //                             border: const OutlineInputBorder(),
// //                             hintText: 'Enter Email ID of Person ${index + 1}',
// //                           ),
// //                           onChanged: (value) {
// //                             if (index < _emails.length) {
// //                               _emails[index] = value; // Update email addresses
// //                             }
// //                           },
// //                         ),
// //                         const SizedBox(height: 10),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //                 const SizedBox(height: 20),
// //                 const Text(
// //                   'Date',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 GestureDetector(
// //                   onTap: _selectDate,
// //                   child: AbsorbPointer(
// //                     child: TextFormField(
// //                       decoration: InputDecoration(
// //                         border: const OutlineInputBorder(),
// //                         hintText: _selectedDate == null
// //                             ? 'Select Date'
// //                             : DateFormat('yyyy-MM-dd').format(_selectedDate!),
// //                       ),
// //                       validator: (value) {
// //                         if (_selectedDate == null) {
// //                           return 'Please select a date';
// //                         }
// //                         return null;
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 const Text(
// //                   'Time',
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                 ),
// //                 const SizedBox(height: 10),
// //                 DropdownButtonFormField<String>(
// //                   decoration: const InputDecoration(
// //                     border: OutlineInputBorder(),
// //                     hintText: 'Select Time',
// //                   ),
// //                   value: _selectedTime == null
// //                       ? null
// //                       : formatTimeOfDay(_selectedTime!),
// //                   onChanged: _availableTimes.isNotEmpty
// //                       ? (newValue) {
// //                           _selectTime(newValue);
// //                         }
// //                       : null, // Disable time selection if no times available
// //                   items: _availableTimes.map((time) {
// //                     return DropdownMenuItem(
// //                       child: Text(time),
// //                       value: time,
// //                     );
// //                   }).toList(),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 ElevatedButton(
// //                   onPressed: _submitForm,
// //                   style: ElevatedButton.styleFrom(
// //                     foregroundColor: Colors.white,
// //                     backgroundColor:
// //                         Color.fromARGB(255, 38, 49, 95), // Text color
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(5), // Button shape
// //                     ),
// //                     fixedSize: Size(400, 40), // Button size
// //                   ),
// //                   child: const Text('Book Appointment'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //   Widget _buildYesNoButton(String text, bool value) {
// //     return Expanded(
// //       child: Row(
// //         children: [
// //           Radio<bool>(
// //             value: value,
// //             groupValue: _isTakingSomeone,
// //             onChanged: (bool? newValue) {
// //               setState(() {
// //                 _isTakingSomeone = newValue!;
// //                 if (!_isTakingSomeone) {
// //                   _numberOfPeople = 0;
// //                   _emails.clear(); // Clear emails if "No" is selected
// //                 }
// //               });
// //             },
// //           ),
// //           Text(text),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class BookAppointmentScreen extends StatefulWidget {
//   @override
//   _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
// }

// class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   String? _selectedStaff;
//   String? _appointmentReason;
//   String? _whatWillYouTake;
//   bool _isTakingSomeone = false;
//   int _numberOfPeople = 0;
//   List<String?> _emails = [];
//   List<String> _availableTimes = [];
//   List<String> _staffList = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchStaffList();
//   }

//   void _fetchStaffList() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('staffs').get();
//       List<String> staffNames =
//           querySnapshot.docs.map((doc) => doc['name'] as String).toList();

//       setState(() {
//         _staffList = staffNames;
//         _selectedStaff = null;
//         _selectedTime = null;
//         _availableTimes.clear();
//       });
//     } catch (e) {
//       print('Error fetching staff list: $e');
//     }
//   }

//   void _fetchAvailableTimes() async {
//     if (_selectedDate == null || _selectedStaff == null) return;

//     List<String> bookedTimes = [];
//     List<String> allTimes = [
//       '09:00 AM',
//       '10:00 AM',
//       '11:00 AM',
//       '12:00 PM',
//       '01:00 PM',
//       '02:00 PM',
//       '03:00 PM',
//       '04:00 PM'
//     ];

//     setState(() {
//       _availableTimes =
//           allTimes.where((time) => !bookedTimes.contains(time)).toList();
//     });
//   }

//   void _selectDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//         _fetchAvailableTimes();
//       });
//     }
//   }

//   void _selectTime(String? newValue) {
//     setState(() {
//       _selectedTime = parseTime(newValue!);
//     });
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate() &&
//         _selectedDate != null &&
//         _selectedTime != null &&
//         _selectedStaff != null) {
//       DocumentReference appointmentRef =
//           await FirebaseFirestore.instance.collection('appointments').add({
//         'visitorId': FirebaseAuth.instance.currentUser?.uid,
//         'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
//         'time': _selectedTime!.format(context),
//         'staffId': _selectedStaff,
//         'reason': _appointmentReason,
//         'whatWillYouTake': _whatWillYouTake,
//         'isTakingSomeone': _isTakingSomeone,
//         'numberOfPeople': _numberOfPeople,
//         'emails': _emails,
//         'status': 'pending',
//       });

//       Navigator.pop(context); // Go back to the previous screen
//     }
//   }

//   String formatTimeOfDay(TimeOfDay time) {
//     final hours = time.hourOfPeriod.toString().padLeft(2, '0');
//     final minutes = time.minute.toString().padLeft(2, '0');
//     final period = time.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$hours:$minutes $period';
//   }

//   TimeOfDay parseTime(String time) {
//     final parts = time.split(':');
//     final hourPart = int.parse(parts[0]);
//     final minutePart = int.parse(parts[1].split(' ')[0]);
//     final period = parts[1].split(' ')[1];
//     final isPM = period == 'PM';
//     final hour = isPM
//         ? (hourPart == 12 ? 12 : hourPart + 12)
//         : (hourPart == 12 ? 0 : hourPart);
//     return TimeOfDay(hour: hour, minute: minutePart);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Book Appointment')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Select Staff',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Select Staff',
//                   ),
//                   value: _selectedStaff,
//                   onChanged: _staffList.isNotEmpty
//                       ? (newValue) {
//                           setState(() {
//                             _selectedStaff = newValue!;
//                             _fetchAvailableTimes();
//                           });
//                         }
//                       : null,
//                   items: _staffList.map((staff) {
//                     return DropdownMenuItem(
//                       child: Text(staff),
//                       value: staff,
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Reason for Appointment',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter the reason for the appointment',
//                   ),
//                   maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a reason for the appointment';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     _appointmentReason = value;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'What will you be taking with you?',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter what you will be taking with you',
//                   ),
//                   maxLines: 1,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter what you will be taking with you';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     _whatWillYouTake = value;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Are you taking anyone with you?',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     _buildYesNoButton('Yes', true),
//                     const SizedBox(width: 10),
//                     _buildYesNoButton('No', false),
//                   ],
//                 ),
//                 if (_isTakingSomeone) ...[
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Number of People',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Enter the number of people coming with you',
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (_isTakingSomeone &&
//                           (value == null || value.isEmpty)) {
//                         return 'Please enter the number of people coming with you';
//                       }
//                       if (_isTakingSomeone && int.tryParse(value!) == null) {
//                         return 'Please enter a valid number';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       _numberOfPeople =
//                           int.tryParse(value!) ?? 0; // Update number of people
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Emails of People Coming with You',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                   const SizedBox(height: 10),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: _numberOfPeople,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10),
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(),
//                             hintText:
//                                 'Enter email address for person ${index + 1}',
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) {
//                             if (_isTakingSomeone &&
//                                 (value == null || value.isEmpty)) {
//                               return 'Please enter an email address';
//                             }
//                             if (_isTakingSomeone &&
//                                 !RegExp(r'^[^@]+@[^@]+\.[^@]+')
//                                     .hasMatch(value!)) {
//                               return 'Please enter a valid email address';
//                             }
//                             return null;
//                           },
//                           onChanged: (value) {
//                             if (index < _emails.length) {
//                               _emails[index] = value;
//                             } else {
//                               _emails.add(value);
//                             }
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Select Date',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 TextButton(
//                   onPressed: _selectDate,
//                   child: const Text('Select Date'),
//                 ),
//                 if (_selectedDate != null)
//                   Text(
//                     'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Select Time',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Select Time',
//                   ),
//                   value: _selectedTime != null
//                       ? formatTimeOfDay(_selectedTime!)
//                       : null,
//                   onChanged: _availableTimes.isNotEmpty ? _selectTime : null,
//                   items: _availableTimes.map((time) {
//                     return DropdownMenuItem(
//                       child: Text(time),
//                       value: time,
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _submitForm,
//                     child: const Text('Submit'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildYesNoButton(String text, bool value) {
//     return Expanded(
//       child: ElevatedButton(
//         onPressed: () {
//           setState(() {
//             _isTakingSomeone = value;
//           });
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//               _isTakingSomeone == value ? Colors.blue : Colors.grey,
//         ),
//         child: Text(text),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookAppointmentScreen extends StatefulWidget {
  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedStaff;
  String? _appointmentReason;
  String? _whatWillYouTake;
  bool _isTakingSomeone = false;
  int _numberOfPeople = 0;
  List<String?> _emails = [];
  List<String> _availableTimes = [];
  List<String> _staffList = [];

  @override
  void initState() {
    super.initState();
    _fetchStaffList();
  }

  void _fetchStaffList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('staffs').get();
      List<String> staffNames =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();

      setState(() {
        _staffList = staffNames;
        _selectedStaff = null;
        _selectedTime = null;
        _availableTimes.clear();
      });
    } catch (e) {
      print('Error fetching staff list: $e');
    }
  }

  void _fetchAvailableTimes() async {
    if (_selectedDate == null || _selectedStaff == null) return;

    List<String> bookedTimes = [];
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
        _fetchAvailableTimes();
      });
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
      DocumentReference appointmentRef =
          await FirebaseFirestore.instance.collection('appointments').add({
        'visitorId': FirebaseAuth.instance.currentUser?.uid,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'time': _selectedTime!.format(context),
        'staffId': _selectedStaff,
        'reason': _appointmentReason,
        'whatWillYouTake': _whatWillYouTake,
        'isTakingSomeone': _isTakingSomeone,
        'numberOfPeople': _numberOfPeople,
        'emails': _emails,
        'status': 'pending',
      });

      Navigator.pop(context); // Go back to the previous screen
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
                            _fetchAvailableTimes();
                          });
                        }
                      : null,
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
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason for the appointment';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _appointmentReason = value;
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
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter what you will be taking with you';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _whatWillYouTake = value;
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
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Yes'),
                        value: true,
                        groupValue: _isTakingSomeone,
                        onChanged: (value) {
                          setState(() {
                            _isTakingSomeone = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('No'),
                        value: false,
                        groupValue: _isTakingSomeone,
                        onChanged: (value) {
                          setState(() {
                            _isTakingSomeone = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_isTakingSomeone) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Number of People',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the number of people coming with you',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (_isTakingSomeone &&
                          (value == null || value.isEmpty)) {
                        return 'Please enter the number of people coming with you';
                      }
                      if (_isTakingSomeone && int.tryParse(value!) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _numberOfPeople =
                          int.tryParse(value!) ?? 0; // Update number of people
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Emails of People Coming with You',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _numberOfPeople,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText:
                                'Enter email address for person ${index + 1}',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (_isTakingSomeone &&
                                (value == null || value.isEmpty)) {
                              return 'Please enter an email address';
                            }
                            if (_isTakingSomeone &&
                                !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                    .hasMatch(value!)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              if (index < _emails.length) {
                                _emails[index] = value;
                              } else {
                                _emails.add(value);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),
                const Text(
                  'Select Date',
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
                  'Select Time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select Time',
                  ),
                  value: _selectedTime != null
                      ? formatTimeOfDay(_selectedTime!)
                      : null,
                  onChanged: (newValue) {
                    _selectTime(newValue);
                  },
                  items: _availableTimes.map((time) {
                    return DropdownMenuItem(
                      child: Text(time),
                      value: time,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Book Appointment'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}









// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// class BookAppointmentScreen extends StatefulWidget {
//   @override
//   _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
// }
// class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   String? _selectedStaff;
//   String? _appointmentReason;
//   String? _whatWillYouTake;
//   bool _isTakingSomeone = false;
//   int _numberOfPeople = 0;
//   List<String?> _emails = [];
//   List<String> _availableTimes = [];
//   List<String> _staffList = [];
//   @override
//   void initState() {
//     super.initState();
//     _fetchStaffList();
//   }
//   void _fetchStaffList() async {
//     final staffSnapshot =
//         await FirebaseFirestore.instance.collection('staffs').get();
//     final staffNames =
//         staffSnapshot.docs.map((doc) => doc['name'] as String).toList();
//     setState(() {
//       _staffList = staffNames;
//       _selectedStaff = null;
//       _selectedTime = null;
//       _availableTimes.clear();
//     });
//   }
//   void _fetchAvailableTimes() async {
//     if (_selectedDate == null || _selectedStaff == null) return;
//     final appointmentsSnapshot = await FirebaseFirestore.instance
//         .collection('appointments')
//         .where('staffId', isEqualTo: _selectedStaff)
//         .where('date',
//             isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDate!))
//         .get();
//     final bookedTimes =
//         appointmentsSnapshot.docs.map((doc) => doc['time'] as String).toList();
//     final allTimes = [
//       '09:00 AM',
//       '10:00 AM',
//       '11:00 AM',
//       '12:00 PM',
//       '01:00 PM',
//       '02:00 PM',
//       '03:00 PM',
//       '04:00 PM'
//     ];
//     setState(() {
//       _availableTimes =
//           allTimes.where((time) => !bookedTimes.contains(time)).toList();
//     });
//   }
//   void _selectDate() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//         _fetchAvailableTimes();
//       });
//     }
//   }
//   void _selectTime(String? newValue) {
//     setState(() {
//       _selectedTime = parseTime(newValue!);
//     });
//   }
//   void _submitForm() async {
//     if (_formKey.currentState!.validate() &&
//         _selectedDate != null &&
//         _selectedTime != null &&
//         _selectedStaff != null) {
//       // Save appointment details to Firestore
//       final appointmentRef =
//           await FirebaseFirestore.instance.collection('appointments').add({
//         'visitorId': FirebaseAuth.instance.currentUser?.uid,
//         'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
//         'time': _selectedTime!.format(context),
//         'staffId': _selectedStaff,
//         'reason': _appointmentReason,
//         'whatWillYouTake': _whatWillYouTake,
//         'isTakingSomeone': _isTakingSomeone,
//         'numberOfPeople': _numberOfPeople,
//         'emails': _emails,
//         'status': 'pending',
//       });
//       // Notify selected staff
//       final staffSnapshot = await FirebaseFirestore.instance
//           .collection('staffs')
//           .where('name', isEqualTo: _selectedStaff)
//           .get();
//       if (staffSnapshot.docs.isNotEmpty) {
//         final staffId = staffSnapshot.docs.first.id;
//         await FirebaseFirestore.instance.collection('notifications').add({
//           'recipientId': staffId,
//           'message': 'You have a new appointment request.',
//           'createdAt': Timestamp.now(),
//           'read': false,
//         });
//       }
//       // Reset form fields or show success message as needed
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Appointment booked successfully.'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Book Appointment')),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Select Staff',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Select Staff',
//                   ),
//                   value: _selectedStaff,
//                   onChanged: _staffList.isNotEmpty
//                       ? (newValue) {
//                           setState(() {
//                             _selectedStaff = newValue!;
//                             _fetchAvailableTimes();
//                           });
//                         }
//                       : null,
//                   items: _staffList.map((staff) {
//                     return DropdownMenuItem(
//                       child: Text(staff),
//                       value: staff,
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Reason for Appointment',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter the reason for the appointment',
//                   ),
//                   maxLines: 3,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a reason for the appointment';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     _appointmentReason = value;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'What will you be taking with you?',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter what you will be taking with you',
//                   ),
//                   maxLines: 1,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter what you will be taking with you';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     _whatWillYouTake = value;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: _isTakingSomeone,
//                       onChanged: (checked) {
//                         setState(() {
//                           _isTakingSomeone = checked!;
//                         });
//                       },
//                     ),
//                     const Text('Are you taking someone with you?'),
//                   ],
//                 ),
//                 if (_isTakingSomeone)
//                   TextFormField(
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Enter number of people',
//                     ),
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       _numberOfPeople = int.tryParse(value) ?? 0;
//                     },
//                   ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Email(s) to Notify (Optional)',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter email(s) separated by commas',
//                   ),
//                   onChanged: (value) {
//                     _emails = value.split(',').map((e) => e.trim()).toList();
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Select Date and Time',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: _selectDate,
//                       child: const Text('Select Date'),
//                     ),
//                     const SizedBox(width: 10),
//                     if (_selectedDate != null)
//                       Text(DateFormat('yyyy-MM-dd').format(_selectedDate!)),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<String>(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Select Time',
//                   ),
//                   value: _selectedTime != null
//                       ? formatTimeOfDay(_selectedTime!)
//                       : null,
//                   onChanged: _availableTimes.isNotEmpty ? _selectTime : null,
//                   items: _availableTimes.map((time) {
//                     return DropdownMenuItem(
//                       child: Text(time),
//                       value: time,
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _submitForm,
//                     child: const Text('Book Appointment'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   TimeOfDay? parseTime(String s) {
//     final format = DateFormat.jm(); //"6:00 AM"
//     return TimeOfDay.fromDateTime(format.parse(s));
//   }
//   String formatTimeOfDay(TimeOfDay timeOfDay) {
//     final now = DateTime.now();
//     final dt = DateTime(
//         now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
//     final format = DateFormat.jm(); //"6:00 AM"
//     return format.format(dt);
//   }
// }
