class FormValidator {
  String userName(String value) {
    String message;
    if (value.trim().isEmpty) message = 'validation_message_name_required';
    return message;
  }

  String email(String value) {
    if (value == null) return null;

    String message;

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value)) message = 'validation_message_email_required';

    return message;
  }

  String password(String value) {
    if (value == null) return null;

    String message;
    if (value.length < 6)
      message = 'validation_message_password_min_length';
    else if (value.trim().isEmpty)
      message = 'validation_message_password_not_only_whitspaces';
    return message;
  }

  String required(String value) {
    String message;
    if (value.trim().isEmpty) message = 'validation_message_required';
    return message;
  }
}
