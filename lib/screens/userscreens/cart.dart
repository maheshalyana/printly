// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printly/screens/userscreens/adddocuments.dart';
import 'package:printly/screens/userscreens/orderreceived.dart';
import 'package:printly/utils/utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'menu.dart';
// ignore: depend_on_referenced_packages
import 'package:fluttertoast/fluttertoast.dart' show Fluttertoast, Toast;

class CartScreen extends StatefulWidget {
  CartScreen({super.key, required this.documents});
  List documents;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with WidgetsBindingObserver {
  late Razorpay _razorpay = Razorpay();

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(String orderID, double amount, String description,
      String name, String key, String api) async {
    print("cost");
    print(amount);
    amount = amount / 0.95;
    amount = double.parse("${amount.floor()}");
    amount = amount + 1;
    var options = {
      'key': api,
      'amount': amount * 100,
      'name': name,
      'description': description,
      'retry': {'enabled': true, 'max_count': 2},
      'send_sms_hash': true,
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      },
      // "order_id": orderID,
      "theme.color": "#3399cc"
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e}');
    }
  }

  bool loading = false;
  void set() {
    setState(() {
      cost = 0;
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
        msg: "Successfully completed", toastLength: Toast.LENGTH_SHORT);
    var postdat = {
      "razorpay_payment_id": response.paymentId,
      "razorpay_order_id": response.orderId,
      "razorpay_signature": response.signature
    };
    // print(response.paymentId);
    // print(response.orderId);
    // print(response.signature);

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? number = pref.getString('number');
    String? rollNumber = pref.getString('rollNumber');

    for (int i = 0; i < details.length; i++) {
      File? imageFile = details[i][0];
      print("adding file to DB");
      final ref = FirebaseStorage.instance
          .ref()
          .child("orders")
          .child(DateTime.now().toString());
      await ref.putFile(imageFile!);
      String imageUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .add({
        "fileName": details[0][0]
            .toString()
            .split("/")[details[0].toString().split("/").length - 1],
        "file": imageUrl,
        "copiesCount": details[i][1],
        "color": details[i][2],
        "binding": details[i][3] == 0
            ? " Spiral binding"
            : details[i][3] == 1
                ? " Thermal binding"
                : "No binding",
        "price": details[i][4],
        "twoSide": details[i][5],
        "no_of_pages": details[i][6],
        "friend": friend,
        "number": friend ? phonenumber.text : number,
        "rollNumber": friend ? rollnumber.text : rollNumber,
      }).then((value) {
        FirebaseFirestore.instance.collection("orders").add({
          "pdfFile": imageUrl,
          "orderId": value.id,
          "userId": FirebaseAuth.instance.currentUser!.uid,
          "file": imageUrl,
          "copiesCount": details[i][1],
          "color": details[i][2],
          "binding": details[i][3] == 0
              ? " Spiral binding"
              : details[i][3] == 1
                  ? " Thermal binding"
                  : "No binding",
          "price": details[i][4],
          "twoSide": details[i][5],
          "no_of_pages": details[i][6],
          "friend": friend,
          "number": friend ? phonenumber.text : number,
          "rollNumber": friend ? rollnumber.text : rollNumber,
        });
      });
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => OrderRecieved(documents: details)),
          (route) => false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "Sorry an error occured,please try again",
        toastLength: Toast.LENGTH_LONG);
    print("ERROR: " + response.code.toString() + " - " + response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  double cost = 0;
  bool friend = false;
  List details = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    WidgetsBinding.instance.addObserver(this);

    details = widget.documents;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    try {
      setState(() {
        cost = 0;
        for (int i = 0; i < details.length; i++) {
          cost = cost + details[i][7];
        }
      });
    } catch (e) {}
  }

  TextEditingController phonenumber = TextEditingController();
  TextEditingController rollnumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cost = 0;
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
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("prices")
              .doc("prices")
              .snapshots(),
          builder: (context, snapShot) {
            // double bwPrint = 3;
            // double bwXerox = 2;
            // double colorPrint = 10;
            // double colorXerox = 5;
            // double spiralBinding = 20;
            // double thermalBinding = 30;
            // if (snapShot.hasData) {
            double bwPrint = double.parse("${snapShot.data!.get("bwPrint")}");
            double bwXerox = double.parse("${snapShot.data!.get("bwXerox")}");
            double colorPrint =
                double.parse("${snapShot.data!.get("colorPrint")}");
            double colorXerox =
                double.parse("${snapShot.data!.get("colorXerox")}");
            double spiralBinding =
                double.parse("${snapShot.data!.get("spiralBinding")}");
            double thermalBinding =
                double.parse("${snapShot.data!.get("thermalBinding")}");
            // }

            return !snapShot.hasData
                ? Center(
                    child: CircularProgressIndicator(color: utils.majorColor),
                  )
                : Container(
                    width: width,
                    height: height * 0.85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          height: height * 0.5,
                          width: width * 0.9,
                          child: details.length == 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "No files to print",
                                      style: TextStyle(
                                        color: Colors.black,
                                        // fontSize:
                                        //     width * 0.04,
                                        fontFamily: utils.font,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: width * 0.9,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: utils.majorColor,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddDocument()),
                                                  (route) => false);
                                            },
                                            child: Center(
                                              child: Text(
                                                "Add files",
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
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: details.length,
                                  itemBuilder: (context, index) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      setState(() {});
                                      return PdfDocumentLoader.openFile(
                                        details[index][0].path,
                                        documentBuilder:
                                            (context, pdfDocument, pageCount) {
                                          print(details[index]);
                                          print(details[index][0].path);
                                          if (pdfDocument != null) {
                                            try {
                                              details[index][6] = pageCount;
                                            } catch (e) {
                                              details[index].add(pageCount);
                                              print(e);
                                            }
                                            print("colorprint-$colorPrint");
                                            details[index][4] = details[index]
                                                    [1] *
                                                ((pageCount *
                                                        (details[index][2]
                                                            ? colorPrint
                                                            : bwPrint)) +
                                                    (details[index][3] == 0
                                                        ? spiralBinding
                                                        : details[index][3] == 1
                                                            ? thermalBinding
                                                            : 0));
                                            // cost = cost + details[index][7];
                                            // print(cost);
                                            print(details[index]);
                                            // setState(() {
                                            //   details[index][5] = details[index][1]*((pageCount * (details[index][2]? 5 : 2) ) + (details[index][3]==0? 30 : details[index][3]==1? 50 : 0));
                                            // });
                                            print(pdfDocument.pageCount);
                                          } else {
                                            print("null");
                                          }
                                          return StreamBuilder<
                                                  DocumentSnapshot<Map>>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('options')
                                                  .doc('printing_options')
                                                  .snapshots(),
                                              builder: (context, options) {
                                                return SingleChildScrollView(
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: width * 0.9,
                                                        // height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0x3f000000),
                                                              blurRadius: 9,
                                                              offset:
                                                                  Offset(0, 0),
                                                            ),
                                                          ],
                                                          color: Colors.white,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              // height: width * 0.25,
                                                              width:
                                                                  width * 0.25,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            7),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            7),
                                                                  ),
                                                                  child:
                                                                      PdfPageView(
                                                                    pageNumber:
                                                                        1,
                                                                  )),
                                                            ),
                                                            Container(
                                                              width:
                                                                  width * 0.6,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.45,
                                                                        child:
                                                                            Text(
                                                                          details[index][0]
                                                                              .toString()
                                                                              .split(
                                                                                  "/")[details[index][0].toString().split("/").length -
                                                                              1], // pdf name
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            // fontSize:
                                                                            //     width * 0.04,
                                                                            fontFamily:
                                                                                utils.font,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              details.remove(details[index]);
                                                                            });
                                                                            set();
                                                                            print("deleted");
                                                                            print(details);
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.delete_outline_rounded,
                                                                            color:
                                                                                Colors.red,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "$pageCount pages, ",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              width * 0.03,
                                                                          fontFamily:
                                                                              utils.font,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        details[index][2]
                                                                            ? "Color"
                                                                            : "B/W",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              width * 0.03,
                                                                          fontFamily:
                                                                              utils.font,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        details[index][3] ==
                                                                                0
                                                                            ? ", Spiral binding"
                                                                            : details[index][3] == 1
                                                                                ? ", Thermal binding"
                                                                                : "",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              width * 0.03,
                                                                          fontFamily:
                                                                              utils.font,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            List
                                                                                data =
                                                                                details[index];
                                                                            print(data);
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return StatefulBuilder(builder: (context, setState) {
                                                                                    return Container(
                                                                                      height: height * 0.8,
                                                                                      width: width * 0.85,
                                                                                      child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(20),
                                                                                          child: Material(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(15.0),
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Align(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          width: 20,
                                                                                                        ),
                                                                                                        Icon(
                                                                                                          Icons.file_present,
                                                                                                          color: utils.majorColor,
                                                                                                          size: 20,
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: 15,
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          width: width * 0.6,
                                                                                                          height: 50,
                                                                                                          child: Text(
                                                                                                            data[0].path.toString().split("/")[data[0].path.toString().split("/").length - 1],
                                                                                                            style: TextStyle(
                                                                                                              color: Colors.black,
                                                                                                              // fontSize: width * 0.05,
                                                                                                              fontFamily: utils.font,
                                                                                                              fontWeight: FontWeight.w600,
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                    child: Container(
                                                                                                      height: height * 0.4,
                                                                                                      width: width * 0.8,
                                                                                                      child: SfPdfViewer.file(data[0]),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    children: [
                                                                                                      SizedBox(
                                                                                                        width: width * 0.8,
                                                                                                        child: Column(
                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                          children: [
                                                                                                            Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  "Quantity",
                                                                                                                  style: TextStyle(
                                                                                                                    color: Color(0xdd000000),
                                                                                                                    fontSize: 14,
                                                                                                                    fontFamily: utils.font,
                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    IconButton(
                                                                                                                      onPressed: () {
                                                                                                                        if (data[1] > 0) {
                                                                                                                          setState(() {
                                                                                                                            data[1] = data[1] - 1;
                                                                                                                            print(data[1]);
                                                                                                                          });
                                                                                                                        }
                                                                                                                      },
                                                                                                                      icon: SvgPicture.asset("assets/images/minus.svg"),
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      "${data[1]}",
                                                                                                                      textAlign: TextAlign.center,
                                                                                                                      style: TextStyle(
                                                                                                                        color: Colors.black,
                                                                                                                        fontSize: 16,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    IconButton(
                                                                                                                      onPressed: () {
                                                                                                                        setState(() {
                                                                                                                          data[1] = data[1] + 1;
                                                                                                                          print(data[1]);
                                                                                                                        });
                                                                                                                      },
                                                                                                                      icon: SvgPicture.asset("assets/images/add.svg"),
                                                                                                                    )
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  "Colour",
                                                                                                                  style: TextStyle(
                                                                                                                    color: Color(0xdd000000),
                                                                                                                    fontSize: 14,
                                                                                                                    fontFamily: utils.font,
                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(height: 20),
                                                                                                                Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                  children: [
                                                                                                                    Text(
                                                                                                                      "No",
                                                                                                                      textAlign: TextAlign.center,
                                                                                                                      style: TextStyle(
                                                                                                                        color: Colors.black,
                                                                                                                        fontSize: 16,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Padding(
                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                      child: GestureDetector(
                                                                                                                        onTap: () {
                                                                                                                          setState(() {
                                                                                                                            data[2] = !data[2];
                                                                                                                          });
                                                                                                                        },
                                                                                                                        child: Container(
                                                                                                                          height: 30,
                                                                                                                          width: 60,
                                                                                                                          child: Stack(
                                                                                                                            alignment: Alignment.center,
                                                                                                                            children: [
                                                                                                                              Positioned(
                                                                                                                                right: 10,
                                                                                                                                child: Container(
                                                                                                                                  width: 34,
                                                                                                                                  height: 20,
                                                                                                                                  decoration: BoxDecoration(
                                                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                                                    color: data[2] ? utils.majorColor : Color(0x1e000000),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              AnimatedPositioned(
                                                                                                                                  right: data[2] ? -0 : 28,
                                                                                                                                  duration: Duration(milliseconds: 100),
                                                                                                                                  child: Container(
                                                                                                                                    width: 25,
                                                                                                                                    height: 25,
                                                                                                                                    decoration: BoxDecoration(
                                                                                                                                      shape: BoxShape.circle,
                                                                                                                                      boxShadow: const [
                                                                                                                                        BoxShadow(
                                                                                                                                          color: Color(0x1e000000),
                                                                                                                                          blurRadius: 5,
                                                                                                                                          offset: Offset(0, 1),
                                                                                                                                        ),
                                                                                                                                        BoxShadow(
                                                                                                                                          color: Color(0x23000000),
                                                                                                                                          blurRadius: 3,
                                                                                                                                          offset: Offset(0, 2),
                                                                                                                                        ),
                                                                                                                                        BoxShadow(
                                                                                                                                          color: Color(0x33000000),
                                                                                                                                          blurRadius: 5,
                                                                                                                                          offset: Offset(0, 3),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                      color: data[2] ? utils.majorColor : Color(0xffbdbdbd),
                                                                                                                                    ),
                                                                                                                                  ))
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      "Yes",
                                                                                                                      textAlign: TextAlign.center,
                                                                                                                      style: TextStyle(
                                                                                                                        color: Colors.black,
                                                                                                                        fontSize: 16,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            // SizedBox(height: 20),
                                                                                                            Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                              children: [
                                                                                                                Text(
                                                                                                                  "One Side / two Side ",
                                                                                                                  style: TextStyle(
                                                                                                                    color: Color(0xdd000000),
                                                                                                                    fontSize: 14,
                                                                                                                    fontFamily: utils.font,
                                                                                                                    fontWeight: FontWeight.w600,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Row(
                                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                                  children: [
                                                                                                                    Text(
                                                                                                                      "One",
                                                                                                                      textAlign: TextAlign.center,
                                                                                                                      style: TextStyle(
                                                                                                                        color: Colors.black,
                                                                                                                        fontSize: 16,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Padding(
                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                      child: GestureDetector(
                                                                                                                        onTap: () {
                                                                                                                          setState(() {
                                                                                                                            data[5] = !data[5];
                                                                                                                          });
                                                                                                                        },
                                                                                                                        child: Container(
                                                                                                                          height: 30,
                                                                                                                          width: 60,
                                                                                                                          child: Stack(
                                                                                                                            alignment: Alignment.center,
                                                                                                                            children: [
                                                                                                                              Positioned(
                                                                                                                                right: 10,
                                                                                                                                child: Container(
                                                                                                                                  width: 34,
                                                                                                                                  height: 20,
                                                                                                                                  decoration: BoxDecoration(
                                                                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                                                                    color: data[5] ? utils.majorColor : Color(0x1e000000),
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              AnimatedPositioned(
                                                                                                                                  right: data[5] ? -0 : 28,
                                                                                                                                  duration: Duration(milliseconds: 100),
                                                                                                                                  child: Container(
                                                                                                                                    width: 25,
                                                                                                                                    height: 25,
                                                                                                                                    decoration: BoxDecoration(
                                                                                                                                      shape: BoxShape.circle,
                                                                                                                                      boxShadow: const [
                                                                                                                                        BoxShadow(
                                                                                                                                          color: Color(0x1e000000),
                                                                                                                                          blurRadius: 5,
                                                                                                                                          offset: Offset(0, 1),
                                                                                                                                        ),
                                                                                                                                        BoxShadow(
                                                                                                                                          color: Color(0x23000000),
                                                                                                                                          blurRadius: 3,
                                                                                                                                          offset: Offset(0, 2),
                                                                                                                                        ),
                                                                                                                                        BoxShadow(
                                                                                                                                          color: Color(0x33000000),
                                                                                                                                          blurRadius: 5,
                                                                                                                                          offset: Offset(0, 3),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                      color: data[5] ? utils.majorColor : Color(0xffbdbdbd),
                                                                                                                                    ),
                                                                                                                                  ))
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    Text(
                                                                                                                      "Two",
                                                                                                                      textAlign: TextAlign.center,
                                                                                                                      style: TextStyle(
                                                                                                                        color: Colors.black,
                                                                                                                        fontSize: 16,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ],
                                                                                                                )
                                                                                                              ],
                                                                                                            )
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                  Align(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    child: Padding(
                                                                                                      padding: const EdgeInsets.only(left: 20),
                                                                                                      child: Text(
                                                                                                        "Binding",
                                                                                                        style: TextStyle(
                                                                                                          color: Color(0xdd000000),
                                                                                                          fontSize: width * 0.05,
                                                                                                          fontFamily: utils.font,
                                                                                                          fontWeight: FontWeight.w700,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets.only(
                                                                                                      left: width * 0.05,
                                                                                                    ),
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            IconButton(
                                                                                                                onPressed: () {
                                                                                                                  if (options.data!['spiral']) {
                                                                                                                    data[3] = 0;
                                                                                                                    setState(() {});
                                                                                                                  }
                                                                                                                },
                                                                                                                icon: Icon(
                                                                                                                  data[3] == 0 ? Icons.check_circle : Icons.circle,
                                                                                                                  color: data[3] == 0 ? utils.majorColor : Colors.grey,
                                                                                                                )),
                                                                                                            Text(
                                                                                                              "Spiral",
                                                                                                              style: TextStyle(
                                                                                                                color: Color(0xff212b36),
                                                                                                                fontSize: 14,
                                                                                                              ),
                                                                                                            )
                                                                                                          ],
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            IconButton(
                                                                                                                onPressed: () {
                                                                                                                  if (options.data!['thermal']) {
                                                                                                                    data[3] = 1;
                                                                                                                    setState(() {});
                                                                                                                  }
                                                                                                                },
                                                                                                                icon: Icon(
                                                                                                                  data[3] == 1 ? Icons.check_circle : Icons.circle,
                                                                                                                  color: data[3] == 1 ? utils.majorColor : Colors.grey,
                                                                                                                )),
                                                                                                            Text(
                                                                                                              "Thermal",
                                                                                                              style: TextStyle(
                                                                                                                color: Color(0xff212b36),
                                                                                                                fontSize: 14,
                                                                                                              ),
                                                                                                            )
                                                                                                          ],
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            IconButton(
                                                                                                                onPressed: () {
                                                                                                                  data[3] = 2;
                                                                                                                  setState(() {});
                                                                                                                },
                                                                                                                icon: Icon(
                                                                                                                  data[3] == 2 ? Icons.check_circle : Icons.circle,
                                                                                                                  color: data[3] == 2 ? utils.majorColor : Colors.grey,
                                                                                                                )),
                                                                                                            Text(
                                                                                                              "Not required",
                                                                                                              style: TextStyle(
                                                                                                                color: Color(0xff212b36),
                                                                                                                fontSize: 14,
                                                                                                              ),
                                                                                                            )
                                                                                                          ],
                                                                                                        )
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  Align(
                                                                                                    alignment: FractionalOffset.bottomCenter,
                                                                                                    child: Container(
                                                                                                      width: width * 0.9,
                                                                                                      height: 36,
                                                                                                      decoration: BoxDecoration(
                                                                                                        borderRadius: BorderRadius.circular(4),
                                                                                                        color: utils.majorColor,
                                                                                                      ),
                                                                                                      child: ClipRRect(
                                                                                                        borderRadius: BorderRadius.circular(4),
                                                                                                        child: MaterialButton(
                                                                                                          onPressed: () {
                                                                                                            print(data);
                                                                                                            setState(() {
                                                                                                              data[4] = (details[index][1] *
                                                                                                                  ((pageCount * (details[index][2] ? colorPrint : bwPrint)) +
                                                                                                                      (details[index][3] == 0
                                                                                                                          ? spiralBinding
                                                                                                                          : details[index][3] == 1
                                                                                                                              ? thermalBinding
                                                                                                                              : 0)));
                                                                                                              details[index] = data;
                                                                                                            });
                                                                                                            print(data);
                                                                                                            print(details[index]);
                                                                                                            Navigator.pop(context);
                                                                                                            set();
                                                                                                          },
                                                                                                          child: Center(
                                                                                                            child: Text(
                                                                                                              "OKAY",
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
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          )),
                                                                                    );
                                                                                  });
                                                                                });
                                                                            print("hello");
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "Change",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xffcc7947),
                                                                              fontSize: width * 0.03,
                                                                              fontFamily: utils.font,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ))
                                                                    ],
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                      "Rs  ${details[index][4]}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            width *
                                                                                0.045,
                                                                        fontFamily:
                                                                            utils.font,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                );
                                              });
                                        },
                                      );
                                    });
                                  }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              !friend
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          friend = true;
                                        });
                                      },
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          friend = false;
                                        });
                                        cost = 0;
                                        set();
                                      },
                                      child: SvgPicture.asset(
                                          "assets/images/mark.svg"),
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "I want to let my friend collect my order.",
                                style: TextStyle(
                                  color: Color(0xdd000000),
                                  fontFamily: utils.font,
                                  fontSize: width * 0.04,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 0.9,
                          child: TextFormField(
                            controller: phonenumber,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: utils.majorColor,
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              labelText: 'Phone number',
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
                          height: 10,
                        ),
                        SizedBox(
                          width: width * 0.9,
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
                              labelText: 'Roll number',
                              labelStyle: TextStyle(
                                color: Color(0xffcc7947),
                                fontSize: width * 0.03,
                              ),
                              hintText: "roll number",
                              hintStyle: TextStyle(
                                color: Color(0x89000000),
                                fontSize: width * 0.03,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                            width: width * 0.9,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: utils.majorColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: MaterialButton(
                                onPressed: () async {
                                  cost = 0;
                                  print('Files');
                                  print(details);
                                  for (int i = 0; i < details.length; i++) {
                                    cost = cost + details[i][4];
                                  }
                                  print(cost);
                                  openCheckout("", cost, "prinlty", "PRINTLY",
                                      "hey", snapShot.data!['api']);
                                },
                                child: Center(
                                  child: Text(
                                    // "PAY ₹ $cost  NOW",
                                    "PAY NOW",
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
                          height: height * 0.04,
                        ),
                      ],
                    ),
                  );
          }),
    );
  }
}
