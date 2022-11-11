import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:printly/utils/utils.dart';
import '../../widgets/filetile.dart';
import 'cart.dart';
import 'menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AddDocument extends StatefulWidget {
  AddDocument({super.key});

  @override
  State<AddDocument> createState() => _AddDocumentState();
}

class _AddDocumentState extends State<AddDocument> {
  FilePickerResult? result;
  List<String> fileNames = [];
  List addedFiles = [];
  List selectedFiles = [];

  void pickFile() async {
    try {
      result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: ['pdf']);
      if (result != null) {
        fileNames.add(result!.files.first.name);
        addedFiles.add([
          File(result!.files.first.path.toString()),
          false,
          1,
          true,
          0,
          10,
          false
        ]);
        // [file,seleted,copies,color,binding type(0-Spiral,1-thermal,2-not required),price,TwoSide]
        print(fileNames);
        print(addedFiles);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  void set(){
    setState(() {

    });
  }

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
      body: Container(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              height: height * 0.7,
              width: width * 0.9,
              child: ListView.builder(
                itemCount: addedFiles.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
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
                              color: Color(0xffeeeeee),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: MaterialButton(
                                onPressed: (() {
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
                                  pickFile();
                                  Navigator.pop(context);
                                }),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle,
                                      color: Color(0xff6E6E6E),
                                      size: width * 0.1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "ADD YOUR DOCUMENT",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0x89000000),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select document(s) to proceed",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: "Lato",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return addedFiles[index - 1][1]
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: MaterialButton(
                                onPressed: () {
                                  setState(() {
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
                                    addedFiles[index - 1][1] = false;
                                    // try{
                                    //   selectedFiles.remove([
                                    //     addedFiles[index - 1][0],
                                    //     addedFiles[index - 1][2],
                                    //     addedFiles[index - 1][3],
                                    //     addedFiles[index - 1][4],
                                    //     addedFiles[index - 1][5],
                                    //     addedFiles[index - 1][6],
                                    //   ]);
                                    // }catch(e){
                                    //   print(e);
                                    //   print("No");
                                    // }

                                    set();
                                    print(addedFiles);
                                    print(selectedFiles);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: height * 0.025),
                                    // height: height * 0.1,
                                    width: width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x0c04060f),
                                          blurRadius: 60,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      color: Color(0xffcc7947),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          fileNames[index - 1],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width * 0.05,
                                            fontFamily: "Urbanist",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  List data =
                                                      addedFiles[index - 1];
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Container(
                                                      height: height * 0.8,
                                                      width: width * 0.85,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Material(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Column(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .file_present,
                                                                          color:
                                                                              utils.majorColor,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width * 0.6,
                                                                          child:
                                                                              Text(
                                                                            fileNames[index -
                                                                                1],
                                                                            style:
                                                                                TextStyle(
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
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          height *
                                                                              0.4,
                                                                      width:
                                                                          width *
                                                                              0.8,
                                                                      child: SfPdfViewer
                                                                          .file(
                                                                              data[0]),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.8,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
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
                                                                                        if (data[2] > 0) {
                                                                                          setState(() {
                                                                                            data[2] = data[2] - 1;
                                                                                            print(data[2]);
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      icon: SvgPicture.asset("assets/images/minus.svg"),
                                                                                    ),
                                                                                    Text(
                                                                                      "${data[2]}",
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                    IconButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          data[2] = data[2] + 1;
                                                                                          print(data[2]);
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
                                                                                      value: data[6],
                                                                                      onToggle: (val) {
                                                                                        setState(() {
                                                                                          addedFiles[index - 1][6] = !addedFiles[index - 1][6];
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
                                                                                      value: addedFiles[index - 1][3],
                                                                                      onToggle: (val) {
                                                                                        setState(() {
                                                                                          addedFiles[index - 1][3] = val;
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
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          Text(
                                                                        "Binding",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xdd000000),
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
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: width *
                                                                          0.05,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            IconButton(
                                                                                onPressed: () {
                                                                                  data[4] = 0;
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(
                                                                                  data[4] == 0 ? Icons.check_circle : Icons.circle,
                                                                                  color: data[4] == 0 ? utils.majorColor : Colors.grey,
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
                                                                                  data[4] = 1;
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(
                                                                                  data[4] == 1 ? Icons.check_circle : Icons.circle,
                                                                                  color: data[4] == 1 ? utils.majorColor : Colors.grey,
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
                                                                                  data[4] = 2;
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(
                                                                                  data[4] == 2 ? Icons.check_circle : Icons.circle,
                                                                                  color: data[4] == 2 ? utils.majorColor : Colors.grey,
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
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomCenter,
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          width *
                                                                              0.9,
                                                                      height:
                                                                          36,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        color: utils
                                                                            .majorColor,
                                                                      ),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        child:
                                                                            MaterialButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              addedFiles[index - 1] = data;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
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
                                            "Customise print settings ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * 0.04,
                                              fontFamily: "Urbanist",
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: MaterialButton(
                                onPressed: () {
                                  setState(() {
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
                                    addedFiles[index - 1][1] = true;
                                    // selectedFiles.add([
                                    //   addedFiles[index - 1][0],
                                    //   addedFiles[index - 1][2],
                                    //   addedFiles[index - 1][3],
                                    //   addedFiles[index - 1][4],
                                    //   addedFiles[index - 1][5],
                                    //   addedFiles[index - 1][6],
                                    // ]);
                                    print(selectedFiles);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: height * 0.025),
                                    // height: height * 0.1,
                                    width: width * 0.9,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x0c04060f),
                                          blurRadius: 60,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      color: Color(0xffeeeeee),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          fileNames[index - 1],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: width * 0.05,
                                            fontFamily: "Urbanist",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  List data =
                                                      addedFiles[index - 1];
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Container(
                                                      height: height * 0.8,
                                                      width: width * 0.85,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Material(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      15.0),
                                                              child: Column(
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .file_present,
                                                                          color:
                                                                              utils.majorColor,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              width * 0.6,
                                                                          child:
                                                                              Text(
                                                                            fileNames[index -
                                                                                1],
                                                                            style:
                                                                                TextStyle(
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
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          height *
                                                                              0.4,
                                                                      width:
                                                                          width *
                                                                              0.8,
                                                                      child: SfPdfViewer
                                                                          .file(
                                                                              data[0]),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: width *
                                                                            0.8,
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
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
                                                                                        if (data[2] > 0) {
                                                                                          setState(() {
                                                                                            data[2] = data[2] - 1;
                                                                                            print(data[2]);
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      icon: SvgPicture.asset("assets/images/minus.svg"),
                                                                                    ),
                                                                                    Text(
                                                                                      "${data[2]}",
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 16,
                                                                                      ),
                                                                                    ),
                                                                                    IconButton(
                                                                                      onPressed: () {
                                                                                        setState(() {
                                                                                          data[2] = data[2] + 1;
                                                                                          print(data[2]);
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
                                                                                      value: data[6],
                                                                                      onToggle: (val) {
                                                                                        setState(() {
                                                                                          addedFiles[index - 1][6] = !addedFiles[index - 1][6];
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
                                                                                      value: addedFiles[index - 1][3],
                                                                                      onToggle: (val) {
                                                                                        setState(() {
                                                                                          addedFiles[index - 1][3] = val;
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
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              20),
                                                                      child:
                                                                          Text(
                                                                        "Binding",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xdd000000),
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
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: width *
                                                                          0.05,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            IconButton(
                                                                                onPressed: () {
                                                                                  data[4] = 0;
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(
                                                                                  data[4] == 0 ? Icons.check_circle : Icons.circle,
                                                                                  color: data[4] == 0 ? utils.majorColor : Colors.grey,
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
                                                                                  data[4] = 1;
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(
                                                                                  data[4] == 1 ? Icons.check_circle : Icons.circle,
                                                                                  color: data[4] == 1 ? utils.majorColor : Colors.grey,
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
                                                                                  data[4] = 2;
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(
                                                                                  data[4] == 2 ? Icons.check_circle : Icons.circle,
                                                                                  color: data[4] == 2 ? utils.majorColor : Colors.grey,
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
                                                                    alignment:
                                                                        FractionalOffset
                                                                            .bottomCenter,
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          width *
                                                                              0.9,
                                                                      height:
                                                                          36,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        color: utils
                                                                            .majorColor,
                                                                      ),
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(4),
                                                                        child:
                                                                            MaterialButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              addedFiles[index - 1] = data;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
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
                                            "Customise print settings ",
                                            style: TextStyle(
                                              color: utils.majorColor,
                                              fontSize: width * 0.04,
                                              fontFamily: "Urbanist",
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )));
                  }
                },
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
                    onPressed: () {
                      selectedFiles = [];
                      for(int i=0;i<addedFiles.length;i++){
                       if(addedFiles[i][1]){
                         selectedFiles.add([
                           addedFiles[i][0],
                           addedFiles[i][2],
                           addedFiles[i][3],
                           addedFiles[i][4],
                           addedFiles[i][5],
                           addedFiles[i][6],
                         ]);
                       }
                      }
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen(
                                    documents: selectedFiles,
                                  )),
                          (route) => true);
                    },
                    child: Center(
                      child: Text(
                        "PROCEED",
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
    );
  }
}
