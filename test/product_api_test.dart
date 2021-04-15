import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:giv_flutter/config/config.dart';
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/location/location_part.dart';
import 'package:giv_flutter/model/product/product.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/product_search_result.dart';
import 'package:giv_flutter/model/product/repository/api/product_api.dart';
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
  ProductApi productApi;

  setUp(() {
    mockHttp = MockHttp();
    client = HttpClientWrapper(mockHttp, MockDiskStorageProvider(), '');
    productApi = ProductApi(client: client);
  });

  tearDown(() {
    reset(mockHttp);
  });

  group('#getAllProducts', () {
    group('sends correct request', () {
      test('when all arguments are null', () async {
        // When
        await productApi.getAllProducts();

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}',
        );

        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });

      test('when location is set', () async {
        // Given
        final country = Country.fake();
        final state = State.fake();
        final city = City.fake();
        final location = Location(country: country, state: state, city: city);

        // When
        await productApi.getAllProducts(location: location);

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}',
        );
        expect(capturedUri.query, contains('city_id=${city.id}'));
        expect(capturedUri.query, contains('state_id=${state.id}'));
        expect(capturedUri.query, contains('country_id=${country.id}'));
        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });

      test('when isHardFilter is set', () async {
        // When
        await productApi.getAllProducts(isHardFilter: true);

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}',
        );
        expect(capturedUri.query, contains('is_hard_filter=true'));
        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });

      test('when page is set', () async {
        // Given
        final page = 42;

        // When
        await productApi.getAllProducts(page: page);

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}',
        );
        expect(capturedUri.query, contains('page=$page'));
        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });

      test('when type is set', () async {
        // Given
        final type = ListingType.donation;

        // When
        await productApi.getAllProducts(type: type);

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}',
        );
        expect(
          capturedUri.query,
          contains('type=${listingTypeToStringMap[type]}'),
        );
        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });
    });
  });

  test('returns featured categories if GET request succeeds', () async {
    final responseBody =
        '[{"id":28,"simple_name":"Livros de literatura e ficção","listings":[{"id":33,"title":"The Last Enemy - Mrs. Patrick Block","description":"Keytar skateboard kitsch blue bottle.","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.596Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças"},{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção"}],"listing_images":[{"id":180,"url":"https://picsum.photos/500/500/?image=428","position":0},{"id":181,"url":"https://picsum.photos/500/500/?image=555","position":1},{"id":182,"url":"https://picsum.photos/500/500/?image=50","position":2}]},{"id":53,"title":"Changing yourself","description":"Into a moose","geonames_city_id":null,"geonames_state_id":null,"geonames_country_id":"3469034","is_active":true,"updated_at":"2019-09-24T09:02:23.028Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção"}],"listing_images":[{"id":178,"url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Flistings%2F1569315624143-beae8b20-dea9-11e9-d9bc-91e05b5b5450.jpg?alt=media&token=d462f3bc-d70d-49ee-a6ce-d36726e40104","position":0},{"id":179,"url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Flistings%2F1569315731358-fe95f2f0-dea9-11e9-c878-31057cf42fcb.jpg?alt=media&token=6a0d6359-602e-4b55-a20d-a40f366eb686","position":1}]},{"id":54,"title":"Last test maybe?","description":"I hope so :)","geonames_city_id":null,"geonames_state_id":null,"geonames_country_id":"3469034","is_active":true,"updated_at":"2019-09-24T09:04:06.019Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção"}],"listing_images":[{"id":177,"url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Flistings%2F1569315834790-3c3c4460-deaa-11e9-a104-a943f0dd2437.jpg?alt=media&token=48c9f714-7178-424f-a712-1af5647c6258","position":0}]}]},{"id":22,"simple_name":"Roupa feminina","listings":[{"id":41,"title":"It\'s a Battlefield - Olen Dare","description":"Park brunch lo-fi meditation tattooed twee squid cred muggle magic.","geonames_city_id":"3462672","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.781Z","user":{"id":3,"name":"Test User 2","country_calling_code":"55","phone_number":"61981178515","image_url":null,"bio":null,"created_at":"2019-03-25T02:39:26.610Z"},"categories":[{"id":22,"simple_name":"Feminina","canonical_name":"Roupa feminina"}],"listing_images":[{"id":121,"url":"https://picsum.photos/500/500/?image=83","position":0},{"id":122,"url":"https://picsum.photos/500/500/?image=645","position":1},{"id":123,"url":"https://picsum.photos/500/500/?image=407","position":2}]},{"id":42,"title":"This Side of Paradise - Danae Weber","description":"Trust fund readymade pinterest blog.","geonames_city_id":"3462672","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.816Z","user":{"id":3,"name":"Test User 2","country_calling_code":"55","phone_number":"61981178515","image_url":null,"bio":null,"created_at":"2019-03-25T02:39:26.610Z"},"categories":[{"id":22,"simple_name":"Feminina","canonical_name":"Roupa feminina"}],"listing_images":[{"id":124,"url":"https://picsum.photos/500/500/?image=31","position":0},{"id":125,"url":"https://picsum.photos/500/500/?image=411","position":1},{"id":126,"url":"https://picsum.photos/500/500/?image=800","position":2}]},{"id":55,"title":"Testing","description":"lorem ipsum dolor","geonames_city_id":"123","geonames_state_id":"456","geonames_country_id":"789","is_active":true,"updated_at":"2019-09-26T15:48:54.532Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":19,"simple_name":"Tamanho GG","canonical_name":"Roupa feminina tamanho GG"},{"id":26,"simple_name":"Infantojuvenil","canonical_name":"Livros infantojuvenis"}],"listing_images":[{"id":228,"url":"https://picsum.photos/500/500/?image=336","position":0},{"id":229,"url":"https://picsum.photos/500/500/?image=68","position":1},{"id":230,"url":"https://picsum.photos/500/500/?image=175","position":2}]}]},{"id":51,"simple_name":"Brinquedos","listings":[{"id":16,"title":"alligator","description":"Looks like a real dog, doesn\'t it?","geonames_city_id":null,"geonames_state_id":"3462372","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-09-24T09:10:49.288Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":51,"simple_name":"Brinquedos","canonical_name":"Brinquedos"}],"listing_images":[{"id":192,"url":"https://picsum.photos/500/500/?image=237","position":0},{"id":193,"url":"https://picsum.photos/500/500/?image=418","position":1},{"id":194,"url":"https://picsum.photos/500/500/?image=755","position":2}]}]},{"id":63,"simple_name":"Se souber consertar, pode ficar","listings":[]}]';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await productApi.getFeaturedProductsCategories(
        location: Location.fake());

    expect(response.data, isA<List<ProductCategory>>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET featured categories request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await productApi.getFeaturedProductsCategories(
        location: Location.fake());

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  group('#getSearchCategories', () {
    group('sends get correct categories request', () {
      test('sends has_listings=true by default', () async {
        // When
        await productApi.getSearchCategories();

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.CATEGORIES_ENDPOINT}',
        );

        expect(capturedUri.query, contains('has_listings=true'));
      });

      test('sends has_listings=false when fetchAll is true', () async {
        // When
        await productApi.getSearchCategories(fetchAll: true);

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.CATEGORIES_ENDPOINT}',
        );

        expect(capturedUri.query, contains('has_listings=false'));
      });

      test('sends type=donation when listing type is donation', () async {
        // When
        await productApi.getSearchCategories(
          type: ListingType.donation,
          fetchAll: true,
        );

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.CATEGORIES_ENDPOINT}',
        );

        expect(capturedUri.query, contains('has_listings=false'));
        expect(capturedUri.query, contains('type=donation'));
      });

      test('sends type=donation_request when listing type is donation request',
          () async {
        // When
        await productApi.getSearchCategories(
          type: ListingType.donationRequest,
          fetchAll: true,
        );

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.CATEGORIES_ENDPOINT}',
        );

        expect(capturedUri.query, contains('has_listings=false'));
        expect(capturedUri.query, contains('type=donation_request'));
      });
    });

    test('returns search categories if GET request succeeds', () async {
      final responseBody =
          '[{"id":33,"simple_name":"Livros","canonical_name":"Livros","display_order":0,"children":[{"id":25,"simple_name":"Universitários e profissionais","canonical_name":"Livros universitários e profissionais","display_order":null,"children":[]},{"id":26,"simple_name":"Infantojuvenil","canonical_name":"Livros infantojuvenis","display_order":null,"children":[]},{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças","display_order":null,"children":[]},{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção","display_order":null,"children":[]},{"id":29,"simple_name":"Não ficção","canonical_name":"Livros não ficção","display_order":null,"children":[]},{"id":30,"simple_name":"Autoajuda","canonical_name":"Livros de autoajuda","display_order":null,"children":[]},{"id":31,"simple_name":"Religião e espiritualidade","canonical_name":"Livros de religião e espiritualidade","display_order":null,"children":[]},{"id":32,"simple_name":"Em inglês e outras línguas","canonical_name":"Livros em inglês e outras línguas","display_order":null,"children":[]}]},{"id":24,"simple_name":"Roupa","canonical_name":"Roupa","display_order":1,"children":[{"id":21,"simple_name":"Masculina","canonical_name":"Roupa masculina","display_order":null,"children":[{"id":9,"simple_name":"Tamanho PP","canonical_name":"Roupa masculina tamanho PP","display_order":null,"children":[]},{"id":10,"simple_name":"Tamanho P","canonical_name":"Roupa masculina tamanho P","display_order":null,"children":[]},{"id":11,"simple_name":"Tamanho M","canonical_name":"Roupa masculina tamanho M","display_order":null,"children":[]},{"id":12,"simple_name":"Tamanho G","canonical_name":"Roupa masculina tamanho G","display_order":null,"children":[]},{"id":13,"simple_name":"Tamanho GG","canonical_name":"Roupa masculina tamanho GG","display_order":null,"children":[]},{"id":14,"simple_name":"Tamanho 3G","canonical_name":"Roupa masculina tamanho 3G","display_order":null,"children":[]}]},{"id":22,"simple_name":"Feminina","canonical_name":"Roupa feminina","display_order":null,"children":[{"id":15,"simple_name":"Tamanho PP","canonical_name":"Roupa feminina tamanho PP","display_order":null,"children":[]},{"id":16,"simple_name":"Tamanho P","canonical_name":"Roupa feminina tamanho P","display_order":null,"children":[]},{"id":17,"simple_name":"Tamanho M","canonical_name":"Roupa feminina tamanho M","display_order":null,"children":[]},{"id":18,"simple_name":"Tamanho G","canonical_name":"Roupa feminina tamanho G","display_order":null,"children":[]},{"id":19,"simple_name":"Tamanho GG","canonical_name":"Roupa feminina tamanho GG","display_order":null,"children":[]},{"id":20,"simple_name":"Tamanho 3G","canonical_name":"Roupa feminina tamanho 3G","display_order":null,"children":[]}]},{"id":23,"simple_name":"Infantil","canonical_name":"Roupa infantil","display_order":null,"children":[{"id":7,"simple_name":"Meninos","canonical_name":"Roupa infantil masculina","display_order":null,"children":[{"id":1,"simple_name":"Bebê","canonical_name":"Roupa de bebê para menino","display_order":null,"children":[]},{"id":2,"simple_name":"Tamanho 1 a 6","canonical_name":"Roupa para menino tamanaho 1 a 6","display_order":null,"children":[]},{"id":3,"simple_name":"Tamanho 7 a 14","canonical_name":"Roupa para menino tamanaho 7 a 14","display_order":null,"children":[]}]},{"id":8,"simple_name":"Meninas","canonical_name":"Roupa infantil feminina","display_order":null,"children":[{"id":4,"simple_name":"Bebê","canonical_name":"Roupa de bebê para menina","display_order":null,"children":[]},{"id":5,"simple_name":"Tamanho 1 a 6","canonical_name":"Roupa para menina tamanaho 1 a 6","display_order":null,"children":[]},{"id":6,"simple_name":"Tamanho 7 a 14","canonical_name":"Roupa para menina tamanaho 7 a 14","display_order":null,"children":[]}]}]}]},{"id":45,"simple_name":"Casa e cozinha","canonical_name":"Casa e cozinha","display_order":2,"children":[{"id":41,"simple_name":"Móveis","canonical_name":"Móveis","display_order":null,"children":[]},{"id":42,"simple_name":"Eletrodomésticos","canonical_name":"Eletrodomésticos","display_order":null,"children":[]},{"id":43,"simple_name":"Utilidades domésticas","canonical_name":"Utilidades domésticas","display_order":null,"children":[]},{"id":44,"simple_name":"Decoração","canonical_name":"Decoração","display_order":null,"children":[]}]},{"id":39,"simple_name":"Esportes e lazer","canonical_name":"Esportes e lazer","display_order":3,"children":[{"id":34,"simple_name":"Futebol","canonical_name":"Futebol","display_order":null,"children":[]},{"id":35,"simple_name":"Basquetebol","canonical_name":"Basquetebol","display_order":null,"children":[]},{"id":36,"simple_name":"Natação","canonical_name":"Natação","display_order":null,"children":[]},{"id":37,"simple_name":"Ciclismo","canonical_name":"Ciclismo","display_order":null,"children":[]},{"id":38,"simple_name":"Outros esportes","canonical_name":"Outros esportes","display_order":null,"children":[]}]},{"id":50,"simple_name":"Eletrônicos","canonical_name":"Eletrônicos","display_order":4,"children":[{"id":46,"simple_name":"Videogames","canonical_name":"Videogames","display_order":null,"children":[]},{"id":47,"simple_name":"Computadores e acessórios","canonical_name":"Computadores e acessórios","display_order":null,"children":[]},{"id":48,"simple_name":"Celulares, tablets e acessórios","canonical_name":"Celulares, tablets e acessórios","display_order":null,"children":[]},{"id":49,"simple_name":"Áudio, vídeo e fotografia","canonical_name":"Áudio, vídeo e fotografia","display_order":null,"children":[]}]},{"id":59,"simple_name":"Pets","canonical_name":"Pets","display_order":5,"children":[{"id":52,"simple_name":"Cachorros","canonical_name":"Cachorros","display_order":null,"children":[]},{"id":53,"simple_name":"Gatos","canonical_name":"Gatos","display_order":null,"children":[]},{"id":54,"simple_name":"Peixes","canonical_name":"Peixes","display_order":null,"children":[]},{"id":55,"simple_name":"Roedores","canonical_name":"Roedores","display_order":null,"children":[]},{"id":56,"simple_name":"Aves","canonical_name":"Aves","display_order":null,"children":[]},{"id":57,"simple_name":"Répteis","canonical_name":"Répteis","display_order":null,"children":[]},{"id":58,"simple_name":"Outros animais","canonical_name":"Outros animais","display_order":null,"children":[]}]},{"id":40,"simple_name":"Música e hobbies","canonical_name":"Música e hobbies","display_order":6,"children":[]},{"id":51,"simple_name":"Brinquedos","canonical_name":"Brinquedos","display_order":7,"children":[]},{"id":60,"simple_name":"Serviços","canonical_name":"Serviços","display_order":8,"children":[]},{"id":61,"simple_name":"Etc & tal","canonical_name":"Etc & tal","display_order":9,"children":[]},{"id":63,"simple_name":"Itens com defeito","canonical_name":"Itens com defeito","display_order":10,"children":[{"id":62,"simple_name":"Eletrônicos","canonical_name":"Eletrônicos com defeito","display_order":null,"children":[]}]}]';

      when(mockHttp.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(responseBody, 200));

      final response = await productApi.getSearchCategories();

      expect(response.data, isA<List<ProductCategory>>());
      expect(response.status, HttpStatus.ok);
    });

    test('returns null data if GET search categories request fails', () async {
      when(client.http.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 400));

      final response = await productApi.getSearchCategories();

      expect(response.data, isA<void>());
      expect(response.status, HttpStatus.badRequest);
    });
  });

  group('#getProductsByCategory', () {
    group('sends correct request', () {
      test('when all arguments are null', () async {
        // Given
        final categoryId = 123;

        // When
        await productApi.getProductsByCategory(categoryId: categoryId);

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}/${ProductApi.CATEGORIES_ENDPOINT}/$categoryId',
        );

        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });

      test('when location is set', () async {
        // Given
        final categoryId = 123;
        final country = Country.fake();
        final state = State.fake();
        final city = City.fake();
        final location = Location(country: country, state: state, city: city);

        // When
        await productApi.getProductsByCategory(
          categoryId: categoryId,
          location: location,
        );

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}/${ProductApi.CATEGORIES_ENDPOINT}/$categoryId',
        );

        expect(capturedUri.query, contains('city_id=${city.id}'));
        expect(capturedUri.query, contains('state_id=${state.id}'));
        expect(capturedUri.query, contains('country_id=${country.id}'));

        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });

      test('when isHardFilter is set', () async {
        // Given
        final categoryId = 123;

        // When
        await productApi.getProductsByCategory(
          isHardFilter: true,
          categoryId: categoryId,
        );

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}/${ProductApi.CATEGORIES_ENDPOINT}/$categoryId',
        );

        expect(capturedUri.query, contains('is_hard_filter=true'));

        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });

      test('when page is set', () async {
        // Given
        final categoryId = 123;
        final page = 42;

        // When
        await productApi.getProductsByCategory(
          page: page,
          categoryId: categoryId,
        );

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}/${ProductApi.CATEGORIES_ENDPOINT}/$categoryId',
        );

        expect(capturedUri.query, contains('page=$page'));

        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });

      test('when type is set', () async {
        // Given
        final categoryId = 123;
        final type = ListingType.donation;

        // When
        await productApi.getProductsByCategory(
          categoryId: categoryId,
          type: type,
        );

        // Then
        final captured = verify(
          mockHttp.get(
            captureAny,
            headers: anyNamed('headers'),
          ),
        ).captured;

        final Uri capturedUri = captured[0];

        expect(
          capturedUri.path,
          '/${ProductApi.LISTINGS_ENDPOINT}/${ProductApi.CATEGORIES_ENDPOINT}/$categoryId',
        );

        expect(capturedUri.query,
            contains('type=${listingTypeToStringMap[type]}'));

        expect(
          capturedUri.query,
          contains('per_page=${Config.paginationDefaultPerPage}'),
        );
      });
    });

    test('returns prouducts by category if GET request succeeds', () async {
      final responseBody =
          '{"listings":[{"id":32,"title":"Oh! To be in England - Marc Howell","description":"Cold-pressed wolf pork belly brunch phlogiston humblebrag.","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.570Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças"}],"listing_images":[{"id":94,"url":"https://picsum.photos/500/500/?image=597","position":0},{"id":95,"url":"https://picsum.photos/500/500/?image=535","position":1},{"id":96,"url":"https://picsum.photos/500/500/?image=794","position":2}]},{"id":33,"title":"The Last Enemy - Mrs. Patrick Block","description":"Keytar skateboard kitsch blue bottle.","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.596Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças"},{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção"}],"listing_images":[{"id":180,"url":"https://picsum.photos/500/500/?image=428","position":0},{"id":181,"url":"https://picsum.photos/500/500/?image=555","position":1},{"id":182,"url":"https://picsum.photos/500/500/?image=50","position":2}]},{"id":34,"title":"A Time to Kill - Jude Daugherty I","description":"Kinfolk small batch squid mlkshk lomo migas.","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.621Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças"}],"listing_images":[{"id":100,"url":"https://picsum.photos/500/500/?image=383","position":0},{"id":101,"url":"https://picsum.photos/500/500/?image=127","position":1},{"id":102,"url":"https://picsum.photos/500/500/?image=347","position":2}]},{"id":35,"title":"Many Waters - Lyle McClure","description":"Raw denim church-key small batch chillwave tacos synth vegan cardigan.","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.644Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças"}],"listing_images":[{"id":103,"url":"https://picsum.photos/500/500/?image=303","position":0},{"id":104,"url":"https://picsum.photos/500/500/?image=795","position":1},{"id":105,"url":"https://picsum.photos/500/500/?image=501","position":2}]}],"location":{"country":{"id":"3469034","name":"Brasil"},"state":{"id":"3463504","name":"Federal District"},"city":null}}';

      when(client.http.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(responseBody, 200));

      final response = await productApi.getProductsByCategory();

      expect(response.data, isA<ProductSearchResult>());
      expect(response.status, HttpStatus.ok);
    });

    test('returns null data if GET products by category request fails',
        () async {
      when(client.http.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('', 400));

      final response = await productApi.getProductsByCategory();

      expect(response.data, isA<void>());
      expect(response.status, HttpStatus.badRequest);
    });
  });

  test('returns prouducts by search query if GET request succeeds', () async {
    final responseBody =
        '{"listings":[{"id":32,"title":"Oh! To be in England - Marc Howell","description":"Cold-pressed wolf pork belly brunch phlogiston humblebrag.","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.570Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças"}],"listing_images":[{"id":94,"url":"https://picsum.photos/500/500/?image=597","position":0},{"id":95,"url":"https://picsum.photos/500/500/?image=535","position":1},{"id":96,"url":"https://picsum.photos/500/500/?image=794","position":2}]},{"id":34,"title":"A Time to Kill - Jude Daugherty I","description":"Kinfolk small batch squid mlkshk lomo migas.","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.621Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças"}],"listing_images":[{"id":100,"url":"https://picsum.photos/500/500/?image=383","position":0},{"id":101,"url":"https://picsum.photos/500/500/?image=127","position":1},{"id":102,"url":"https://picsum.photos/500/500/?image=347","position":2}]},{"id":35,"title":"Many Waters - Lyle McClure","description":"Raw denim church-key small batch chillwave tacos synth vegan cardigan.","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.644Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças"}],"listing_images":[{"id":103,"url":"https://picsum.photos/500/500/?image=303","position":0},{"id":104,"url":"https://picsum.photos/500/500/?image=795","position":1},{"id":105,"url":"https://picsum.photos/500/500/?image=501","position":2}]},{"id":33,"title":"The Last Enemy - Mrs. Patrick Block","description":"Keytar skateboard kitsch blue bottle.","geonames_city_id":"6324222","geonames_state_id":"3463504","geonames_country_id":"3469034","is_active":true,"updated_at":"2019-03-25T02:40:05.596Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças"},{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção"}],"listing_images":[{"id":180,"url":"https://picsum.photos/500/500/?image=428","position":0},{"id":181,"url":"https://picsum.photos/500/500/?image=555","position":1},{"id":182,"url":"https://picsum.photos/500/500/?image=50","position":2}]}],"location":{"country":{"id":"3469034","name":"Brasil"},"state":{"id":"3463504","name":"Federal District"},"city":null}}';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await productApi.getProductsBySearchQuery(q: 'test');

    expect(response.data, isA<ProductSearchResult>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET products by search query request fails',
      () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await productApi.getProductsBySearchQuery(q: 'test');

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  test('returns my products if GET request succeeds', () async {
    final responseBody =
        '[{"id":55,"title":"Testing","description":"lorem ipsum dolor","geonames_city_id":"123","geonames_state_id":"456","geonames_country_id":"789","is_active":true,"updated_at":"2019-09-26T15:48:54.532Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":19,"simple_name":"Tamanho GG","canonical_name":"Roupa feminina tamanho GG"},{"id":26,"simple_name":"Infantojuvenil","canonical_name":"Livros infantojuvenis"}],"listing_images":[{"id":228,"url":"https://picsum.photos/500/500/?image=336","position":0},{"id":229,"url":"https://picsum.photos/500/500/?image=68","position":1},{"id":230,"url":"https://picsum.photos/500/500/?image=175","position":2}]},{"id":54,"title":"Last test maybe?","description":"I hope so :)","geonames_city_id":null,"geonames_state_id":null,"geonames_country_id":"3469034","is_active":true,"updated_at":"2019-09-24T09:04:06.019Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção"}],"listing_images":[{"id":177,"url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Flistings%2F1569315834790-3c3c4460-deaa-11e9-a104-a943f0dd2437.jpg?alt=media&token=48c9f714-7178-424f-a712-1af5647c6258","position":0}]}]';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await productApi.getMyProducts();

    expect(response.data, isA<List<Product>>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET my products request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await productApi.getMyProducts();

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });

  test('returns user\'s products if GET request succeeds', () async {
    final responseBody =
        '[{"id":55,"title":"Testing","description":"lorem ipsum dolor","geonames_city_id":"123","geonames_state_id":"456","geonames_country_id":"789","is_active":true,"updated_at":"2019-09-26T15:48:54.532Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":19,"simple_name":"Tamanho GG","canonical_name":"Roupa feminina tamanho GG"},{"id":26,"simple_name":"Infantojuvenil","canonical_name":"Livros infantojuvenis"}],"listing_images":[{"id":228,"url":"https://picsum.photos/500/500/?image=336","position":0},{"id":229,"url":"https://picsum.photos/500/500/?image=68","position":1},{"id":230,"url":"https://picsum.photos/500/500/?image=175","position":2}]},{"id":54,"title":"Last test maybe?","description":"I hope so :)","geonames_city_id":null,"geonames_state_id":null,"geonames_country_id":"3469034","is_active":true,"updated_at":"2019-09-24T09:04:06.019Z","user":{"id":1,"name":"Test User","country_calling_code":"55","phone_number":"61981178515","image_url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Fusers%2F1%2Fphotos%2F1569400230645.jpg?alt=media&token=5f7cdb23-1f6d-4e10-bd30-9df04265522e","bio":null,"created_at":"2019-03-25T02:39:26.452Z"},"categories":[{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção"}],"listing_images":[{"id":177,"url":"https://firebasestorage.googleapis.com/v0/b/givapp-938de.appspot.com/o/dev%2Flistings%2F1569315834790-3c3c4460-deaa-11e9-a104-a943f0dd2437.jpg?alt=media&token=48c9f714-7178-424f-a712-1af5647c6258","position":0}]}]';

    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(responseBody, 200));

    final response = await productApi.getUserProducts(1);

    expect(response.data, isA<List<Product>>());
    expect(response.status, HttpStatus.ok);
  });

  test('returns null data if GET user\'s products request fails', () async {
    when(client.http.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('', 400));

    final response = await productApi.getUserProducts(1);

    expect(response.data, isA<void>());
    expect(response.status, HttpStatus.badRequest);
  });
}
