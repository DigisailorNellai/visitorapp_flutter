import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/pages/create_password.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  final int _numberOfFields = 4;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(_numberOfFields, (index) => FocusNode());
    _controllers =
        List.generate(_numberOfFields, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (int i = 0; i < _numberOfFields; i++) {
      _focusNodes[i].dispose();
      _controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'Verification Code',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color.fromARGB(255, 14, 89, 150)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                    child: Center(
                      child: Text(
                        'The otp has been sent to your registered mail id\nexample@gmail.com',
                        style: TextStyle(
                            color: Color.fromARGB(255, 19, 90, 148),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      _numberOfFields,
                      (index) => SizedBox(
                        width: 50.0,
                        child: TextFormField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (value) {
                            if (value.length == 1 &&
                                index < _numberOfFields - 1) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index + 1]);
                            } else if (value.length == 0 && index > 0) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index - 1]);
                            }
                          },
                          decoration: InputDecoration(
                            counter: const Offstage(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                //color: Theme.of(context).accentColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => const newPassword());
                      },
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 10, 84, 144))),
                      child: const Text(
                        'Verify',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ))
                ],
              )),
        ));
  }
}
