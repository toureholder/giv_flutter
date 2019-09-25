import 'package:giv_flutter/features/force_update/bloc/force_update_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  ForceUpdateBloc forceUpdateBloc;
  MockUtil mockUtil;

  setUp(() {
    mockUtil = MockUtil();
    forceUpdateBloc = ForceUpdateBloc(
      util: mockUtil,
    );
  });

  tearDown(() {
    reset(mockUtil);
  });

  test('launches URL', () {
    final url = 'https://www.google.com';
    forceUpdateBloc.launchURL(url);
    verify(mockUtil.launchURL(url)).called(1);
  });
}
