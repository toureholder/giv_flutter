import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giv_flutter/base/authenticated_state.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/groups/group_detail/bloc/group_detail_bloc.dart';
import 'package:giv_flutter/features/groups/group_detail/ui/group_detail_hero.dart';
import 'package:giv_flutter/features/groups/group_information/bloc/group_information_bloc.dart';
import 'package:giv_flutter/features/groups/group_information/ui/group_information_screen.dart';
import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/features/groups/my_groups/ui/my_groups_screen.dart';
import 'package:giv_flutter/features/listing/bloc/new_listing_bloc.dart';
import 'package:giv_flutter/features/listing/ui/new_listing.dart';
import 'package:giv_flutter/features/product/search_result/ui/search_result.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/data/content_stream_builder.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/alert_dialog_widgets.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/icon_buttons.dart';
import 'package:giv_flutter/util/presentation/product_grid.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';
import 'package:provider/provider.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupDetailBloc bloc;
  final int membershipId;

  const GroupDetailScreen({
    Key key,
    @required this.bloc,
    @required this.membershipId,
  }) : super(key: key);

  @override
  State createState() => AuthenticatedState<GroupDetailScreen>(
        bloc: bloc,
        screenContent: GroupDetailScreenContent(
          bloc: bloc,
          membershipId: membershipId,
        ),
      );
}

class GroupDetailScreenContent extends StatefulWidget {
  final GroupDetailBloc bloc;
  final int membershipId;

  const GroupDetailScreenContent({
    Key key,
    @required this.bloc,
    @required this.membershipId,
  }) : super(key: key);

  @override
  _GroupDetailScreenContentState createState() =>
      _GroupDetailScreenContentState();
}

class _GroupDetailScreenContentState
    extends BaseState<GroupDetailScreenContent> {
  Group _group;
  GroupDetailBloc _bloc;
  double _titleOpacity;
  int _membershipId;
  bool _isProgressDialogVisible = false;

  // Infinite scroll code
  List<Product> _products = [];
  bool _isInfiniteScrollOn;
  int _currentPage;
  ScrollController _scrollController;
  double _loadingWidgetOpacity;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _membershipId = widget.membershipId;
    _getMyMembership();
    _titleOpacity = 0.0;

    _listenToLeaveGroupStream();

    // Infinite scroll code
    _scrollController = ScrollController();
    _enableInfiniteScroll();
    _observeScrolling();
    _fetchProducts();
  }

  _getMyMembership() {
    _group = _bloc.getMembershipById(_membershipId).group;
  }

  @override
  void dispose() {
    // Infinite scroll code
    _scrollController.dispose();
    super.dispose();
  }

  void _listenToLeaveGroupStream() {
    _bloc.leaveGroupStream.listen((httpResponse) {
      if (httpResponse.isLoading) {
        _showProgressDialog();
        return;
      }

      _closeProgressDialog();

      if (httpResponse.status == HttpStatus.ok) {
        _goToMyGroupsReloaded();
        return;
      }

      showGenericErrorDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: _group.name,
        titleOpacity: _titleOpacity,
        actions: _buildActions(context, _group),
      ),
      body: ContentStreamBuilder(
        stream: _bloc.productsStream,
        onHasData: (List<Product> products) {
          if (products == null) {
            return SharedLoadingState();
          }

          final widgets = <Widget>[
            GroupDetailHero(
              group: _group,
              onTap: _navigateToGroupInformationScreen,
            ),
            DefaultVerticalSpacing(),
            GroupDetailDescription(
              description: _group.description,
              onTap: _navigateToGroupInformationScreen,
            ),
            Spacing.vertical(Dimens.grid(4)),
          ];

          // Infinite scroll code
          // Widgets rebuild whenever they want and I don't want to duplicate items
          if (_products.where((it) => it.id == products.first.id).isEmpty)
            _products.addAll(products);

          if (products.length < Config.paginationDefaultPerPage)
            _disableInfiniteScroll();

          // Empty state
          if (_products.length == 0)
            widgets.add(GroupDetailProductsEmptyState());

          // Not empty state
          if (_products.length > 0)
            widgets.addAll([
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: ProductGrid(
                  products: _products,
                  addLinkToUserProfile: false,
                ),
              ),
              Spacing.vertical(Dimens.default_vertical_margin),
              LoadingMore(opacity: _loadingWidgetOpacity),
            ]);

          return ListView(
            children: widgets,
            // Infinite scroll code
            controller: _scrollController,
          );
        },
      ),
      floatingActionButton: GroupDetailFAB(onPressed: _goToPostPage),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<Widget> _buildActions(BuildContext context, Group group) {
    return <Widget>[
      ShareIconButton(onPressed: () {
        _bloc.shareGroup(context, group);
      }),
      MoreIconButton(onPressed: _showMoreActionsBottomSheet)
    ];
  }

  // Infinite scroll code
  _fetchProducts({bool addLoadingState = false}) {
    _currentPage++;
    _bloc.getGroupListings(
      groupId: _group.id,
      page: _currentPage,
      addLoadingState: addLoadingState,
    );
  }

  _disableInfiniteScroll() {
    _isInfiniteScrollOn = false;
    _loadingWidgetOpacity = 0.0;
  }

  _enableInfiniteScroll() {
    _currentPage = 0;
    _isInfiniteScrollOn = true;
    _products.clear();
    _loadingWidgetOpacity = 1.0;
  }

  _observeScrolling() {
    _scrollController.addListener(() {
      final position = _scrollController.position;

      _toggleTitleOpacity(position.pixels);

      if (position.pixels == position.maxScrollExtent && _isInfiniteScrollOn) {
        _fetchProducts();
      }
    });
  }

  _toggleTitleOpacity(double scrollPosition) {
    setState(() {
      _titleOpacity = scrollPosition > GroupDetailHero.HEIGHT ? 1.0 : 0.0;
    });
  }

  _showMoreActionsBottomSheet() {
    final tiles = <Widget>[
      GroupDetailBottomSheetInfoTile(onTap: _navigateToGroupInformationScreen),
      GroupDetailBottomSheetLeaveTile(onTap: _confirmLeave),
    ];

    TiledBottomSheet.show(context,
        tiles: tiles, title: string('shared_title_options'));
  }

  void _navigateToGroupInformationScreen() async {
    await navigation.push(
      Consumer<GroupInformationBloc>(
        builder: (context, bloc, child) => GroupInformationScreen(
          bloc: bloc,
          membershipId: _membershipId,
        ),
      ),
    );

    setState(() {
      _getMyMembership();
    });
  }

  void _confirmLeave() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CustomAlertDialog(
            title: string('leave_group_confirmation_title'),
            content: string('leave_group_confirmation_content'),
            confirmationText: string('leave_group_confirmation_button_text'),
            confirmationTextColor: Colors.red,
            onConfirmationPressed: () {
              navigation.pop();
              _bloc.leaveGroup(membershipId: _membershipId);
            },
          );
        });
  }

  void _showProgressDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return ProgressIndicatorDialog();
        });

    _isProgressDialogVisible = true;
  }

  void _closeProgressDialog() {
    if (_isProgressDialogVisible) {
      navigation.pop();
      _isProgressDialogVisible = false;
    }
  }

  void _goToMyGroupsReloaded() {
    navigation.push(
      Base(),
      hasAnimation: false,
      clearStack: true,
    );
    navigation.push(
      Consumer<MyGroupsBloc>(
        builder: (context, bloc, child) => MyGroupsScreen(
          bloc: bloc,
        ),
      ),
      hasAnimation: false,
    );
  }

  void _goToPostPage() async {
    final result = await navigation.push(
      NewListing(
        bloc: Provider.of<NewListingBloc>(context),
        isPrivateByDefault: true,
      ),
    );

    if (result != null) {
      _enableInfiniteScroll();
      _fetchProducts(addLoadingState: true);
    }
  }
}

class GroupDetailBottomSheetInfoTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const GroupDetailBottomSheetInfoTile({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetTile(
      iconData: Icons.info_outline,
      text: GetLocalizedStringFunction(context)('Informações do grupo'),
      onTap: onTap,
    );
  }
}

class GroupDetailBottomSheetLeaveTile extends StatelessWidget {
  final GestureTapCallback onTap;

  const GroupDetailBottomSheetLeaveTile({Key key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetTile(
      iconData: Icons.directions_run,
      text: GetLocalizedStringFunction(context)('Sair do grupo'),
      onTap: onTap,
    );
  }
}

class GroupDetailDescription extends StatelessWidget {
  final String description;
  final GestureTapCallback onTap;

  const GroupDetailDescription({
    Key key,
    @required this.description,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return description == null
        ? Container()
        : InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.default_horizontal_margin,
              ),
              child: BodyText(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
  }
}

class GroupDetailBottomNavigationBar extends StatelessWidget {
  const GroupDetailBottomNavigationBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primarySwatch: Colors.blue),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Container(),
            title: Text(''),
          ),
        ],
        onTap: (int index) {},
      ),
    );
  }
}

class GroupDetailFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const GroupDetailFAB({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);
    return FloatingActionButton.extended(
      onPressed: onPressed,
      elevation: 100.0,
      icon: Icon(Icons.add),
      label: Text(
        stringFunction('shared_action_create_ad'),
      ),
    );
  }
}

class GroupDetailProductsEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacing.vertical(Dimens.grid(48)),
        Body2Text(
          GetLocalizedStringFunction(context)(
              'group_detail_screen_description_empty_state'),
          color: Colors.grey,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class GroupDetailProductsLoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacing.vertical(Dimens.grid(68)),
        SharedLoadingState(),
      ],
    );
  }
}
