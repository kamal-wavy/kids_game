import 'package:flutter/material.dart';
import 'package:KidsPlan/custom/text_style.dart';

class CustomSimpleTextField extends StatefulWidget {
  String hintText;
  final TextAlign? textAlign;
  final Color? hintColor;
  final double? textSize;
  final String? fontfamily;
  final bool? textSizeValue;
  final bool underLineValue;
  final bool borderLineValue;
  final bool letterpsacingValue;

  CustomSimpleTextField({
    Key? key,
    required this.hintText,
    this.hintColor,
    this.textSize,
    this.textAlign,
    this.fontfamily,
    this.textSizeValue = false,
    this.underLineValue = false,
    this.borderLineValue = false,
    this.letterpsacingValue = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomSimpleTextField> {
  @override
  Widget build(BuildContext context) {
    return widget.textSizeValue == false
        ? Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(widget.hintText ?? "fffff",
                textAlign: widget.textAlign ?? TextAlign.start,
                style: AppTextStyles.heading1(
                    borderText: widget.borderLineValue,
                    customFamily: widget.fontfamily ?? FontWeight.bold,
                    textColor: widget.hintColor,
                    size: widget.textSize,
                    decoration: widget.underLineValue == true
                        ? TextDecoration.underline
                        : TextDecoration.none)),
          )
        : Text(widget.hintText ?? "",
            textAlign: widget.textAlign ?? TextAlign.start,
            style: AppTextStyles.heading1(
letterpsacingValue: widget.letterpsacingValue,
                borderText: widget.borderLineValue,
                customFamily: widget.fontfamily ?? FontWeight.bold,
                textColor: widget.hintColor,
                size: widget.textSize));
  }
}
