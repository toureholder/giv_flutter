import 'package:giv_flutter/features/about/bloc/about_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  AboutBloc aboutBloc;
  MockUtil mockUtil;

  setUp(() {
    mockUtil = MockUtil();
    aboutBloc = AboutBloc(
      util: mockUtil,
    );
  });

  tearDown(() {
    reset(mockUtil);
  });

  test('launches URL', () {
    final url = 'https://www.google.com';
    aboutBloc.launchURL(url);
    verify(mockUtil.launchURL(url)).called(1);
  });
}
