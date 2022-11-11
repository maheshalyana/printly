import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      String name, String key) async {
    print("cost");
    print(amount);
    var options = {
      'key': "rzp_live_a4PzMufSL9ChFW",
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
      cost =0;
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
    print(response.paymentId);
    print(response.orderId);
    print(response.signature);

    SharedPreferences pref =
        await SharedPreferences.getInstance();
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
        "file": imageUrl,
        "fileName": details[0][0].toString().split("/")[
            details[0].toString().split("/").length -
                1],
        "copiesCount": details[i][1],
        "color": details[i][2],
        "binding": details[i][3] == 0
            ? " Spiral binding"
            : details[i][3] == 1
                ? " Thermal binding"
                : "No binding",
        "price": details[i][4],
        "twoSide": details[i][5],
        "friend": friend,
        "number": friend ? phonenumber.text : number,
        "rollNumber":
            friend ? rollnumber.text : rollNumber,
      }).then((value) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderRecieved(documents: details)),
            (route) => false);
      });
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
      body: GestureDetector(
        onTap: () {},
        child: ListView(
          children: [
            Container(
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
                                    borderRadius: BorderRadius.circular(4),
                                    color: utils.majorColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
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
                                        details[index][7] = details[index][1] *
                                            ((pageCount *
                                                    (details[index][2]
                                                        ? 5
                                                        : 2)) +
                                                (details[index][3] == 0
                                                    ? 30
                                                    : details[index][3] == 1
                                                        ? 50
                                                        : 0));
                                      } catch (e) {
                                        print(e);
                                        details[index].add(pageCount);
                                        details[index].add(details[index][1] *
                                            ((pageCount *
                                                    (details[index][2]
                                                        ? 5
                                                        : 2)) +
                                                (details[index][3] == 0
                                                    ? 30
                                                    : details[index][3] == 1
                                                        ? 50
                                                        : 0)));

                                        // setState((){
                                        // });
                                      }
                                      cost = cost + details[index][7];
                                      print(cost);
                                      print(details[index]);
                                      // setState(() {
                                      //   details[index][5] = details[index][1]*((pageCount * (details[index][2]? 5 : 2) ) + (details[index][3]==0? 30 : details[index][3]==1? 50 : 0));
                                      // });
                                      print(pdfDocument.pageCount);
                                    } else {
                                      print("null");
                                    }
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: width * 0.9,
                                          // height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x3f000000),
                                                blurRadius: 9,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                // height: width * 0.25,
                                                width: width * 0.25,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(7),
                                                      bottomLeft:
                                                          Radius.circular(7),
                                                    ),
                                                    child: PdfPageView(
                                                      pageNumber: 1,
                                                    )),
                                              ),
                                              Container(
                                                width: width * 0.6,
                                                padding: EdgeInsets.all(2),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.45,
                                                          child: Text(
                                                            details[index][0]
                                                                .toString()
                                                                .split(
                                                                    "/")[details[
                                                                        index][0]
                                                                    .toString()
                                                                    .split("/")
                                                                    .length -
                                                                1], // pdf name
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize:
                                                              //     width * 0.04,
                                                              fontFamily:
                                                                  utils.font,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                details.remove(
                                                                    details[
                                                                        index]);
                                                              });
                                                              set();
                                                              print("deleted");
                                                              print(details);

                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .delete_outline_rounded,
                                                              color: Colors.red,
                                                            ))
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "$pageCount pages, ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
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
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.03,
                                                            fontFamily:
                                                                utils.font,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          details[index][3] == 0
                                                              ? ", Spiral binding"
                                                              : details[index]
                                                                          [3] ==
                                                                      1
                                                                  ? ", Thermal binding"
                                                                  : "",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * 0.03,
                                                            fontFamily:
                                                                utils.font,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              List data =
                                                                  details[
                                                                      index];
                                                              print(data);
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return StatefulBuilder(builder:
                                                                        (context,
                                                                            setState) {
                                                                      return Container(
                                                                        height: height *
                                                                            0.8,
                                                                        width: width *
                                                                            0.85,
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
                                                                                            child: Text(
                                                                                              data[0].path.toString().split("/")[data[0].path.toString().split("/").length - 1],
                                                                                              style: TextStyle(
                                                                                                color: Colors.black,
                                                                                                fontSize: width * 0.05,
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
                                                                                                      FlutterSwitch(
                                                                                                        width: 40,
                                                                                                        height: 30,
                                                                                                        activeColor: utils.majorColor,
                                                                                                        value: data[2],
                                                                                                        onToggle: (val) {
                                                                                                          setState(() {
                                                                                                            data[2] = !data[2];
                                                                                                          });
                                                                                                        },
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
                                                                                              SizedBox(height: 20),
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
                                                                                                      FlutterSwitch(
                                                                                                        width: 40,
                                                                                                        height: 30,
                                                                                                        activeColor: utils.majorColor,
                                                                                                        value: data[5],
                                                                                                        onToggle: (val) {
                                                                                                          setState(() {
                                                                                                            data[5] = val;
                                                                                                          });
                                                                                                        },
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
                                                                                                    data[3] = 0;
                                                                                                    setState(() {});
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
                                                                                                    data[3] = 1;
                                                                                                    setState(() {});
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
                                                                                                data[7] = data[1] *
                                                                                                    ((pageCount * (data[2] ? 5 : 2)) +
                                                                                                        (data[3] == 0
                                                                                                            ? 30
                                                                                                            : data[3] == 1
                                                                                                                ? 50
                                                                                                                : 0));
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
                                                            child: Text(
                                                              "Change",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xffcc7947),
                                                                fontSize:
                                                                    width *
                                                                        0.03,
                                                                fontFamily:
                                                                    utils.font,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        "Rs ${details[index][1] * ((pageCount * (details[index][2] ? 5 : 2)) + (details[index][3] == 0 ? 30 : details[index][3] == 1 ? 50 : 0))}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              width * 0.045,
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
                                        ));
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
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
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
                                child:
                                    SvgPicture.asset("assets/images/mark.svg"),
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
                            for(int i=0;i<details.length;i++){
                              cost = cost  + details[i][7];
                            }
                            print(cost);
                            openCheckout("", cost, "prinlty", "PRINTLY", "hey");

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
            ),
          ],
        ),
      ),
    );
  }
}
