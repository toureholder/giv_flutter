import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:giv_flutter/model/carousel/carousel_item.dart';
import 'package:giv_flutter/model/carousel/repository/api/carousel_api.dart';
import 'package:giv_flutter/util/network/http_client_wrapper.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  HttpClientWrapper client;
  MockHttp mockHttp;
  CarouselApi carouselApi;

  setUp(() {
    mockHttp = MockHttp();
    client = HttpClientWrapper(mockHttp, MockDiskStorageProvider());
    carouselApi = CarouselApi(client: client);
  });

  tearDown((){
    reset(mockHttp);
  });

  test('returns list of CarouselItems data if GET request succeeds', () async {
    final responseBody =
        '[{"image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/marketing%2Fapp-banners%2Flidya-nada-638316-unsplash.jpg?alt=media&token=9e427d12-d581-4043-925a-4fb70451945d","title":"Muitas felicidades por aqui!","caption":"Dê uma pesquisada ;)","action_id":"SEARCH","category":null,"user":null},{"image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/marketing%2Fapp-banners%2Fiam-se7en-657490-unsplash.jpg?alt=media&token=d9358661-f8a4-42e7-8ed6-99a1c088c57d","title":"Melhore seu inglês","caption":"Veja os livros sendo doados","action_id":null,"category":{"id":32,"simple_name":"Em inglês e outras línguas","canonical_name":"Livros em inglês e outras línguas","display_order":null,"children":[]},"user":null},{"image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/marketing%2Fapp-banners%2Fkai-pilger-622399-unsplash.jpg?alt=media&token=a00cb55e-4ab7-4c9e-ac81-b63d5548ed5a","title":"Abra espaço para o novo","caption":"Veja como é fácil doar","action_id":"POST","category":null,"user":null}]';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await carouselApi.getHomeCarouselItems();

    expect(response.data, isA<List<CarouselItem>>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 404));

    final response = await carouselApi.getHomeCarouselItems();

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.notFound);
  });
}