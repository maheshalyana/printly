import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printly/screens/userscreens/profile.dart';
import 'package:printly/utils/utils.dart';
import '../../widgets/filetile.dart';
import 'menu.dart';

class OrderRecieved extends StatefulWidget {
  OrderRecieved({super.key, required this.documents});
  List documents;

  @override
  State<OrderRecieved> createState() => _OrderRecievedState();
}

class _OrderRecievedState extends State<OrderRecieved> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height * 0.85,
              width: width * 0.9,
              child: ListView.builder(
                  itemCount: widget.documents.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/print.png'),
                              SizedBox(
                                width: width * 0.9,
                                child: Text(
                                  "We got your following order..!!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff47b357),
                                    fontSize: 35,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: width * 0.8,
                                  child: Text(
                                    "Our Bear is printing your docs...See you at the store on ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).day}/${DateTime.now().month}/${DateTime.now().year}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : OrderTile(
                            details: widget.documents[index - 1],
                          );
                  }),
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
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Profile()),
                          (route) => false);
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
            )),
            SizedBox(
              height: height * 0.04,
            )
          ],
        ),
      ),
    );
  }
}
