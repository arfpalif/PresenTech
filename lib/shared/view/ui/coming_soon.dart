import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: SvgPicture.asset("src/images/ic_signup.svg")),
    );
  }
}
