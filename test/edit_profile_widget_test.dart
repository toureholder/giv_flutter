import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/phone_verification/bloc/phone_verification_bloc.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/edit_bio.dart';
import 'package:giv_flutter/features/settings/ui/edit_name.dart';
import 'package:giv_flutter/features/settings/ui/edit_phone_number/edit_phone_number_screen.dart';
import 'package:giv_flutter/features/settings/ui/edit_profile.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockSettingsBloc mockSettingsBloc;
  MockPhoneVerificationBloc mockPhoneVerificationBloc;
  Widget testableWidget;
  TestUtil testUtil;
  MockNavigatorObserver mockNavigatorObserver;
  PublishSubject<HttpResponse<User>> userUpdateSubject;
  PublishSubject<PhoneVerificationStatus> phoneVerificationSubject;

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    mockPhoneVerificationBloc = MockPhoneVerificationBloc();
    testUtil = TestUtil();
    mockNavigatorObserver = MockNavigatorObserver();

    userUpdateSubject = PublishSubject<HttpResponse<User>>();
    phoneVerificationSubject = PublishSubject<PhoneVerificationStatus>();

    testableWidget = testUtil.makeTestableWidget(
      subject: EditProfile(
        settingsBloc: mockSettingsBloc,
      ),
      dependencies: [
        Provider<SettingsBloc>(
          create: (_) => mockSettingsBloc,
        ),
        Provider<PhoneVerificationBloc>(
          create: (_) => mockPhoneVerificationBloc,
        ),
        Provider<Util>(
          create: (_) => MockUtil(),
        ),
      ],
      navigatorObservers: [
        mockNavigatorObserver,
      ],
    );

    when(mockSettingsBloc.getUser()).thenReturn(User.fake());
    when(mockSettingsBloc.userUpdateStream)
        .thenAnswer((_) => userUpdateSubject.stream);

    when(mockPhoneVerificationBloc.verificationStatusStream)
        .thenAnswer((_) => phoneVerificationSubject.stream);
  });

  tearDown(() {
    userUpdateSubject.close();
    phoneVerificationSubject.close();
  });

  Future<void> closeBottomSheet(WidgetTester tester) async {
    await tester.tap(
      find.byType(ProfileAvatarAddImageFab),
      warnIfMissed: false,
    );
    await tester.pump();
  }

  group('avatar tests', () {
    testWidgets('shows add image fab', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(ProfileAvatarUploadingState), findsNothing);
      expect(find.byType(ProfileAvatarAddImageFab), findsOneWidget);
    });

    testWidgets('shows avatar loading state', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      userUpdateSubject.sink.add(HttpResponse.loading());

      await tester.pump();

      expect(find.byType(ProfileAvatarAddImageFab), findsNothing);
      expect(find.byType(ProfileAvatarUploadingState), findsOneWidget);
    });
  });

  group('edits properties', () {
    testWidgets('navigates to edit phone number', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(
        find.byType(PhoneNumberTile),
        warnIfMissed: false,
      );

      verify(mockNavigatorObserver.didPush(any, any));

      await tester.pumpAndSettle();

      expect(find.byType(EditPhoneNumber), findsOneWidget);

      await tester.tap(
        find.byType(BackButton),
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      expect(find.byType(EditPhoneNumber), findsNothing);
      expect(find.byType(EditProfile), findsOneWidget);
    });

    testWidgets('navigates to edit name', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(
        find.byType(NameTile),
        warnIfMissed: false,
      );

      verify(mockNavigatorObserver.didPush(any, any));

      await tester.pumpAndSettle();

      expect(find.byType(EditName), findsOneWidget);

      await tester.tap(
        find.byType(BackButton),
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      expect(find.byType(EditProfile), findsOneWidget);
    });

    testWidgets('navigates to edit bio', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(
        find.byType(BioTile),
        warnIfMissed: false,
      );

      verify(mockNavigatorObserver.didPush(any, any));

      await tester.pumpAndSettle();

      expect(find.byType(EditBio), findsOneWidget);

      await tester.tap(
        find.byType(BackButton),
        warnIfMissed: false,
      );

      await tester.pumpAndSettle();

      expect(find.byType(EditProfile), findsOneWidget);
    });
  });

  testWidgets(
    'shows new image bottom sheet',
    (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      await tester.tap(
        find.byType(ProfileAvatarAddImageFab),
        warnIfMissed: false,
      );

      await tester.pump();
      expect(find.byType(BottomSheet), findsOneWidget);

      await closeBottomSheet(tester);
    },
  );
}
