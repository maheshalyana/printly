import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printly/screens/auth/login.dart';
import 'package:printly/utils/utils.dart';
import '../../widgets/filetile.dart';
import 'menu.dart';

class Profile extends StatefulWidget {
  Profile({
    super.key,
  });
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
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
      body: Container(
        width: width,
        height: height * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.7,
              width: width * 0.9,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("orders")
                      .snapshots(),
                  builder: (context, snapshot) {
                    int len;
                    if (!snapshot.hasError) {
                      if (snapshot.hasData) {
                        len = snapshot.data!.docs.length;
                      } else {
                        len = 0;
                      }
                    } else {
                      len = 0;
                    }
                    return !snapshot.hasData
                        ? Center(
                            child: CircularProgressIndicator(
                              color: utils.majorColor,
                            ),
                          )
                        : ListView.builder(
                            itemCount: len + 1,
                            physics: len == 0
                                ? NeverScrollableScrollPhysics()
                                : AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return index == 0
                                  ? StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .snapshots(),
                                      builder: (context, snapShot) {
                                        return !snapShot.hasData
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: utils.majorColor,
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Image.asset(
                                                      'assets/images/profile.png',
                                                      height: 150,
                                                      width: 150,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      snapShot.data!
                                                          .get('name'),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: width * 0.06,
                                                        fontFamily: utils.font,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    snapShot.data!.get('email'),
                                                    style: TextStyle(
                                                      color: Color(0x89000000),
                                                      fontSize: width * 0.03,
                                                      fontFamily: utils.font,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   snapShot.data!
                                                  //       .get('mobileNumber'),
                                                  //   style: TextStyle(
                                                  //     color: Color(0x89000000),
                                                  //     fontSize: width * 0.03,
                                                  //     fontFamily: utils.font,
                                                  //     fontWeight: FontWeight.w900,
                                                  //   ),
                                                  // ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "My Orders",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              width * 0.05,
                                                          fontFamily:
                                                              utils.font,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.7,
                                                    height: len == 0
                                                        ? height * 0.4
                                                        : 0,
                                                    child: Center(
                                                      child: len == 0
                                                          ? Text(
                                                              "No Orders to be print",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0x89000000),
                                                                fontSize:
                                                                    width *
                                                                        0.05,
                                                                fontFamily:
                                                                    utils.font,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            )
                                                          : Container(),
                                                    ),
                                                  ),
                                                ],
                                              );
                                      })
                                  : OrdersTile(
                                      price:
                                          "${snapshot.data!.docs[index - 1]['price']}",
                                      color: snapshot.data!.docs[index - 1]
                                          ['color'],
                                      binding:
                                          "${snapshot.data!.docs[index - 1]['binding']}",
                                      copiesCount:
                                          "${snapshot.data!.docs[index - 1]['copiesCount']}",
                                      file: snapshot.data!.docs[index - 1]
                                          ['file'],
                                      name: snapshot.data!.docs[index - 1]
                                          ['fileName'],
                                    );
                            });
                  }),
            ),
            Expanded(
                child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Container(
                width: width * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: utils.majorColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: MaterialButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false);
                      });
                    },
                    child: Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                          fontFamily: utils.font,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
