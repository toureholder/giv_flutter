import 'package:flutter/material.dart';

class ContentStreamBuilder<T> extends StreamBuilder<T> {
  final Function onHasData;
  final Stream<T> stream;
  final BuildContext context;

  ContentStreamBuilder(this.context, {this.stream, this.onHasData}) :
        super(
          stream: stream,
          builder: (context, AsyncSnapshot<T> snapshot) {
            if (snapshot.hasData) {
              return onHasData(context, snapshot.data);
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        );
}
