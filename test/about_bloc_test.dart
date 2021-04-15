import 'package:giv_flutter/features/about/bloc/about_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  AboutBloc aboutBloc;
  MockUtil mockUtil;
  String versionName = '1.2.3';

  setUp(() {
    mockUtil = MockUtil();
    aboutBloc = AboutBloc(
      util: mockUtil,
      versionName: versionName,
    );
  });

  tearDown(() {
    reset(mockUtil);
  });

  group('#launchURL', () {
    test('launches URL', () {
      final url = 'https://www.google.com';
      aboutBloc.launchURL(url);
      verify(mockUtil.launchURL(url)).called(1);
    });
  });
}
