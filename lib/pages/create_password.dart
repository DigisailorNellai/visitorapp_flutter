import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_app_flutter/pages/main_page.dart';

class newPassword extends StatelessWidget {
  const newPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        const Text(
                          'Create Password',
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Color.fromARGB(255, 10, 83, 142)),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Re-enter Password',
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
                                  Get.to(() => Mainpage());
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 10, 80, 138))),
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.white),
                                ))),
                      ]),
                ))));
  }
}
