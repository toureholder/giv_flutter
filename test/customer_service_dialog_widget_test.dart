import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/customer_service/bloc/customer_service_dialog_bloc.dart';
import 'package:giv_flutter/features/customer_service/ui/customer_service_dialog.dart';
import 'package:giv_flutter/util/presentation/alert_dialog_widgets.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

class MockCustomerServiceDialogBloc extends Mock
    implements CustomerServiceDialogBloc {}

main() {
  MockCustomerServiceDialogBloc mockCustomerServiceDialogBloc;
  Widget testableWidget;
  final message = 'Important message. Please read.';

  setUp(() {
    mockCustomerServiceDialogBloc = MockCustomerServiceDialogBloc();
    testableWidget = TestUtil().makeTestableWidget(
      subject: CustomerServiceDialog(
        bloc: mockCustomerServiceDialogBloc,
        message: message,
        showNoMore: false,
      ),
      dependencies: [
        Provider<CustomerServiceDialogBloc>(
          builder: (_) => mockCustomerServiceDialogBloc,
        ),
        Provider<Util>(
          builder: (_) => MockUtil(),
        ),
      ],
    );
  });

  tearDown(() {
    reset(mockCustomerServiceDialogBloc);
  });

  testWidgets('launches customer service', (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(AlertDialogConfirmButton));

    verify(mockCustomerServiceDialogBloc.launchCustomerService(message))
        .called(1);
  });

  testWidgets('does not set \'has agreed\' if user has not checked box',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(AlertDialogConfirmButton));

    verifyNever(mockCustomerServiceDialogBloc.setHasAgreedToCustomerService());
  });

  testWidgets('sets \'has agreed\' if user has checked box',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(AlertDialogCheckBox));

    await tester.pumpAndSettle();

    await tester.tap(find.byType(AlertDialogConfirmButton));

    verify(mockCustomerServiceDialogBloc.setHasAgreedToCustomerService())
        .called(1);
  });

  testWidgets(
      'does not set \'has agreed\' if user has checked and unchecked box',
      (WidgetTester tester) async {
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(AlertDialogCheckBox));

    await tester.pumpAndSettle();

    await tester.tap(find.byType(AlertDialogCheckBox));

    await tester.pumpAndSettle();

    await tester.tap(find.byType(AlertDialogConfirmButton));

    verifyNever(mockCustomerServiceDialogBloc.setHasAgreedToCustomerService());
  });
}
