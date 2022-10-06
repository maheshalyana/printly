import 'dart:async';
import 'package:flutter/material.dart';
import 'package:printly/utils/utils.dart';

class SubmitButton extends StatefulWidget {
  SubmitButton({Key? key, required this.name}) : super(key: key);
  String name;
  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  double size1 = 20;
  double size2 = 10;
  @override
  void initState() {
    Timer(Duration(milliseconds: 10), () {
      setState(() {
        size1 = 50;
        size2 = 50;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      width: width * 0.75,
      height: 36,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 5),
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(4),
        color: utils.majorColor,
      ),
      duration: Duration(milliseconds: 1500),
      child: ClipRRect(
        child: Stack(children: [
          Positioned(
              top: -12,
              left: -10,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                height: size2,
                width: size2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xffb26536),
                    width: 1,
                  ),
                ),
              )),
          Positioned(
              top: -25,
              right: 10,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                height: size2,
                width: size2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xffb26536),
                    width: 1,
                  ),
                ),
              )),
          Positioned(
              bottom: -25,
              right: -5,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                height: size1,
                width: size1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffb26435),
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: Text(
              "${widget.name}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: utils.font,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
