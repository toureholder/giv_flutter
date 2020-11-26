import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/util/form/text_editing_controller_builder.dart';
import 'package:giv_flutter/util/presentation/android_theme.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/get_listing_type_color.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditDescription extends StatefulWidget {
  final String description;
  final ListingType listingType;

  const EditDescription({
    Key key,
    this.description,
    @required this.listingType,
  }) : super(key: key);

  @override
  _EditDescriptionState createState() => _EditDescriptionState();
}

class _EditDescriptionState extends BaseState<EditDescription> {
  ListingType _listingType;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _listingType = widget.listingType;

    _controller = TextEditingControllerBuilder()
        .setInitialText(widget.description)
        .build();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('new_listing_tile_description'),
      ),
      body: AndroidTheme(
        child: _buildSingleChildScrollView(),
        primaryColor: getListingTypeColor(
          Theme.of(context),
          _listingType,
        ),
      ),
    );
  }

  SingleChildScrollView _buildSingleChildScrollView() {
    final listingTypeHintMap = <ListingType, String>{
      ListingType.donation: 'new_listing_edit_description_hint',
      ListingType.donationRequest:
          'new_donation_request_listing_edit_description_hint',
    };

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Body2Text(
                string(listingTypeHintMap[_listingType]),
                color: Colors.grey,
              ),
              Spacing.vertical(Dimens.default_vertical_margin),
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: string('new_listing_tile_description')),
                maxLength: Config.maxLengthProductDescription,
                autofocus: true,
              ),
              Spacing.vertical(Dimens.default_vertical_margin),
              _primaryButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryButton() {
    final map = <ListingType, Widget>{
      ListingType.donation: PrimaryButton(
        text: string('shared_action_save'),
        onPressed: _update,
      ),
      ListingType.donationRequest: AccentButton(
        text: string('shared_action_save'),
        onPressed: _update,
      ),
    };

    return map[_listingType];
  }

  void _update() {
    if (_controller.text.isEmpty) return;
    navigation.pop(_controller.text);
  }
}
