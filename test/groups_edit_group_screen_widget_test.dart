import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/groups/edit_group/ui/edit_group_screen.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/group_updated_action.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  Widget testableWidget;
  TestUtil testUtil;
  MockEditGroupBloc mockBloc;
  PublishSubject<HttpResponse<Group>> groupHttpResponseSubject;
  int fakeGroupId = 234;

  setUp(() {
    testUtil = TestUtil();
    mockBloc = MockEditGroupBloc();
    testableWidget = testUtil.makeTestableWidget(
        subject: EditGroupScreen(
          bloc: mockBloc,
          groupId: fakeGroupId,
        ),
        dependencies: [
          ChangeNotifierProvider<GroupUpdatedAction>(
            builder: (context) => GroupUpdatedAction(),
          ),
          Provider<MockEditGroupBloc>(
            builder: (_) => mockBloc,
          ),
          Provider<LogInBloc>(
            builder: (_) => MockLoginBloc(),
          ),
          Provider<Util>(
            builder: (_) => MockUtil(),
          )
        ]);

    groupHttpResponseSubject = PublishSubject<HttpResponse<Group>>();

    when(mockBloc.groupStream)
        .thenAnswer((_) => groupHttpResponseSubject.stream);

    when(mockBloc.getGroupById(fakeGroupId)).thenReturn(Group.fake());
  });

  tearDown(() {
    groupHttpResponseSubject.close();
  });

  group('ui', () {
    setUp(() {
      when(mockBloc.getUser()).thenReturn(User.fake());
    });

    testWidgets('widget builds', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);
      expect(find.byType(EditGroupScreen), findsOneWidget);
    });

    testWidgets('app bar has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      final finder = find.ancestor(
          of: testUtil.findInternationalizedText('edit_group_screen_title'),
          matching: find.byType(CustomAppBar));

      expect(finder, findsOneWidget);
    });
  });

  group('handles user authentication', () {
    testWidgets('redirects to sign in screen if user is not authenticated',
        (WidgetTester tester) async {
      // Given
      when(mockBloc.getUser()).thenReturn(null);

      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(SignIn), findsOneWidget);
    });

    testWidgets('does not redirect to sign in screen if user is authenticated',
        (WidgetTester tester) async {
      // Given
      when(mockBloc.getUser()).thenReturn(User.fake());

      // When
      await tester.pumpWidget(testableWidget);

      // Then
      expect(find.byType(SignIn), findsNothing);
    });
  });
}
