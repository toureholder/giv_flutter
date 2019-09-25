import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/home/bloc/home_bloc.dart';
import 'package:giv_flutter/features/home/model/home_content.dart';
import 'package:giv_flutter/features/home/ui/home_carousel.dart';
import 'package:giv_flutter/features/log_in/bloc/log_in_bloc.dart';
import 'package:giv_flutter/features/product/detail/bloc/product_detail_bloc.dart';
import 'package:giv_flutter/features/product/detail/ui/product_detail.dart';
import 'package:giv_flutter/features/product/search_result/bloc/search_result_bloc.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:giv_flutter/features/settings/ui/settings.dart';
import 'package:giv_flutter/features/sign_in/ui/sign_in.dart';
import 'package:giv_flutter/features/user_profile/bloc/user_profile_bloc.dart';
import 'package:giv_flutter/features/user_profile/ui/user_profile.dart';
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/presentation/avatar_image.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/rounded_corners.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final HomeListener listener;
  final HomeBloc bloc;

  const Home({
    Key key,
    @required this.bloc,
    @required this.listener,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends BaseState<Home> {
  HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = widget.bloc;
    _homeBloc.fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('home_title'),
        actions: <Widget>[_buildAppBarActionsRow()],
      ),
      body: ContentStreamBuilder(
          stream: _homeBloc.content,
          onHasData: (HomeContent data) {
            return HomeContentListView(children: _buildContent(context, data));
          }),
    );
  }

  Row _buildAppBarActionsRow() {
    final authenticatedUser = _homeBloc.getUser();
    final userWidget = authenticatedUser == null
        ? SignInButton(onPressed: _navigateToSignIn)
        : HomeUserAvatar(
            imageUrl: authenticatedUser.avatarUrl,
            onTap: _navigateToSettings,
          );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        userWidget,
      ],
    );
  }

  List<Widget> _buildContent(BuildContext context, HomeContent content) {
    final categories = content.productCategories;
    final heroItems = content.heroItems;

    var widgets = <Widget>[
      _buildCarouselContainer(heroItems),
      Spacing.vertical(Dimens.grid(15))
    ];

    categories.forEach((category) {
      widgets.add(_buildSectionHeader(context, category));
      widgets.add(_buildItemList(context, category.products, category.id));
    });

    widgets.add(Spacing.vertical(Dimens.default_vertical_margin));

    return widgets;
  }

  Widget _buildItemList(
      BuildContext context, List<Product> products, int categoryId) {
    return Padding(
      padding: EdgeInsets.only(top: Dimens.grid(4), bottom: Dimens.grid(16)),
      child: SizedBox(
        height: Dimens.home_product_image_dimension,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, i) {
            final product = products[i];
            return HomeListItem(
              onTap: () {
                _navigateToProductDetil(product);
              },
              product: product,
              isLastItem: i == products.length - 1,
            );
          },
        ),
      ),
    );
  }

  Container _buildSectionHeader(
      BuildContext context, ProductCategory category) {
    return Container(
      padding:
          EdgeInsets.fromLTRB(Dimens.default_horizontal_margin, 0.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Subtitle(
            category.simpleName,
            weight: SyntheticFontWeight.semiBold,
          ),
          SeeMoreButton(
            onPressed: () {
              category.goToSubCategoryOrResult(navigation);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselContainer(List<CarouselItem> heroItems) {
    final _pageController = PageController();
    return HomeCarousel(
      items: heroItems,
      height: 156.0,
      pageController: _pageController,
      onTap: (CarouselItem item) {
        if (item.actionId != null) {
          widget.listener.invokeActionById(item.actionId);
        }

        if (item.productCategory != null) {
          navigation.push(Consumer<SearchResultBloc>(
            builder: (context, bloc, child) => SearchResult(
              category: item.productCategory,
              bloc: bloc,
            ),
          ));
        } else if (item.user != null) {
          navigation.push(Consumer<UserProfileBloc>(
            builder: (context, bloc, child) => UserProfile(
              user: item.user,
              bloc: bloc,
            ),
          ));
        }
      },
      autoAdvance: true,
      loop: true,
    );
  }

  void _navigateToSignIn() => navigation.push(Consumer<LogInBloc>(
        builder: (context, bloc, child) => SignIn(
          bloc: bloc,
        ),
      ));

  void _navigateToSettings() => navigation.push(Consumer<SettingsBloc>(
        builder: (context, bloc, child) => Settings(
          bloc: bloc,
        ),
      ));

  void _navigateToProductDetil(Product product) =>
      navigation.push(Consumer<ProductDetailBloc>(
        builder: (context, bloc, child) => ProductDetail(
          product: product,
          bloc: bloc,
        ),
      ));
}

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediumFlatPrimaryButton(
      onPressed: onPressed,
      text: GetLocalizedStringFunction(context)('shared_action_sign_in'),
    );
  }
}

class HomeUserAvatar extends StatelessWidget {
  final GestureTapCallback onTap;
  final String imageUrl;

  const HomeUserAvatar({
    Key key,
    @required this.onTap,
    @required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Dimens.default_horizontal_margin),
      child: GestureDetector(
        child: AvatarImage(
          image: CustomImage.Image(url: imageUrl),
        ),
        onTap: onTap,
      ),
    );
  }
}

class HomeContentListView extends StatelessWidget {
  final List<Widget> children;

  const HomeContentListView({
    Key key,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: children,
    );
  }
}

class SeeMoreButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SeeMoreButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmallFlatPrimaryButton(
      onPressed: onPressed,
      text: GetLocalizedStringFunction(context)('common_more'),
    );
  }
}

class HomeListItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final Product product;
  final bool isLastItem;

  const HomeListItem({
    Key key,
    @required this.onTap,
    @required this.product,
    @required this.isLastItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
            left: Dimens.default_horizontal_margin,
            right: isLastItem ? Dimens.default_horizontal_margin : 0.0),
        child: RoundedCorners(
          child: CachedNetworkImage(
            placeholder: (context, url) => RoundedCorners(
              child: Container(
                height: Dimens.home_product_image_dimension,
                width: Dimens.home_product_image_dimension,
                decoration: BoxDecoration(color: Colors.grey[200]),
              ),
            ),
            fit: BoxFit.cover,
            width: Dimens.home_product_image_dimension,
            imageUrl: product.images.first.url,
          ),
        ),
      ),
    );
  }
}

abstract class HomeListener {
  void invokeActionById(String actionId);
}
