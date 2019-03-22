import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giv_flutter/config/i18n/string_localizations.dart';
import 'package:giv_flutter/util/presentation/spacing.dart';
import 'package:giv_flutter/util/presentation/typography.dart';
import 'package:giv_flutter/values/dimens.dart';

class ContentStreamBuilder<T> extends StreamBuilder<T> {
  final Function onHasData;
  final Stream<T> stream;

  ContentStreamBuilder({@required this.stream, @required this.onHasData})
      : super(
            stream: stream,
            builder: (context, AsyncSnapshot<T> snapshot) {
              final string = GetLocalizedStringFunction(context);
              if (snapshot.hasData) {
                return onHasData(snapshot.data);
              } else if (snapshot.hasError) {
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
                            string('error_network_layer_generic'),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
}
