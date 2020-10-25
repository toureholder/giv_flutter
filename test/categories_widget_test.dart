import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/product/categories/bloc/categories_bloc.dart';
import 'package:giv_flutter/features/product/categories/ui/categories.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockCategoriesBloc mockCategoriesBloc;
  TestUtil testUtil;

  setUp(() {
    testUtil = TestUtil();
    mockCategoriesBloc = MockCategoriesBloc();
  });

  tearDown(() {
    reset(mockCategoriesBloc);
  });

  Widget makeTestableWidget({
    bool showSearch = true,
    bool returnChoice = false,
    List<int> hideThese,
    bool fetchAll = false,
  }) =>
      testUtil.makeTestableWidget(
        subject: Categories(
          bloc: mockCategoriesBloc,
          showSearch: showSearch,
          returnChoice: returnChoice,
          hideThese: hideThese,
          fetchAll: fetchAll,
        ),
        dependencies: [
          Provider<CategoriesBloc>(
            create: (_) => mockCategoriesBloc,
          ),
          Provider<Util>(
            create: (_) => MockUtil(),
          ),
        ],
      );

  group('loads content correctly', () {
    testWidgets(
      'shows circular progress inidicator while loading',
      (WidgetTester tester) async {
        await tester.pumpWidget(makeTestableWidget(hideThese: [1]));
        expect(find.byType(SharedLoadingState), findsOneWidget);
        expect(find.byType(SharedErrorState), findsNothing);
      },
    );
  });
}
