import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MailboxImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'images/mailbox.svg',
      width: 100.0,
      height: 100.0,
      fit: BoxFit.cover,
    );
  }
}
