class ApiResponse {
  final String message;

  ApiResponse({this.message});

  ApiResponse.fake() : message = "Success";

  ApiResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'];
}

class ApiModelResponse {
  final int id;

  ApiModelResponse({this.id});

  ApiModelResponse.fake() : id = 1;

  ApiModelResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'];
}
