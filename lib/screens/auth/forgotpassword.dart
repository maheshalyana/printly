import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printly/screens/auth/login.dart';
import 'package:printly/screens/auth/signup.dart';
import 'package:printly/utils/utils.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../widgets/authbutton.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isPassword = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: height,
            width: width,
            child: Column(children: [
              Container(
                height: height * 0.45,
                width: width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/printer1.png',
                        height: height * 0.4,
                      ),
                    ),
                    Positioned(
                      top: height * 0.27,
                      child: Column(
                        children: [
                          Transform(
                            transform: Matrix4.identity()
                              ..setEntry(1, 2, 0.0010)
                              // ..rotateX(6)
                              ..rotateX(-7.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/images/icon.svg',
                                    color: Colors.black, height: width * 0.07),
                                Text(
                                  "Printly",
                                  style: TextStyle(
                                    fontSize: width * 0.07,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: utils.logoFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Transform(
                              transform: Matrix4.identity()
                                ..setEntry(1, 2, 0.0010)
                                // ..rotateX(6)
                                ..rotateX(-5.5),
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: Color.fromARGB(221, 0, 0, 0),
                                  fontSize: 25,
                                  fontFamily: utils.font,
                                  fontWeight: FontWeight.w700,
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Form(
                  child: Column(
                children: [
                  SizedBox(
                    width: width * 0.75,
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: utils.majorColor,
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4)),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Color(0xffcc7947),
                          fontSize: width * 0.03,
                        ),
                        hintText: "Email Address",
                        hintStyle: TextStyle(
                          color: Color(0x89000000),
                          fontSize: width * 0.03,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 299,
                    child: Text(
                      "You will receive instructions for resetting your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.15,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: MaterialButton(
                      onPressed: (() {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              builder: (contex) {
                                return Center(
                                  child: CircularProgressIndicator(
                                      color: utils.majorColor),
                                );
                              });
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email.text)
                              .then((value) {
                            const snackBar = SnackBar(
                              content:
                                  Text('Check you mail to reset your password'),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
                          });
                        }
                      }),
                      child: SubmitButton(
                        name: "PROCEED",
                      ),
                    ),
                  ),
                ],
              ))
            ]),
          )
        ],
      ),
    );
  }
}
