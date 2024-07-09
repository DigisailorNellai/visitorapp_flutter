import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:visitor_app_flutter/pages/otp.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Center(
                    child: Text(
                  'Forget Password',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 13, 86, 146)),
                )),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                    'Please write your email to recieve a confirmation\n                      code to set a new password',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color.fromARGB(255, 15, 105, 179))),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                    width: 170,
                    height: 47,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30)),
                    child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => const Otp());
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 10, 80, 138))),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white),
                        ))),
              ],
            )),
      ),
    );
  }
}
