import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:http/http.dart';

class HttpClientWrapper {
  final Client http;
  final DiskStorageProvider diskStorage;
  final String applicationBuildNumber;

  HttpClientWrapper(
    this.http,
    this.diskStorage,
    this.applicationBuildNumber,
  );
}
