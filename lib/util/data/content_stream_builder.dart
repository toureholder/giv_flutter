import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class ContentStreamBuilder<T> extends StatelessWidget {
  final Function onHasData;
  final Stream<T> stream;
  final Widget loadingState;

  const ContentStreamBuilder({
    Key key,
    @required this.onHasData,
    @required this.stream,
    this.loadingState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
        stream: stream,
        builder: (context, AsyncSnapshot<T> snapshot) {
          if (snapshot.hasData) {
            return onHasData(snapshot.data);
          } else if (snapshot.hasError) {
            return SharedErrorState();
          } else {
            return loadingState ?? SharedLoadingState();
          }
        });
  }
}

class SharedLoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class SharedErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'images/undraw_notify_orange.svg',
            width: 192.0,
            fit: BoxFit.cover,
          ),
          Spacing.vertical(Dimens.default_vertical_margin),
          SizedBox(
            width: 256.0,
            child: Body2Text(
              GetLocalizedStringFunction(context)(
                  'error_network_layer_generic'),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
