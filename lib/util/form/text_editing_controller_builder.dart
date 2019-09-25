import 'package:flutter/material.dart';

class TextEditingControllerBuilder {
  String initialText;

  TextEditingControllerBuilder setInitialText(String initialText) {
    this.initialText = initialText;
    return this;
  }

  TextEditingController build() => this.initialText == null
      ? TextEditingController()
      : TextEditingController.fromValue(
          TextEditingValue(
            text: this.initialText,
          ),
        );
}
