import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giv_flutter/base/authenticated_state.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/features/groups/edit_group/bloc/edit_group_bloc.dart';
import 'package:giv_flutter/features/groups/edit_group/ui/edit_group_image_widget.dart';
import 'package:giv_flutter/features/groups/edit_group/ui/edit_group_name_screen.dart';
import 'package:giv_flutter/model/group/group.dart';
import 'package:giv_flutter/model/image/image.dart' as CustomImage;
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:giv_flutter/util/presentation/bottom_sheet.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_divider.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';
import 'package:giv_flutter/util/presentation/edit_information_tile.dart';
import 'package:giv_flutter/util/presentation/section_title.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditGroupScreen extends StatefulWidget {
  final EditGroupBloc bloc;
  final int groupId;

  const EditGroupScreen({
    Key key,
    @required this.bloc,
    @required this.groupId,
  }) : super(key: key);

  @override
  State createState() => AuthenticatedState<EditGroupScreen>(
        bloc: bloc,
        screenContent: EditGroupScreenContent(
          bloc: bloc,
          groupId: groupId,
        ),
      );
}

class EditGroupScreenContent extends StatefulWidget {
  final EditGroupBloc bloc;
  final int groupId;

  const EditGroupScreenContent({
    Key key,
    @required this.bloc,
    @required this.groupId,
  }) : super(key: key);

  @override
  _EditGroupScreenContentState createState() => _EditGroupScreenContentState();
}

class _EditGroupScreenContentState extends BaseState<EditGroupScreenContent> {
  EditGroupBloc _bloc;
  Group _group;
  CustomImage.Image _currentImage;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _getGroup();
  }

  _getGroup() {
    _group = _bloc.getGroupById(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_currentImage == null) {
      final imageUrl = _group.imageUrl ?? _group.randomImageUrl;
      _currentImage = CustomImage.Image(url: imageUrl);
    }

    return CustomScaffold(
        appBar: CustomAppBar(
          title: string('edit_group_screen_title'),
        ),
        body: ListView(
          children: <Widget>[
            StreamBuilder<HttpResponse<Group>>(
              stream: _bloc.groupStream,
              builder: (context, snapshot) {
                var isLoading = snapshot?.data?.isLoading ?? false;
                return EditGroupImageWidget(
                  image: _currentImage,
                  isLoading: isLoading,
                  onFabPressed: () {
                    _showAddImageModal();
                  },
                );
              },
            ),
            SectionTitle(string('edit_group_information_subtitle')),
            EditGroupNameTile(
              value: _group.name,
              onTap: _editGroupName,
            ),
            CustomDivider(),
            EditGroupDescriptionTile(
              value: _group.description,
              onTap: _editGroupDescription,
            ),
            CustomDivider(),
          ],
        ));
  }

  void _editGroupName() async {
    await navigation.push(Consumer<EditGroupBloc>(
      builder: (context, bloc, child) => EditGroupPropertyScreen(
        bloc: bloc,
        groupId: _group.id,
        property: Group.nameKey,
        appBarTitle: string('Edite o nome do grupo'),
        inputHintText: string('Edite o nome do grupo'),
        inputMaxLength: Config.maxLengthGroupName,
      ),
    ));

    _reloadGroup();
  }

  void _editGroupDescription() async {
    await navigation.push(Consumer<EditGroupBloc>(
      builder: (context, bloc, child) => EditGroupPropertyScreen(
        bloc: bloc,
        groupId: _group.id,
        property: Group.descriptionKey,
        appBarTitle: string('Edite a descrição do grupo'),
        inputHintText: string('Edite a descrição do grupo'),
        inputMaxLines: 10,
        keyboardType: TextInputType.multiline,
        inputMaxLength: Config.maxLengthGroupDescription,
      ),
    ));

    _reloadGroup();
  }

  void _reloadGroup() {
    setState(() {
      _getGroup();
    });
  }

  void _showAddImageModal() {
    final tiles = <BottomSheetTile>[
      BottomSheetTile(
          iconData: Icons.photo_camera,
          text: string('image_picker_modal_camera'),
          onTap: () {
            _openCamera();
          }),
      BottomSheetTile(
          iconData: Icons.image,
          text: string('image_picker_modal_gallery'),
          onTap: () {
            _openGallery();
          }),
    ];

    TiledBottomSheet.show(context,
        tiles: tiles, title: string('edit_group_screen_add_image_moda_title'));
  }

  Future _openCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    _cropImage(imageFile);
  }

  Future _openGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    _cropImage(imageFile);
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(
        ratioX: Config.croppedGroupImageRatioX,
        ratioY: Config.croppedGroupImageRatioY,
      ),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: string('image_cropper_toolbar_title'),
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
      ),
      maxWidth: Config.croppedGroupImageMaxHeight,
      maxHeight: Config.croppedGroupImageMaxWidth,
    );

    if (croppedFile == null) return;

    setState(() {
      _currentImage = CustomImage.Image(file: croppedFile);
      _bloc.uploadImage(_group.id, croppedFile);
    });
  }
}

class EditGroupNameTile extends StatelessWidget {
  final String value;
  final GestureTapCallback onTap;

  const EditGroupNameTile({
    Key key,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return EditInformationTile(
      value: value,
      caption: stringFunction(
        'edit_group_name_tile_caption',
      ),
      emptyStateCaption: stringFunction(
        'edit_group_name_tile_empty_state_caption',
      ),
      onTap: onTap,
    );
  }
}

class EditGroupDescriptionTile extends StatelessWidget {
  final String value;
  final GestureTapCallback onTap;

  const EditGroupDescriptionTile({
    Key key,
    @required this.value,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringFunction = GetLocalizedStringFunction(context);

    return EditInformationTile(
      value: value,
      caption: stringFunction(
        'edit_group_description_tile_caption',
      ),
      emptyStateCaption: stringFunction(
        'edit_group_description_tile_empty_state_caption',
      ),
      onTap: onTap,
    );
  }
}
