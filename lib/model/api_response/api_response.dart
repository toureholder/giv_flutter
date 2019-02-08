class ApiResponse {
  final String message;

  ApiResponse({this.message});

  ApiResponse.mock() : message = "Success";

  ApiResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'];
}

class ApiModelResponse {
  final int id;

  ApiModelResponse({this.id});

  ApiModelResponse.mock() : id = 1;

  ApiModelResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'];
}
