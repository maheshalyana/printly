import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:printly/utils/utils.dart';


class OrdersTile extends StatefulWidget {
  OrdersTile({
    super.key,
    required this.name,
    required this.copiesCount,
    required this.binding,
    required this.color,
    required this.file,
    required this.price,

  });
  String name;
  String price;
  String copiesCount;
  bool color;
  String binding;
  String file;
  @override
  State<OrdersTile> createState() => _OrdersTileState();
}

class _OrdersTileState extends State<OrdersTile> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width * 0.9,
          // height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      bottomLeft: Radius.circular(7),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: width * 0.45,
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: width * 0.04,
                            fontFamily: utils.font,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "${widget.copiesCount} copies, ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.03,
                            fontFamily: utils.font,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.color ? "Color," : "B/W",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.03,
                            fontFamily: utils.font,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.binding,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.03,
                            fontFamily: utils.font,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Rs ${widget.price}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.045,
                          fontFamily: utils.font,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class OrderTile extends StatefulWidget {
  OrderTile({
    super.key,
    required this.details,
  });
  List details;

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  List details = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    details = widget.details;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return PdfDocumentLoader.openAsset(
      details[0].path,
      documentBuilder: (context, pdfDocument, pageCount) {
        if (pdfDocument != null) {
          print(pdfDocument.pageCount);
        }
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: width * 0.9,
              // height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
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
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          bottomLeft: Radius.circular(7),
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: width * 0.45,
                            child: Text(
                              details[0].toString().split("/")[
                                  details[0].toString().split("/").length - 1],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width * 0.04,
                                fontFamily: utils.font,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "$pageCount pages, ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width * 0.03,
                                fontFamily: utils.font,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              details[2] ? "Color," : "B/W",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width * 0.03,
                                fontFamily: utils.font,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              details[3] == 0
                                  ? " Spiral binding"
                                  : details[3] == 1
                                      ? " Thermal binding"
                                      : "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: width * 0.03,
                                fontFamily: utils.font,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Rs 105.00",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: width * 0.045,
                              fontFamily: utils.font,
                              fontWeight: FontWeight.w800,
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
    ;
  }
}
