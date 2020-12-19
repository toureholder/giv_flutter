import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/features/home/model/quick_menu_item.dart';
import 'package:giv_flutter/features/home/ui/home.dart';
import 'package:giv_flutter/features/home/ui/home_carousel.dart';
import 'package:giv_flutter/features/home/ui/home_quick_menu.dart';
import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/model/authenticated_user_updated_action.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/icon_buttons.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockHomeBloc mockHomeBloc;
  MockHomeListener mockHomeListener;
  Widget testableWidget;
  HomeContent fakeHomeContent;
  MockNavigatorObserver mockNavigationObserver;
  MockSearchResultBloc mockSearchResultBloc;
  MockProductDetailBloc mockProductDetailBloc;

  setUp(() {
    mockHomeListener = MockHomeListener();
    mockHomeBloc = MockHomeBloc();
    fakeHomeContent = HomeContent.fake();
    mockNavigationObserver = MockNavigatorObserver();
    mockSearchResultBloc = MockSearchResultBloc();
    mockProductDetailBloc = MockProductDetailBloc();

    testableWidget = TestUtil().makeTestableWidget(
      subject: Home(
        bloc: mockHomeBloc,
        listener: mockHomeListener,
      ),
      dependencies: [
        Provider<HomeBloc>(
          create: (_) => mockHomeBloc,
        ),
        Provider<SearchResultBloc>(
          create: (_) => mockSearchResultBloc,
        ),
        Provider<ProductDetailBloc>(
          create: (_) => mockProductDetailBloc,
        ),
        Provider<Util>(
          create: (_) => MockUtil(),
        ),
        ChangeNotifierProvider<AuthUserUpdatedAction>(
          create: (context) => AuthUserUpdatedAction(),
        ),
      ],
      navigatorObservers: [mockNavigationObserver],
    );
  });

  tearDown(() {
    reset(mockHomeBloc);
  });

  group('loads content correctly', () {
    testWidgets('shows circular progress inidicator while loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      expect(find.byType(SharedLoadingState), findsOneWidget);
      expect(find.byType(SharedErrorState), findsNothing);
      expect(find.byType(HomeContentListView), findsNothing);
    });

    testWidgets('loads content', (WidgetTester tester) async {
      await tester.pumpWidget(testableWidget);

      verify(mockHomeBloc.fetchContent()).called(1);
    });

    testWidgets('shows content when added to stream',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<HomeContent>();

      when(mockHomeBloc.content).thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.add(fakeHomeContent);

      await tester.pump(Duration.zero);

      expect(find.byType(SharedLoadingState), findsNothing);
      expect(find.byType(SharedErrorState), findsNothing);
      expect(find.byType(HomeContentListView), findsWidgets);

      await publishSubject.close();
    });

    testWidgets('shows error state when there is an error',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<HomeContent>();

      when(mockHomeBloc.content).thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.addError('whatever');

      await tester.pump(Duration.zero);

      expect(find.byType(SharedLoadingState), findsNothing);
      expect(find.byType(SharedErrorState), findsWidgets);
      expect(find.byType(HomeContentListView), findsNothing);

      await publishSubject.close();
    });
  });

  group('ui handles user authentication status correctly', () {
    testWidgets('displays login button if user is not authenticated',
        (WidgetTester tester) async {
      when(mockHomeBloc.getUser()).thenReturn(null);

      await tester.pumpWidget(testableWidget);

      expect(find.byType(MenuIconButton), findsOneWidget);
      expect(find.byType(HomeUserAvatar), findsNothing);
    });

    testWidgets('displays user avatar if user is authenticated',
        (WidgetTester tester) async {
      when(mockHomeBloc.getUser()).thenReturn(User.fake());

      await tester.pumpWidget(testableWidget);

      expect(find.byType(HomeUserAvatar), findsOneWidget);
      expect(find.byType(SignInButton), findsNothing);
    });
  });

  group('navigates correctly', () {
    testWidgets('navigates when category \'see more\' button is tapped',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<HomeContent>();

      when(mockHomeBloc.content).thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.add(fakeHomeContent);

      await tester.pump(Duration.zero);

      await tester.tap(find.byType(SeeMoreButton).first);

      verify(mockNavigationObserver.didPush(any, any));

      await publishSubject.close();
    });

    testWidgets('navigates when list item is tapped',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<HomeContent>();

      when(mockHomeBloc.content).thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.add(fakeHomeContent);

      await tester.pump(Duration.zero);

      await tester.tap(find.byType(HomeListItem).first);

      verify(mockNavigationObserver.didPush(any, any));

      await publishSubject.close();
    });
  });

  group('handles carousel taps correctly', () {
    testWidgets('call listener function when action carousel item is tapped',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<HomeContent>();

      when(mockHomeBloc.content).thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.add(HomeContent(
        quickMenuItems: QuickMenuItem.fakeList(),
        productCategories: ProductCategory.fakeListHomeContent(),
        heroItems: CarouselItem.fakeListWithOneAction(),
      ));

      await tester.pump(Duration.zero);

      await tester.tap(find.byType(HomeCarousel));

      verify(mockHomeListener.invokeActionById(any));

      await publishSubject.close();
    });

    testWidgets('navigates when category carousel item is tapped',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<HomeContent>();

      when(mockHomeBloc.content).thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.add(HomeContent(
        quickMenuItems: QuickMenuItem.fakeList(),
        productCategories: ProductCategory.fakeListHomeContent(),
        heroItems: CarouselItem.fakeListWithOneAction(),
      ));

      await tester.pump(Duration.zero);

      await tester.tap(find.byType(HomeCarousel));

      verify(mockNavigationObserver.didPush(any, any));

      await publishSubject.close();
    });

    testWidgets('navigates when user carousel item is tapped',
        (WidgetTester tester) async {
      final publishSubject = PublishSubject<HomeContent>();

      when(mockHomeBloc.content).thenAnswer((_) => publishSubject.stream);

      await tester.pumpWidget(testableWidget);

      publishSubject.sink.add(HomeContent(
        quickMenuItems: QuickMenuItem.fakeList(),
        productCategories: ProductCategory.fakeListHomeContent(),
        heroItems: CarouselItem.fakeListWithOneAction(),
      ));

      await tester.pump(Duration.zero);

      await tester.tap(find.byType(HomeCarousel));

      verify(mockNavigationObserver.didPush(any, any));

      await publishSubject.close();
    });
  });

  group('quick menu tests', () {
    PublishSubject<HomeContent> publishSubject;
    HomeContent fakeHomeContent;

    setUp(() {
      publishSubject = PublishSubject<HomeContent>();
      when(mockHomeBloc.content).thenAnswer((_) => publishSubject.stream);
    });

    testWidgets('should render quick menu items', (WidgetTester tester) async {
      // Given
      final quickMenuItens = QuickMenuItem.fakeList();
      fakeHomeContent = HomeContent(
          productCategories: ProductCategory.fakeListHomeContent(),
          heroItems: CarouselItem.fakeListWithOneUser(),
          quickMenuItems: quickMenuItens);

      // Act / When
      await tester.pumpWidget(testableWidget);
      publishSubject.sink.add(fakeHomeContent);
      await tester.pump();

      // Assert / Then
      expect(
          find.byType(QuickMenuOption), findsNWidgets(quickMenuItens.length));
    });

    tearDown(() {
      publishSubject.close();
    });
  });
}
