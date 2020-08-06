class CreateGroupRequest {
  final String name;
  final String description;

  CreateGroupRequest({
    this.name,
    this.description,
  });

  Map<String, String> toHttpRequestBody() => {
        'name': name,
        'description': description,
      };

  CreateGroupRequest.fake()
      : name = "Fake group",
        description = "Lorem ipsum dolor";
}
