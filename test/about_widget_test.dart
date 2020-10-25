import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/about/bloc/about_bloc.dart';
import 'package:giv_flutter/features/about/ui/about.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

class MockAboutBloc extends Mock implements AboutBloc {}

main() {
  MockAboutBloc mockAboutBloc;
  Widget testableWidget;

  setUp(() {
    mockAboutBloc = MockAboutBloc();
    testableWidget = TestUtil().makeTestableWidget(
      subject: About(
        bloc: mockAboutBloc,
      ),
      dependencies: [
        Provider<AboutBloc>(
          create: (_) => mockAboutBloc,
        ),
        Provider<Util>(
          create: (_) => MockUtil(),
        ),
      ],
    );
  });

  tearDown(() {
    reset(mockAboutBloc);
  });

  testWidgets('launches URL when tapped', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(AboutTile).first);

    verify(mockAboutBloc.launchURL(any)).called(1);
  });
}
