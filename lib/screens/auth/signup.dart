import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printly/screens/auth/login.dart';
import 'package:printly/screens/userscreens/homescreen.dart';
import 'package:printly/utils/utils.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../widgets/authbutton.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
          login = true;
          id = verificationId;
        });

        print(id);

        // Sign the user in (or link) with the credential
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("timeout");
      },
    );
  }

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController rollnumber = TextEditingController();
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
                              ..rotateX(-5.2),
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
                                ..rotateX(-5.2),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Color.fromARGB(221, 0, 0, 0),
                                  fontSize: width * 0.09,
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
                          controller: username,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: utils.majorColor,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4)),
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: Color(0xffcc7947),
                              fontSize: width * 0.03,
                            ),
                            hintText: "Username",
                            hintStyle: TextStyle(
                              color: Color(0x89000000),
                              fontSize: width * 0.03,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: width * 0.75,
                        child: TextFormField(
                          controller: rollnumber,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: utils.majorColor,
                                width: 1,
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4)),
                            labelText: 'College rollnumber',
                            labelStyle: TextStyle(
                              color: Color(0xffcc7947),
                              fontSize: width * 0.03,
                            ),
                            hintText: "College rollnumber",
                            hintStyle: TextStyle(
                              color: Color(0x89000000),
                              fontSize: width * 0.03,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: width * 0.75,
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: width * 0.03, color: Colors.black),
                          controller: phoneNumber,
                          onEditingComplete: () {
                            print("submit");
                            registerUser(phoneNumber.text, context);
                          },
                          onSaved: (e) {
                            print("submit");

                            registerUser(phoneNumber.text, context);
                          },
                          onFieldSubmitted: (e) {
                            print("submit");

                            registerUser(phoneNumber.text, context);
                          },
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "This field is required"),
                            MinLengthValidator(10,
                                errorText: "enter valid phone number")
                          ]),
                          keyboardType: TextInputType.number,
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
                            labelText: 'Phone Number',
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
                        height: 10,
                      ),
                      SizedBox(
                        width: width * 0.75,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          enabled: login,
                          controller: password,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "This field is required"),
                            MinLengthValidator(6, errorText: "enter valid OTP")
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
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: MaterialButton(
                          enableFeedback: login,
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
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .set({
                                  "name": username.text,
                                  "profileImage":
                                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                  "rollNumber": rollnumber.text,
                                  "number": phoneNumber.text,
                                  "admin": false
                                });
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (route) => false);
                              });
                            }
                          }),
                          child: SubmitButton(
                            name: "SIGN UP",
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
                            "Already have an account?",
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
                                        builder: (context) => LoginScreen()),
                                    (route) => false);
                              },
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Color(0xffcc7947),
                                  fontSize: 14,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w700,
                                ),
                              ))
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
