import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/user_profile/bloc/user_profile_bloc.dart';
import 'package:giv_flutter/features/user_profile/ui/user_profile.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/product_grid.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockUserProfileBloc mockUserProfileBloc;
  MockNavigatorObserver mockNavigationObserver;
  TestUtil testUtil;
  PublishSubject productListSubject;

  setUp(() {
    mockUserProfileBloc = MockUserProfileBloc();
    mockNavigationObserver = MockNavigatorObserver();
    testUtil = TestUtil();
    productListSubject = PublishSubject<List<Product>>();

    when(mockUserProfileBloc.productsStream)
        .thenAnswer((_) => productListSubject.stream);
  });

  tearDown(() {
    productListSubject.close();
  });

  Widget makeTestableWidget(User user) => testUtil.makeTestableWidget(
        subject: UserProfile(
          bloc: mockUserProfileBloc,
          user: user,
        ),
        dependencies: [
          Provider<UserProfileBloc>(
            builder: (_) => mockUserProfileBloc,
          ),
          Provider<Util>(
            builder: (_) => MockUtil(),
          ),
        ],
        navigatorObservers: [mockNavigationObserver],
      );

  group('loads user\'s products', () {
    testWidgets('shows product grid loading state',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(User.fake()));
      expect(find.byType(SharedLoadingState), findsOneWidget);
    });

    testWidgets('shows product grid when user\'s products are loaded',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(User.fake()));

      expect(find.byType(SharedLoadingState), findsOneWidget);

      productListSubject.sink.add(Product.fakeList());

      await tester.pump();

      expect(find.byType(SharedLoadingState), findsNothing);
      expect(find.byType(ProductGrid), findsOneWidget);
    });

    testWidgets('shows empty product grid when user has no products',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(User.fake()));

      expect(find.byType(SharedLoadingState), findsOneWidget);

      productListSubject.sink.add(<Product>[]);

      await tester.pump();

      expect(find.byType(SharedLoadingState), findsNothing);
      expect(find.byType(ProductGrid), findsNothing);
      expect(find.byType(UserProfileEmptyProductGrid), findsOneWidget);
    });
  });

  group('shows user info', () {
    final user = User(
      id: 1,
      name: 'John Brown',
      avatarUrl: 'https://randomuser.me/api/portraits/male/123.jpg',
      phoneNumber: '5561987654321',
      countryCallingCode: '55',
      bio:
          'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      createdAt: DateTime(1982, 9, 7, 17, 30),
    );

    testWidgets('shows user bio', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(user));
      expect(find.text(user.bio), findsOneWidget);
    });
  });
}
