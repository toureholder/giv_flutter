class ApiResponse {
  final String message;

  ApiResponse({this.message});

  ApiResponse.mock() : message = "Success";
}