import 'package:giv_flutter/util/data/stream_event.dart';

class HttpResponse<T> extends StreamEvent<T> {
  final StreamEventState state;
  final HttpStatus status;
  final String message;
  final T data;

  HttpResponse({this.state = StreamEventState.ready, this.message, this.data, this.status})
      : super(data: data, state: state);

  factory HttpResponse.loading() =>
      HttpResponse(state: StreamEventState.loading);

  bool get isError => state == StreamEventState.error;
  bool get isLoading => state == StreamEventState.loading;
  bool get isReady => state == StreamEventState.ready;

  static Map<int, HttpStatus> codeMap = {
    200: HttpStatus.ok,
    201: HttpStatus.created,
    400: HttpStatus.badRequest,
    401: HttpStatus.unauthorized,
    403: HttpStatus.forbidden,
    404: HttpStatus.notFound,
    406: HttpStatus.notAcceptable,
    409: HttpStatus.conflict,
    412: HttpStatus.preconditionFailed,
    422: HttpStatus.unprocessableEntity,
    500: HttpStatus.internalServerError
  };
}

enum HttpStatus {
  ok,
  created,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  notAcceptable,
  conflict,
  preconditionFailed,
  unprocessableEntity,
  internalServerError
}
