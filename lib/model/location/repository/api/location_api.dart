import 'dart:convert';

import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_response.dart';

class LocationApi extends BaseApi {
  Future<HttpResponse<List<Country>>> getCountries() async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/countries');

      status = HttpResponse.codeMap[response.statusCode];
      final data = Country.parseList(response.body);

      return HttpResponse<List<Country>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<Country>>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<List<State>>> getStates(String countryId) async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/countries/$countryId/states');

      status = HttpResponse.codeMap[response.statusCode];
      final data = State.parseList(response.body);

      return HttpResponse<List<State>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<State>>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<List<City>>> getCities(
      String countryId, String stateId) async {
    HttpStatus status;
    try {
      final response =
          await get('$baseUrl/countries/$countryId/states/$stateId/cities');

      status = HttpResponse.codeMap[response.statusCode];
      final data = City.parseList(response.body);

      return HttpResponse<List<City>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<City>>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<LocationList>> getLocationList(Location location) async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/locations', params: {
        'country_id': location.country?.id,
        'state_id': location.state?.id
      });

      status = HttpResponse.codeMap[response.statusCode];
      final data = LocationList.fromJson(jsonDecode(response.body));

      return HttpResponse<LocationList>(status: status, data: data);
    } catch (error) {
      return HttpResponse<LocationList>(
          status: status, message: error.toString());
    }
  }

  Future<HttpResponse<Location>> getLocationDetails(Location location) async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/locations/details', params: {
        'country_id': location.country?.id,
        'state_id': location.state?.id,
        'city_id': location.city?.id
      });

      status = HttpResponse.codeMap[response.statusCode];
      final data = Location.fromJson(jsonDecode(response.body));

      return HttpResponse<Location>(status: status, data: data);
    } catch (error) {
      return HttpResponse<Location>(
          status: status, message: error.toString());
    }
  }
}
