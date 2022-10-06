import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printly/screens/auth/forgotpassword.dart';
import 'package:printly/screens/auth/signup.dart';
import 'package:printly/screens/userscreens/homescreen.dart';
import 'package:printly/utils/utils.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../widgets/authbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    height: 20,
                  ),
                  SizedBox(
                    width: width * 0.75,
                    child: TextFormField(
                      controller: password,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "This field is required"),
                        MinLengthValidator(8,
                            errorText: "This password is too shorter")
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
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Color(0xffcc7947),
                          fontSize: width * 0.03,
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Color(0x89000000),
                          fontSize: width * 0.03,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width * 0.1, top: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                              (route) => false);
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: Color(0xffcc7947),
                            fontSize: 14,
                            fontFamily: utils.font,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: MaterialButton(
                      onPressed: (() {
                       if(_formKey.currentState!.validate()) {
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
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email.text, password: password.text)
                              .then((value) async {
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (route) => false);
                          }).catchError((e) async {
                            if (e is PlatformException) {
                              if (e.code == 'wrong-password') {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (contex) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: height * 0.3,
                                            width: width * 0.8,
                                            child: Center(
                                                child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Material(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Wrong Password\n Retry...!',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              width * 0.04,
                                                          fontFamily:
                                                              "Urbanist",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.5,
                                                      height: 56,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            Color(0xff1e232c),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: MaterialButton(
                                                            onPressed: (() {
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                            child: Center(
                                                              child: Text(
                                                                "Ok",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      width *
                                                                          0.04,
                                                                  fontFamily:
                                                                      "Urbanist",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                          ),
                                        ],
                                      );
                                    });
                              } else if (e.code == 'user-not-found') {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (contex) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: height * 0.3,
                                            width: width * 0.8,
                                            child: Center(
                                                child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Material(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "User Doesn't exists\n Please create an account",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              width * 0.04,
                                                          fontFamily:
                                                              "Urbanist",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: width * 0.5,
                                                      height: 56,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            Color(0xff1e232c),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: MaterialButton(
                                                            onPressed: (() {
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SignUp()),
                                                                  (route) =>
                                                                      false);
                                                            }),
                                                            child: Center(
                                                              child: Text(
                                                                "Register",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      width *
                                                                          0.04,
                                                                  fontFamily:
                                                                      "Urbanist",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                          ),
                                        ],
                                      );
                                    });
                              } else if (e.code == 'invalid-mail') {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (contex) {
                                      return Center(
                                          child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Material(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Check your mail correctly",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: width * 0.04,
                                                    fontFamily: "Urbanist",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                // width: width * 0.,
                                                height: 56,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Color(0xff1e232c),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: MaterialButton(
                                                      onPressed: (() {
                                                        Navigator.pop(context);
                                                      }),
                                                      child: Center(
                                                        child: Text(
                                                          "OK",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                width * 0.04,
                                                            fontFamily:
                                                                "Urbanist",
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                    });
                              } else {
                                Navigator.pop(context);
                              }
                            } else {
                              Navigator.pop(context);
                              // Navigator.pushAndRemoveUntil(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => HomeScreen()),
                              //     (route) => false);
                            }
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
