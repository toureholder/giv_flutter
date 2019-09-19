import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/util/network/base_api.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class CarouselApi extends BaseApi {
  CarouselApi({
    @required http.Client client,
  }) : super(client: client);

  Future<HttpResponse<List<CarouselItem>>> getHomeCarouselItems(
      {Location location}) async {
    HttpStatus status;
    try {
      final response = await get('$baseUrl/home/carousel', params: {
        'city_id': location?.city?.id,
        'state_id': location?.state?.id,
        'country_id': location?.country?.id
      });

      status = HttpResponse.codeMap[response.statusCode];
      final data = CarouselItem.parseList(response.body);

      return HttpResponse<List<CarouselItem>>(status: status, data: data);
    } catch (error) {
      return HttpResponse<List<CarouselItem>>(
          status: status, message: error.toString());
    }
  }
}
