class ApiResponse {
  final String message;

  ApiResponse({this.message});

  ApiResponse.mock() : message = "Success";

  ApiResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'];
}
