import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/features/product/detail/ui/i_want_it_dialog.dart';
import 'package:giv_flutter/features/product/detail/ui/product_detail.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/data/stream_event.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/icon_buttons.dart';
import 'package:giv_flutter/util/presentation/image_carousel.dart';
import 'package:giv_flutter/util/util.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'test_util/mocks.dart';
import 'test_util/test_util.dart';

main() {
  MockProductDetailBloc mockBloc;
  MockNewListingBloc mockNewListingBloc;
  MockNavigatorObserver mockNavigatorObserver;
  MockUtil mockUtil;
  TestUtil testUtil;

  setUp(() {
    testUtil = TestUtil();
    mockNavigatorObserver = MockNavigatorObserver();
    mockUtil = MockUtil();
    mockBloc = MockProductDetailBloc();
    mockNewListingBloc = MockNewListingBloc();
  });

  tearDown(() {
    reset(mockNavigatorObserver);
  });

  Widget makeTestableWidget(Product product) => testUtil.makeTestableWidget(
        subject: ProductDetail(
          bloc: mockBloc,
          product: product,
        ),
        dependencies: [
          Provider<ProductDetailBloc>(
            create: (_) => mockBloc,
          ),
          Provider<NewListingBloc>(
            create: (_) => mockNewListingBloc,
          ),
          Provider<Util>(
            create: (_) => mockUtil,
          ),
        ],
        navigatorObservers: [
          mockNavigatorObserver,
        ],
      );

  Future<void> closeBottomSheet(WidgetTester tester) async {
    await tester.tap(find.byType(MoreIconButton));
    await tester.pump();
  }

  group('shows appropriate widgets if product is mine', () {
    testWidgets('doesn\'t show MoreIconButton if product is not mine',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(false);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);
      expect(find.byType(MoreIconButton), findsNothing);
    });

    testWidgets('shows MoreIconButton if product is mine',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);
      expect(find.byType(MoreIconButton), findsOneWidget);
    });

    testWidgets('shows \'i want it\' button if product is not mine ',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(false);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);

      expect(find.byType(IWantItButton), findsOneWidget);
    });

    testWidgets('doesn\'t show \'i want it\' button if product is mine ',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);

      expect(find.byType(IWantItButton), findsNothing);
    });
  });

  group('shows appropriate widgets if product is mailable', () {
    testWidgets('shows ProductDetailNoShippingAlert if product is not mailable',
        (WidgetTester tester) async {
      final locationSubject = PublishSubject<Location>();

      when(mockBloc.locationStream).thenAnswer((_) => locationSubject.stream);

      final product = Product.fakeNotMailable(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);
      expect(find.byType(ProductDetailNoShippingAlert), findsNothing);

      locationSubject.sink.add(Location.fake());
      await tester.pump(Duration.zero);
      expect(find.byType(ProductDetailNoShippingAlert), findsOneWidget);

      locationSubject.close();
    });

    testWidgets(
        'doesn\'t shows ProductDetailNoShippingAlert if product is mailable',
        (WidgetTester tester) async {
      final locationSubject = PublishSubject<Location>();

      when(mockBloc.locationStream).thenAnswer((_) => locationSubject.stream);

      final product = Product.fakeMailable(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);
      expect(find.byType(ProductDetailNoShippingAlert), findsNothing);

      locationSubject.sink.add(Location.fake());
      await tester.pump(Duration.zero);
      expect(find.byType(ProductDetailNoShippingAlert), findsNothing);

      locationSubject.close();
    });
  });

  group('shows loading state appropriately', () {
    testWidgets('doesn\'t show loading state when widget builds',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);
      expect(find.byType(LoadingStateForeground), findsNothing);
    });

    testWidgets('shows loading state when event is added to sink',
        (WidgetTester tester) async {
      final loadingSubject = PublishSubject<StreamEventState>();

      when(mockBloc.loadingStream).thenAnswer((_) => loadingSubject.stream);

      final product = Product.fakeWithImageUrls(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);
      expect(find.byType(LoadingStateForeground), findsNothing);

      loadingSubject.sink.add(StreamEventState.loading);
      await tester.pump(Duration.zero);
      expect(find.byType(LoadingStateForeground), findsOneWidget);

      loadingSubject.sink.add(StreamEventState.ready);
      await tester.pump(Duration.zero);
      expect(find.byType(LoadingStateForeground), findsNothing);

      loadingSubject.close();
    });
  });

  group('shows positioned \'is hidden\' alert appropriately', () {
    testWidgets('doesn\'t show positioned \'is hidden\' if product is active',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);
      expect(find.byType(PositionedIsHiddenAlert), findsNothing);
    });

    testWidgets('shows positioned \'is hidden\' if product is deactivated',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      product.isActive = false;
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);
      expect(find.byType(PositionedIsHiddenAlert), findsOneWidget);
    });
  });

  testWidgets('WIP: pops product when back button is pressed',
      (WidgetTester tester) async {
    final product = Product.fakeWithImageUrls(1);
    when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

    final testableWidget = makeTestableWidget(product);
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(BackIconButton));

//    verify(mockNavigatorObserver.didPop(any, any));
  });

  group('bottom sheet works as expected', () {
    testWidgets('shows bottom sheet when MoreIconButton is pressed',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(MoreIconButton));

      await tester.pump();
      expect(find.byType(BottomSheet), findsOneWidget);

      await closeBottomSheet(tester);

      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets('shows deactivate bottom sheet tile if product is active',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(MoreIconButton));

      await tester.pump();
      expect(find.byType(BottomSheet), findsOneWidget);

      final tile = find.byWidgetPredicate((Widget widget) =>
          widget is BottomSheetTile && widget.iconData == Icons.visibility_off);

      final text =
          testUtil.findInternationalizedText('product_detail_action_hide');

      expect(tile, findsOneWidget);
      expect(text, findsOneWidget);

      await closeBottomSheet(tester);
    });

    testWidgets('shows activate bottom sheet tile if product is active',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);
      product.isActive = false;

      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(MoreIconButton));

      await tester.pump();
      expect(find.byType(BottomSheet), findsOneWidget);

      final tile = find.byWidgetPredicate((Widget widget) =>
          widget is BottomSheetTile && widget.iconData == Icons.visibility);

      final text = testUtil
          .findInternationalizedText('product_detail_action_reactivate');

      expect(tile, findsOneWidget);
      expect(text, findsOneWidget);

      await closeBottomSheet(tester);
    });

    testWidgets('WIP: shows confirmation dialog when activate toggle is tapped',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);

      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);
      when(mockBloc.isAuthenticated()).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(MoreIconButton));

      await tester.pump();
      expect(find.byType(BottomSheet), findsOneWidget);

      await tester.tap(find.byType(ToggleActivationBottomSheetTile));

//      expect(find.byType(AlertDialog), findsOneWidget);
      await closeBottomSheet(tester);
    });

    testWidgets(
        'WIP: navigates to edit listing screen when edit tile is tapped',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);

      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final locationStream = PublishSubject<Location>();
      when(mockBloc.locationStream).thenAnswer((_) => locationStream);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);

      locationStream.sink.add(Location.fake());

      await tester.pumpAndSettle();

      await tester.tap(find.byType(MoreIconButton));

      await tester.pump();
      expect(find.byType(BottomSheet), findsOneWidget);

      await tester.tap(find.byType(EditBottomSheetTile));

      verify(mockNavigatorObserver.didPush(any, any));

//      expect(find.byType(NewListing), findsOneWidget); :(

      await closeBottomSheet(tester);
      await locationStream.close();
    });

    testWidgets('WIP: shows confirmation dialog when delete is tapped',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);

      when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(MoreIconButton));

      await tester.pump();
      expect(find.byType(BottomSheet), findsOneWidget);

      await tester.tap(find.byType(DeleteBottomSheetTile));

//      expect(find.byType(AlertDialog), findsOneWidget); :(

      await closeBottomSheet(tester);
    });
  });

  testWidgets('WIP: navigates to \'photo view page\' when carousel is tapped',
      (WidgetTester tester) async {
    final product = Product.fakeWithImageUrls(1);
    when(mockBloc.isProductMine(product.user.id)).thenReturn(true);

    final testableWidget = makeTestableWidget(product);
    await tester.pumpWidget(testableWidget);

    await tester.tap(find.byType(ImageCarousel));

    verify(mockNavigatorObserver.didPush(any, any));

//    expect(find.byType(PhotoViewPage), findsOneWidget); :(
  });

  group('\'I want it\' dialog', () {
    testWidgets('\'I want it\' button opens dialog',
        (WidgetTester tester) async {
      final product = Product.fakeWithImageUrls(1);

      when(mockBloc.isProductMine(product.user.id)).thenReturn(false);
      when(mockBloc.isAuthenticated()).thenReturn(true);

      final testableWidget = makeTestableWidget(product);
      await tester.pumpWidget(testableWidget);

      await tester.tap(find.byType(IWantItButton));

      await tester.pump();

      expect(find.byType(IWantItDialog), findsOneWidget);
    });
  });
}
