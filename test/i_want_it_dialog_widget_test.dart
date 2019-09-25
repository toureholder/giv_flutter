import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/product/detail/ui/i_want_it_dialog.dart';
import 'package:giv_flutter/util/presentation/termos_of_service_acceptance_caption.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockUtil mockUtil;
  TestUtil testUtil;
  String message = 'Some message';
  String phoneNumber = '55619123123123';

  setUp(() {
    testUtil = TestUtil();
    mockUtil = MockUtil();
  });

  Widget makeTestableWidget({bool isAuthenticated = true}) =>
      testUtil.makeTestableWidget(
        subject: IWantItDialog(
          util: mockUtil,
          message: message,
          phoneNumber: phoneNumber,
          isAuthenticated: isAuthenticated,
        ),
        dependencies: [
          Provider<Util>(
            builder: (_) => mockUtil,
          ),
        ],
      );

  testWidgets('doesn\'t show TOS if user is logged in',
      (WidgetTester tester) async {
    final testableWidget = makeTestableWidget(isAuthenticated: true);
    await tester.pumpWidget(testableWidget);
    expect(find.byType(TermsOfServiceAcceptanceCaption), findsNothing);
  });

  testWidgets('shows TOS if user is not logged in',
      (WidgetTester tester) async {
    final testableWidget = makeTestableWidget(isAuthenticated: false);
    await tester.pumpWidget(testableWidget);
    expect(find.byType(TermsOfServiceAcceptanceCaption), findsOneWidget);
  });

  testWidgets('starts WhatsApp', (WidgetTester tester) async {
    final testableWidget = makeTestableWidget(isAuthenticated: false);
    await tester.pumpWidget(testableWidget);
    await tester.tap(find.byType(StartWhatsAppTile));
    verify(mockUtil.openWhatsApp(phoneNumber, message)).called(1);
  });

  testWidgets('starts phone app', (WidgetTester tester) async {
    final testableWidget = makeTestableWidget(isAuthenticated: false);
    await tester.pumpWidget(testableWidget);
    await tester.tap(find.byType(StartPhoneAppTile));
    verify(mockUtil.openPhoneApp(phoneNumber)).called(1);
  });
}
