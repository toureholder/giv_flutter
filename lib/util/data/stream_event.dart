class StreamEvent<T> {
  final StreamEventState state;
  final T data;

  StreamEvent({this.state = StreamEventState.ready, this.data});

  StreamEvent.loading() : state = StreamEventState.loading, data = null;

  bool isLoading() => state == StreamEventState.loading;
}

enum StreamEventState { loading, ready, error, empty }