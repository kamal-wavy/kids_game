import 'package:flutter/material.dart';

import '../color.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final bool? sufficIconValue;
  final bool? removeBackValue;
  final bool? miniButton;

  final Image? image;

  CustomButton(
      {required this.text,
      required this.onPressed,
      this.color,
      this.textColor,
      this.sufficIconValue = false,
      this.removeBackValue = false,
      this.miniButton = false,
      this.image});

  @override
  Widget build(BuildContext context) {
    return miniButton == false
        ? Padding(
            padding: EdgeInsets.only(top: removeBackValue == false ? 30 : 10),
            child: GestureDetector(
                onTap: onPressed,
                child: removeBackValue == false
                    ? Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: appColor),
                          borderRadius: BorderRadius.circular(15),
                          color: sufficIconValue == false
                              ? color ?? appColor
                              : Colors.white,
                        ),
                        child: sufficIconValue == false
                            ? Center(
                                child: Text(
                                text,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "welcomeWMD"),
                              ))
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  image ??
                                      Icon(
                                        Icons.sports_soccer,
                                        color: Colors.white,
                                      ),
                                  Text(
                                    text,
                                    style: TextStyle(
                                        color: sufficIconValue == true
                                            ? appColor
                                            : Colors.white,
                                        fontSize: 18,
                                        fontFamily: "welcomeWMD"),
                                  ),
                                  Text('')
                                ],
                              ))
                    : Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: appContainerBackColor,
                        ),
                        child: sufficIconValue == false
                            ? Center(
                                child: Text(
                                text,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "welcomeWMD"),
                              ))
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  image ??
                                      Icon(
                                        Icons.sports_soccer,
                                        color: Colors.white,
                                      ),
                                  Text(
                                    text,
                                    style: TextStyle(
                                        color: sufficIconValue == true
                                            ? appColor
                                            : Colors.white,
                                        fontSize: 18,
                                        fontFamily: "welcomeWMD"),
                                  ),
                                  Text('')
                                ],
                              ))),
          )
        : GestureDetector(
            onTap: onPressed,
            child: Container(
                height: 35,
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: appColor),
                  borderRadius: BorderRadius.circular(10),
                  color: sufficIconValue == false
                      ? color ?? appColor
                      : Colors.white,
                ),
                child: sufficIconValue == false
                    ? Center(
                        child: Text(
                        text,
                        style:  TextStyle(
                            color:textColor??Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "welcomeWMD"),
                      ))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          image ??
                              Icon(
                                Icons.sports_soccer,
                                color: Colors.white,
                              ),
                          Text(
                            text,
                            style: TextStyle(
                                color: sufficIconValue == true
                                    ? appColor
                                    : Colors.white,
                                fontSize: 18,
                                fontFamily: "welcomeWMD"),
                          ),
                          Text('')
                        ],
                      )));
  }
}
