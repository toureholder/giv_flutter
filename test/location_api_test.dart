import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:giv_flutter/model/location/coordinates.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_list.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/location/repository/api/location_api.dart';
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
  LocationApi locationApi;
  Location fakeLocation = Location.fake();
  Coordinates fakeCoordinates = Coordinates.fake();

  setUp(() {
    mockHttp = MockHttp();
    client = HttpClientWrapper(mockHttp, MockDiskStorageProvider(), '');
    locationApi = LocationApi(client: client);
  });

  tearDown(() {
    reset(mockHttp);
  });

  test('returns list of Countries data if GET request succeeds', () async {
    final responseBody = '[{"id":3469034,"name":"Brasil"}]';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await locationApi.getCountries();

    expect(response.data, isA<List<Country>>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET Countries request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await locationApi.getCountries();

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  test('returns list of States data if GET request succeeds', () async {
    final responseBody = '[{"id":3469034,"name":"Acre"}]';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await locationApi.getStates('countryId');

    expect(response.data, isA<List<State>>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET States request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await locationApi.getStates('countryId');

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  test('returns list of Cities data if GET request succeeds', () async {
    final responseBody = '[{"id":6324222,"name":"Brasília"}]';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await locationApi.getCities('countryId', 'stateId');

    expect(response.data, isA<List<City>>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET Cities request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await locationApi.getCities('countryId', 'stateId');

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  test('returns LocationList data if GET request succeeds', () async {
    final responseBody =
        '{"countries":[{"id":3469034,"name":"Brasil"}],"states":[{"id":3665474,"name":"Acre"},{"id":3408096,"name":"Alagoas"},{"id":3407762,"name":"Amapá"},{"id":3665361,"name":"Amazonas"},{"id":3471168,"name":"Bahia"},{"id":3402362,"name":"Ceará"},{"id":3463504,"name":"Distrito Federal"},{"id":3463930,"name":"Espírito Santo"},{"id":3462372,"name":"Goiás"},{"id":3395443,"name":"Maranhão"},{"id":3457419,"name":"Mato Grosso"},{"id":3457415,"name":"Mato Grosso do Sul"},{"id":3457153,"name":"Minas Gerais"},{"id":3393129,"name":"Pará"},{"id":3393098,"name":"Paraíba"},{"id":3455077,"name":"Paraná"},{"id":3392268,"name":"Pernambuco"},{"id":3392213,"name":"Piauí"},{"id":3390290,"name":"Rio Grande do Norte"},{"id":3451133,"name":"Rio Grande do Sul"},{"id":3451189,"name":"Rio de Janeiro"},{"id":3924825,"name":"Rondônia"},{"id":3662560,"name":"Roraima"},{"id":3450387,"name":"Santa Catarina"},{"id":3448433,"name":"São Paulo"},{"id":3447799,"name":"Sergipe"},{"id":3474575,"name":"Tocantins"}],"cities":[{"id":6698121,"name":"Águas Claras / Taguatinga"},{"id":6324222,"name":"Brasília"},{"id":3469049,"name":"Brazlândia"},{"id":3466489,"name":"Ceilândia"},{"id":8470079,"name":"Cruzeiro / Sudoeste / Octogonal"},{"id":3462672,"name":"Gama"},{"id":3461936,"name":"Guará"},{"id":3461936,"name":"Guará"},{"id":9179592,"name":"Lago Norte"},{"id":10345224,"name":"Lago Sul"},{"id":3456049,"name":"Núcleo Bandeirante / Park Way"},{"id":3455047,"name":"Paranoá / Itapoã"},{"id":11184422,"name":"Planaltina"},{"id":6698113,"name":"Recanto das Emas"},{"id":6698114,"name":"Riacho Fundo"},{"id":6698115,"name":"Samambaia"},{"id":3447472,"name":"Sobradinho"},{"id":8603579,"name":"Sobradinho II"},{"id":8603565,"name":"Varjão"}]}';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await locationApi.getLocationList(fakeLocation);

    expect(response.data, isA<LocationList>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET LocationList request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await locationApi.getLocationList(fakeLocation);

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  test('returns Location data if GET detail request succeeds', () async {
    final responseBody =
        '{"country":{"id":"3469034","name":"Brasil"},"state":{"id":"3463504","name":"Distrito Federal"},"city":{"id":"6324222","name":"Brasília"}}';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await locationApi.getLocationDetails(fakeLocation);

    expect(response.data, isA<Location>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET Location details request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await locationApi.getLocationDetails(fakeLocation);

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  test('returns Location data if GET my location request succeeds', () async {
    final responseBody =
        '{"country":{"id":"3469034","name":"Brasil"},"state":{"id":"3463504","name":"Distrito Federal"},"city":{"id":"6324222","name":"Brasília"}}';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await locationApi.getMyLocation(fakeCoordinates);

    expect(response.data, isA<Location>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET my location request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await locationApi.getMyLocation(fakeCoordinates);

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });
}
