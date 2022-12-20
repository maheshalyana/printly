import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printly/screens/auth/login.dart';
import 'package:printly/utils/utils.dart';
import '../../widgets/filetile.dart';
import 'menu.dart';

class MyOrders extends StatefulWidget {
  MyOrders({
    super.key,
  });
  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
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
                              return len != 0
                                  ? index == 0
                                      ? Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "My Orders",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: width * 0.05,
                                                fontFamily: utils.font,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        )
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
                                        )
                                  : SizedBox(
                                      width: width * 0.7,
                                      height: height * 0.7,
                                      child: Center(
                                          child: Text(
                                        "No Orders to be print",
                                        style: TextStyle(
                                          color: Color(0x89000000),
                                          fontSize: width * 0.05,
                                          fontFamily: utils.font,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      )),
                                    );
                            });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
