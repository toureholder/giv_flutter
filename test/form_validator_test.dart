import 'package:giv_flutter/util/form/form_validator.dart';
import 'package:test/test.dart';

main() {
  FormValidator formValidator;

  setUp(() {
    formValidator = FormValidator();
  });

  test('returns error message if user name is empty', () {
    final message = formValidator.userName('');
    expect(message, 'validation_message_name_required');
  });

  test('returns error message if email is not valid', () {
    final message = formValidator.email('invalid email');
    expect(message, 'validation_message_email_required');
  });

  test('returns error message if email is empty', () {
    final message = formValidator.email('');
    expect(message, 'validation_message_email_required');
  });

  test('returns error message if password is too short', () {
    final message = formValidator.password('123');
    expect(message, 'validation_message_password_min_length');
  });

  test('returns error message if password is empty', () {
    final message = formValidator.password('');
    expect(message, 'validation_message_password_min_length');
  });

  test('returns error message if password only has spaces', () {
    final message = formValidator.password('             ');
    expect(message, 'validation_message_password_not_only_whitspaces');
  });

  test('returns error message if requried field is empty', () {
    final message = formValidator.required('');
    expect(message, 'validation_message_required');
  });
}
