import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final dynamic fun, col, textColor;
  final String? text;
  final double? width, height;
  const CommonButton(
      {super.key,
      required this.fun,
      this.col,
      this.height,
      this.width,
      this.textColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fun,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            color: Colors.red,
            // gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     // colors: [
            //     //   Color(0xffFE7D57),
            //     //   Color(0xffEB4E4C),
            //     // ],
            //     stops: [
            //       0.0406,
            //       1.1437
            //     ]),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            text!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
