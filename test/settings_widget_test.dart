import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/about/bloc/about_bloc.dart';
import 'package:giv_flutter/features/about/ui/about.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/listing/bloc/my_listings_bloc.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/edit_profile.dart';
import 'package:giv_flutter/features/settings/ui/settings.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'about_tile_widget_test.dart';
import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockSettingsBloc mockSettingsBloc;
  Widget testableWidget;
  TestUtil testUtil;
  MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    testUtil = TestUtil();
    mockNavigatorObserver = MockNavigatorObserver();

    testableWidget = testUtil.makeTestableWidget(
      subject: Settings(
        bloc: mockSettingsBloc,
      ),
      dependencies: [
        Provider<SettingsBloc>(
          create: (_) => mockSettingsBloc,
        ),
        Provider<MyListingsBloc>(
          create: (_) => MockMyListingsBloc(),
        ),
        Provider<AboutBloc>(
          create: (_) => MockAboutBloc(),
        ),
        Provider<HomeBloc>(
          create: (_) => MockHomeBloc(),
        ),
        Provider<LogInBloc>(
          create: (_) => MockLoginBloc(),
        ),
        Provider<Util>(
          create: (_) => MockUtil(),
        ),
      ],
      navigatorObservers: [
        mockNavigatorObserver,
      ],
    );
  });

  group('user is logged in', () {
    setUp(() {
      when(mockSettingsBloc.getUser()).thenReturn(User.fake());
    });

    group('displays corrrect tiles', () {
      testWidgets('displays ProfileTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(ProfileTile), findsOneWidget);
      });

      testWidgets('displays MyListingsTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(MyListingsTile), findsOneWidget);
      });

      testWidgets('displays MyGroupsTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(MyGroupsTile), findsOneWidget);
      });

      testWidgets('displays LogOutTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(LogOutTile), findsOneWidget);
      });

      testWidgets('displays SignInTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(SignInTile), findsNothing);
      });
    });

    testWidgets('navigates to profile widget', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(ProfileTile));

      verify(mockNavigatorObserver.didPush(any, any));

      await tester.pumpAndSettle();

      expect(find.byType(EditProfile), findsOneWidget);

      await tester.tap(find.byType(BackButton));

      await tester.pumpAndSettle();

      expect(find.byType(Settings), findsOneWidget);
    });

    testWidgets('navigates to my listings', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(MyListingsTile));

      verify(mockNavigatorObserver.didPush(any, any));
    });

    group('logging out', () {
      testWidgets('shows logout confirmation dialog',
          (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        await tester.tap(find.byType(LogOutTile));

        await tester.pump(Duration.zero);

        final Finder dialog = find.byType(AlertDialog);
        final Finder content =
            testUtil.findInternationalizedText('logout_confirmation_title');
        expect(find.descendant(of: dialog, matching: content), findsOneWidget);
      });

      testWidgets('logout confirmation dialog can be "cancelled"',
          (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);

        await tester.tap(find.byType(LogOutTile));

        await tester.pump(Duration.zero);

        final Finder dialog = find.byType(AlertDialog);
        final Finder content =
            testUtil.findInternationalizedText('logout_confirmation_title');
        expect(find.descendant(of: dialog, matching: content), findsOneWidget);

        final Finder cancelTextFinder =
            testUtil.findInternationalizedText('shared_action_cancel');

        final Finder cancelButtonFinder = find.ancestor(
            of: cancelTextFinder, matching: find.byType(TextButton));
        expect(cancelButtonFinder, findsOneWidget);

        await tester.tap(cancelButtonFinder);

        await tester.pump(Duration.zero);

        expect(find.byType(AlertDialog), findsNothing);
      });
    });
  });

  group('user is NOT logged in', () {
    setUp(() {
      when(mockSettingsBloc.getUser()).thenReturn(null);
    });

    group('displays corrrect tiles', () {
      testWidgets('displays ProfileTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(ProfileTile), findsNothing);
      });

      testWidgets('displays MyListingsTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(MyListingsTile), findsNothing);
      });

      testWidgets('displays MyGroupsTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(MyGroupsTile), findsNothing);
      });

      testWidgets('displays LogOutTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(LogOutTile), findsNothing);
      });

      testWidgets('displays SignInTile', (WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        expect(find.byType(SignInTile), findsOneWidget);
      });
    });

    testWidgets('navigates to sign in screen', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(SignInTile));

      verify(mockNavigatorObserver.didPush(any, any));

      await tester.pumpAndSettle();

      expect(find.byType(SignIn), findsOneWidget);

      await tester.tap(find.byType(BackButton));

      await tester.pumpAndSettle();

      expect(find.byType(Settings), findsOneWidget);
    });
  });

  testWidgets('navigates to about page', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(AboutTheAppTile));

    verify(mockNavigatorObserver.didPush(any, any));

    await tester.pumpAndSettle();

    expect(find.byType(About), findsOneWidget);
  });

  testWidgets('help tile works', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(HelpTile));
  });
}
