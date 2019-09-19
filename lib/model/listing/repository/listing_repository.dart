import 'dart:async';

import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/listing/repository/api/listing_api.dart';
import 'package:giv_flutter/model/listing/repository/api/request/create_listing_request.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:meta/meta.dart';

class ListingRepository {
  final ListingApi listingApi;

  ListingRepository({@required this.listingApi});

  Future<HttpResponse<Product>> create(CreateListingRequest request) =>
      listingApi.create(request);

  Future<HttpResponse<Product>> update(CreateListingRequest request) =>
      listingApi.update(request);

  Future<HttpResponse<Product>> updateActiveStatus(
          UpdateListingActiveStatusRequest request) =>
      listingApi.updateActiveStatus(request);

  Future<HttpResponse<ApiModelResponse>> destroy(int id) =>
      listingApi.destroy(id);
}
