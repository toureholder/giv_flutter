class StreamEvent<T> {
  final StreamEventState state;
  final T data;

  StreamEvent({this.state = StreamEventState.ready, this.data});

  StreamEvent.loading() : state = StreamEventState.loading, data = null;
  StreamEvent.error() : state = StreamEventState.error, data = null;

  bool get isError => state == StreamEventState.error;
  bool get isLoading => state == StreamEventState.loading;
  bool get isReady => state == StreamEventState.ready;
}

enum StreamEventState { loading, ready, error, empty }