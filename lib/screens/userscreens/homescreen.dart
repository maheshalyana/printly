import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printly/screens/userscreens/profile.dart';
import 'package:printly/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adddocuments.dart';
import 'menu.dart';
import 'myorders.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Printly",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontFamily: utils.logoFont,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      drawer: Drawer(
        child: Menu(),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: height * 0.3,
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                void setprofile(String number, String rollNumber) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("number", number);
                  prefs.setString("rollNumber", rollNumber);
                }
                if (snapshot.hasData) {
                  setprofile(snapshot.data!.get('number'),
                      snapshot.data!.get("rollNumber"));
                }
                return snapshot.hasData
                    ? Text(
                        "Hi ${snapshot.data!['name']},",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.06,
                          fontFamily: utils.font,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Text(
                        "Hi ...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.06,
                          fontFamily: utils.font,
                          fontWeight: FontWeight.w700,
                        ),
                      );
              }),
          SizedBox(
            height: 8,
          ),
          Text(
            "Hi, How May I assist you today?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: width * 0.045,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: width * 0.9,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1e000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Color(0x23000000),
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
                color: Color(0xffcc7947),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: MaterialButton(
                  onPressed: (() {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AddDocument()),
                        (route) => true);
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/Vector.svg"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "PRINT YOUR DOCUMENT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: utils.font,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          SizedBox(
            width: width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.25,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1e000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x23000000),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: Color(0xffcc7947),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: MaterialButton(
                      onPressed: (() {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyOrders()),
                            (route) => true);
                      }),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.asset(
                              "assets/images/order.svg",
                            ),
                          ),
                          Text(
                            "MY ORDERS",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.03,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.25,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1e000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x23000000),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: Color(0xffcc7947),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: MaterialButton(
                      onPressed: (() {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
                            (route) => true);
                      }),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.asset(
                              "assets/images/profile.svg",
                            ),
                          ),
                          Text(
                            "PROFILE",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.03,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.25,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1e000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x23000000),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color: Color(0xffcc7947),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: MaterialButton(
                      onPressed: (() {}),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.asset(
                              "assets/images/contact.svg",
                            ),
                          ),
                          Text(
                            "CONTACT US",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.03,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Text(
              "Joint venture from",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0x7f000000),
                fontFamily: utils.font,
                fontSize: 16,
              ),
            ),
          )),

          Image.asset("assets/images/alphax_logo.png"),
          // SvgPicture.asset("assets/images/alphax.svg"),
          SizedBox(
            height: height * 0.07,
          ),
        ],
      ),
    );
  }
}
