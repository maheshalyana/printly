import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printly/screens/auth/login.dart';
import 'package:printly/screens/userscreens/homescreen.dart';
import 'package:printly/utils/utils.dart';

import 'myorders.dart';
import 'profile.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: utils.majorColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width * 0.1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset('assets/images/icon.svg',
                                color: Colors.white, height: width * 0.08),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Printly",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.08,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: utils.logoFont,
                                ),
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.hasData
                                    ? "Hi,\n${snapshot.data!.get("name")}"
                                    : "Hi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.1,
                                  fontFamily: utils.font,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            }),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        TextButton(
                          onPressed: (() {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (route) => false);
                          }),
                          child: Text(
                            "Dashboard",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: (() {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyOrders()),
                                (route) => true);
                          }),
                          child: Text(
                            "My Orders",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: (() {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()),
                                (route) => true);
                          }),
                          child: Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: (() {}),
                          child: Text(
                            "About",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: (() {}),
                          child: Text(
                            "Contact seller",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: (() {}),
                          child: Text(
                            "Contact developer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.04,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Center(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    width: width * 0.5,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: MaterialButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((e) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (route) => false);
                          });
                        },
                        child: Center(
                          child: Text(
                            "LOG OUT",
                            style: TextStyle(
                              color: utils.majorColor,
                              fontSize: width * 0.04,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: height * 0.04,
          ),
        ],
      ),
    );
  }
}
