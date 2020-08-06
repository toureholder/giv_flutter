import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class JoinGroupAccessCodeInput extends StatelessWidget {
  final Function onCompleted;

  const JoinGroupAccessCodeInput({Key key, @required this.onCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //JoinGroupAccessCodeInput
    return Center(
      child: SizedBox(
        width: 240,
        child: PinCodeTextField(
          length: 4,
          animationType: AnimationType.none,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.underline,
              activeColor: Theme.of(context).primaryColor,
              activeFillColor: Colors.transparent,
              selectedColor: Colors.grey,
              selectedFillColor: Colors.transparent,
              inactiveColor: Colors.grey[300],
              inactiveFillColor: Colors.transparent,
              fieldHeight: 50,
              fieldWidth: 40),
          animationDuration: Duration(milliseconds: 300),
          enableActiveFill: true,
          controller: TextEditingController(),
          onCompleted: onCompleted,
          onChanged: (value) {
            // no-op
          },
          beforeTextPaste: (text) {
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
        ),
      ),
    );
  }
}
