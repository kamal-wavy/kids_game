import 'package:flutter/material.dart';
import 'package:KidsPlan/custom/text_style.dart';

import '../color.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? upperText;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final Color? txtColor;
  bool? textValue = false;
  final String? validatorText;
  final Function(String)? onChanged;

  CustomTextField({
    Key? key,
    required this.hintText,
    this.upperText,
    required this.controller,
    this.suffixIcon,
    this.txtColor,
    this.textValue,
    this.validatorText,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17.0, right: 17, top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.upperText ?? "",
            style: AppTextStyles.heading1(
                textColor: widget.txtColor ?? greyColor, size: 15),
          ),
          const SizedBox(
            height: 2,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: greyColor,
                  width: 1.0,
                ),
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                suffixIcon: widget.suffixIcon ?? null,
                hintText: widget.upperText ?? "",
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return widget.validatorText;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
