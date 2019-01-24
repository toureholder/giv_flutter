import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/util/presentation/buttons.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class EditDescription extends StatefulWidget {
  final String description;

  const EditDescription({Key key, this.description}) : super(key: key);

  @override
  _EditDescriptionState createState() => _EditDescriptionState();
}

class _EditDescriptionState extends BaseState<EditDescription> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.description == null
        ? TextEditingController()
        : TextEditingController.fromValue(
            new TextEditingValue(text: widget.description));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('new_listing_tile_description'),
      ),
      body: _buildSingleChildScrollView(),
    );
  }

  SingleChildScrollView _buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Dimens.default_horizontal_margin),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Body2Text(
                string('new_listing_edit_description_hint'),
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

  PrimaryButton _primaryButton() {
    return PrimaryButton(
      text: string('shared_action_save'),
      onPressed: _update,
    );
  }

  void _update() {
    if (_controller.text.isEmpty) return;
    navigation.pop(_controller.text);
  }
}
