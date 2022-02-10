import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/force_update/bloc/force_update_bloc.dart';
import 'package:giv_flutter/features/force_update/ui/force_update.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockForceUpdateBloc mockForceUpdateBloc;
  Widget testableWidget;

  setUp(() {
    mockForceUpdateBloc = MockForceUpdateBloc();

    testableWidget = TestUtil().makeTestableWidget(
      subject: ForceUpdate(
        bloc: mockForceUpdateBloc,
      ),
      dependencies: [
        Provider<ForceUpdateBloc>(
          create: (_) => mockForceUpdateBloc,
        ),
        Provider<Util>(
          create: (_) => MockUtil(),
        ),
      ],
    );
  });

  tearDown(() {
    reset(mockForceUpdateBloc);
  });

  testWidgets('launches url', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(
      find.byType(PrimaryButton),
      warnIfMissed: false,
    );

    verify(mockForceUpdateBloc.launchURL(any)).called(1);
  });
}
