import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printly/screens/auth/signup.dart';
import 'package:printly/screens/userscreens/homescreen.dart';
import 'package:printly/utils/utils.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:printly/utils/utils.dart';
import '../../widgets/authbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  double size1 = 5;
  double size2 = 8;
  @override
  void initState() {
    Timer(Duration(milliseconds: 10), () {
      setState(() {
        size1 = 15;
        size2 = 15;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  var otp = null;
  var id;
  bool login = false;
  Future registerUser(String mobile, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: "+91 $mobile",
      verificationCompleted: (PhoneAuthCredential credential) {
        print("success");
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "invalid-phone-number") {
          showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    width: 300,
                    height: 300,
                    child: Material(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: 270,
                              child: Center(
                                child: Text(
                                  "Please enter the phone number",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: utils.font,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: SubmitButton(
                                  name: 'okay',
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        }
        print("failed$e");
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          loading = false;
          login = true;
          id = verificationId;
        });
        Navigator.pop(context);

        print(id);

        // Sign the user in (or link) with the credential
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("timeout");
      },
    );
  }

  TextEditingController phoneNumber = TextEditingController();
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
                                ..rotateX(-7.1),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Color.fromARGB(221, 0, 0, 0),
                                  fontSize: 30,
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
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: width * 0.75,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: width * 0.03, color: Colors.black),
                          controller: phoneNumber,
                          validator: MultiValidator(
                            [
                              RequiredValidator(
                                  errorText: "This field is required"),
                              MinLengthValidator(10,
                                  errorText: "enter valid phone number")
                            ],
                          ),
                          decoration: InputDecoration(
                            suffix: login
                                ? Text(
                                    "✓",
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text(""),
                            prefix: Text(
                              "+91 ",
                              style: TextStyle(
                                  fontSize: width * 0.03, color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: utils.majorColor,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4)),
                            labelText: 'Phone Number*',
                            labelStyle: TextStyle(
                              color: Color(0xffcc7947),
                              fontSize: width * 0.03,
                            ),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                              color: Color(0x89000000),
                              fontSize: width * 0.03,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: width * 0.75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 0.5,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                enabled: login,
                                controller: password,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "This field is required"),
                                  MinLengthValidator(6,
                                      errorText: "enter valid otp")
                                ]),
                                obscureText: isPassword,
                                decoration: InputDecoration(
                                  focusColor: utils.majorColor,
                                  suffixIconColor: utils.majorColor,
                                  suffixIcon: GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        isPassword = !isPassword;
                                      });
                                    }),
                                    child: Icon(
                                      !isPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: utils.majorColor,
                                      width: 1,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  labelText: 'OTP',
                                  labelStyle: TextStyle(
                                    color: Color(0xffcc7947),
                                    fontSize: width * 0.03,
                                  ),
                                  hintText: "OTP",
                                  hintStyle: TextStyle(
                                    color: Color(0x89000000),
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                if (phoneNumber.text.length == 10) {
                                  loading = true;
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            color: Colors.white,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: utils.majorColor,
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                  registerUser(phoneNumber.text, context);
                                }
                              },
                              enableFeedback: !loading,
                              child: AnimatedContainer(
                                width: width * 0.2,
                                height: 50,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black38,
                                      offset: Offset(0, 5),
                                      blurRadius: 5,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(4),
                                  color: utils.majorColor,
                                ),
                                duration: Duration(milliseconds: 1500),
                                child: ClipRRect(
                                  child: Stack(children: [
                                    Positioned(
                                        top: -4,
                                        left: -3,
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                              milliseconds: 2000),
                                          height: size2,
                                          width: size2,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xffb26536),
                                              width: 1,
                                            ),
                                          ),
                                        )),
                                    Positioned(
                                        top: -5,
                                        right: 2,
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                              milliseconds: 2000),
                                          height: size2,
                                          width: size2,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xffb26536),
                                              width: 1,
                                            ),
                                          ),
                                        )),
                                    Positioned(
                                        bottom: -5,
                                        right: -2,
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                              milliseconds: 2000),
                                          height: size1,
                                          width: size1,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xffb26435),
                                          ),
                                        )),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "GET OTP",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: utils.font,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(right: width * 0.1, top: 10),
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: TextButton(
                      //       onPressed: () {
                      //         Navigator.pushAndRemoveUntil(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => ForgotPassword()),
                      //             (route) => false);
                      //       },
                      //       child: Text(
                      //         "Forgot password?",
                      //         style: TextStyle(
                      //           color: Color(0xffcc7947),
                      //           fontSize: 14,
                      //           fontFamily: utils.font,
                      //           fontWeight: FontWeight.w700,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: height * 0.1,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: MaterialButton(
                          onPressed: (() {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: utils.majorColor,
                                      ),
                                    );
                                  });
                              PhoneAuthCredential authCred =
                                  PhoneAuthProvider.credential(
                                      verificationId: id,
                                      smsCode: password.text);
                              FirebaseAuth.instance
                                  .signInWithCredential(authCred)
                                  .then((value) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (route) => false);
                              });
                            }
                          }),
                          child: SubmitButton(
                            name: "SIGN IN",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account?",
                            style: TextStyle(
                              color: Color(0xff3d3d3d),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()),
                                  (route) => false);
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Color(0xffcc7947),
                                fontSize: 14,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ]),
          )
        ],
      ),
    );
  }
}
