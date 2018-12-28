import 'package:flutter/material.dart';

class ContentStreamBuilder<T> extends StreamBuilder<T> {
  final Function onHasData;
  final Stream<T> stream;

  ContentStreamBuilder({@required this.stream, @required this.onHasData}) :
        super(
          stream: stream,
          builder: (context, AsyncSnapshot<T> snapshot) {
            if (snapshot.hasData) {
              return onHasData(snapshot.data);
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        );
}
