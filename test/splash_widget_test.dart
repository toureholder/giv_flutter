import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/base/custom_error.dart';
import 'package:giv_flutter/features/force_update/bloc/force_update_bloc.dart';
import 'package:giv_flutter/features/splash/bloc/splash_bloc.dart';
import 'package:giv_flutter/features/splash/ui/splash.dart';
import 'package:giv_flutter/util/presentation/app_icon.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockSplashBloc mockSplashBloc;
  Widget testableWidget;
  TestUtil testUtil;
  MockNavigatorObserver mockNavigatorObserver;
  PublishSubject<bool> tasksSuccessSubject;

  setUp(() {
    testUtil = TestUtil();
    mockSplashBloc = MockSplashBloc();
    mockNavigatorObserver = MockNavigatorObserver();
    tasksSuccessSubject = PublishSubject<bool>();

    testableWidget = testUtil.makeTestableWidget(
      subject: Splash(
        bloc: mockSplashBloc,
      ),
      dependencies: [
        Provider<SplashBloc>(
          builder: (_) => mockSplashBloc,
        ),
        Provider<ForceUpdateBloc>(
          builder: (_) => MockForceUpdateBloc(),
        ),
        Provider<Util>(
          builder: (_) => MockUtil(),
        ),
      ],
      navigatorObservers: [
        mockNavigatorObserver,
      ],
    );

    when(mockSplashBloc.tasksStateStream)
        .thenAnswer((_) => tasksSuccessSubject.stream);
  });

  tearDown((){
    tasksSuccessSubject.close();
  });

  testWidgets('navigates when tasks succeed', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    expect(find.byType(AppIcon), findsOneWidget);

    tasksSuccessSubject.sink.add(true);

    verify(mockNavigatorObserver.didPush(any, any));
  });

  testWidgets('navigates when tasks fail', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    expect(find.byType(AppIcon), findsOneWidget);

    tasksSuccessSubject.sink.addError(CustomError.forceUpdate);

    verify(mockNavigatorObserver.didPush(any, any));
  });

  testWidgets('navigates when tasks fail with force update error', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    expect(find.byType(AppIcon), findsOneWidget);

    tasksSuccessSubject.sink.addError('any other error');

    verify(mockNavigatorObserver.didPush(any, any));
  });
}
