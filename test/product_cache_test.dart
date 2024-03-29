import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:giv_flutter/model/listing/listing_type.dart';
import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/cache/product_cache.dart';
import 'package:giv_flutter/util/cache/cache_payload.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  MockDiskStorageProvider mockDiskStorageProvider;
  ProductCache productCache;

  setUp(() {
    mockDiskStorageProvider = MockDiskStorageProvider();
    productCache = ProductCache(diskStorage: mockDiskStorageProvider);
  });

  tearDown(() {
    reset(mockDiskStorageProvider);
  });

  group('#getCategories', () {
    group('gets correct cache by key', () {
      test('when fetchAll is false', () {
        // When
        productCache.getCategories(fetchAll: false);

        // Then
        verify(
          mockDiskStorageProvider.getCachePayloadItem(
            ProductCache.PRODUCT_CATEGORIES_CACHE_KEY,
          ),
        ).called(1);
      });

      test('when fetchAll is true', () {
        // When
        productCache.getCategories(fetchAll: true);

        // Then
        verify(
          mockDiskStorageProvider.getCachePayloadItem(
            '${ProductCache.PRODUCT_CATEGORIES_CACHE_KEY}__fetch_all',
          ),
        ).called(1);
      });

      test('when fetchAll is null', () {
        // When
        productCache.getCategories();

        // Then
        verify(
          mockDiskStorageProvider.getCachePayloadItem(
            ProductCache.PRODUCT_CATEGORIES_CACHE_KEY,
          ),
        ).called(1);
      });

      test('when type is null', () {
        // When
        productCache.getCategories();

        // Then
        verify(
          mockDiskStorageProvider.getCachePayloadItem(
            ProductCache.PRODUCT_CATEGORIES_CACHE_KEY,
          ),
        ).called(1);
      });

      test('when type is donation', () {
        // When
        productCache.getCategories(type: ListingType.donation);

        // Then
        verify(
          mockDiskStorageProvider.getCachePayloadItem(
            '${ProductCache.PRODUCT_CATEGORIES_CACHE_KEY}__type_donation',
          ),
        ).called(1);
      });

      test('when type is donation request', () {
        // When
        productCache.getCategories(type: ListingType.donationRequest);

        // Then
        verify(
          mockDiskStorageProvider.getCachePayloadItem(
            '${ProductCache.PRODUCT_CATEGORIES_CACHE_KEY}__type_donation_request',
          ),
        ).called(1);
      });

      test('when fetchAll is false and type is donationn request', () {
        // When
        productCache.getCategories(
            fetchAll: false, type: ListingType.donationRequest);

        // Then
        verify(
          mockDiskStorageProvider.getCachePayloadItem(
            '${ProductCache.PRODUCT_CATEGORIES_CACHE_KEY}__type_donation_request',
          ),
        ).called(1);
      });

      test('when fetchAll is true and type is donation', () {
        // When
        productCache.getCategories(fetchAll: true, type: ListingType.donation);

        // Then
        verify(
          mockDiskStorageProvider.getCachePayloadItem(
            '${ProductCache.PRODUCT_CATEGORIES_CACHE_KEY}__fetch_all__type_donation',
          ),
        ).called(1);
      });

      test('when fetchAll is null and type is donation', () {
        // When
        productCache.getCategories(type: ListingType.donation);

        // Then
        verify(
          mockDiskStorageProvider.getCachePayloadItem(
            '${ProductCache.PRODUCT_CATEGORIES_CACHE_KEY}__type_donation',
          ),
        ).called(1);
      });
    });

    test('returns cache payload if cache item is valid', () {
      when(mockDiskStorageProvider.getCachePayloadItem(any))
          .thenReturn(CachePayload.fakeValidPayload(
        '[{"id":33,"simple_name":"Livros","canonical_name":"Livros","display_order":0,"children":[{"id":25,"simple_name":"Universitários e profissionais","canonical_name":"Livros universitários e profissionais","display_order":null,"children":[]},{"id":26,"simple_name":"Infantojuvenil","canonical_name":"Livros infantojuvenis","display_order":null,"children":[]},{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças","display_order":null,"children":[]},{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção","display_order":null,"children":[]},{"id":29,"simple_name":"Não ficção","canonical_name":"Livros não ficção","display_order":null,"children":[]},{"id":30,"simple_name":"Autoajuda","canonical_name":"Livros de autoajuda","display_order":null,"children":[]},{"id":31,"simple_name":"Religião e espiritualidade","canonical_name":"Livros de religião e espiritualidade","display_order":null,"children":[]},{"id":32,"simple_name":"Em inglês e outras línguas","canonical_name":"Livros em inglês e outras línguas","display_order":null,"children":[]}]},{"id":24,"simple_name":"Roupa","canonical_name":"Roupa","display_order":1,"children":[{"id":21,"simple_name":"Masculina","canonical_name":"Roupa masculina","display_order":null,"children":[{"id":9,"simple_name":"Tamanho PP","canonical_name":"Roupa masculina tamanho PP","display_order":null,"children":[]},{"id":10,"simple_name":"Tamanho P","canonical_name":"Roupa masculina tamanho P","display_order":null,"children":[]},{"id":11,"simple_name":"Tamanho M","canonical_name":"Roupa masculina tamanho M","display_order":null,"children":[]},{"id":12,"simple_name":"Tamanho G","canonical_name":"Roupa masculina tamanho G","display_order":null,"children":[]},{"id":13,"simple_name":"Tamanho GG","canonical_name":"Roupa masculina tamanho GG","display_order":null,"children":[]},{"id":14,"simple_name":"Tamanho 3G","canonical_name":"Roupa masculina tamanho 3G","display_order":null,"children":[]}]},{"id":22,"simple_name":"Feminina","canonical_name":"Roupa feminina","display_order":null,"children":[{"id":15,"simple_name":"Tamanho PP","canonical_name":"Roupa feminina tamanho PP","display_order":null,"children":[]},{"id":16,"simple_name":"Tamanho P","canonical_name":"Roupa feminina tamanho P","display_order":null,"children":[]},{"id":17,"simple_name":"Tamanho M","canonical_name":"Roupa feminina tamanho M","display_order":null,"children":[]},{"id":18,"simple_name":"Tamanho G","canonical_name":"Roupa feminina tamanho G","display_order":null,"children":[]},{"id":19,"simple_name":"Tamanho GG","canonical_name":"Roupa feminina tamanho GG","display_order":null,"children":[]},{"id":20,"simple_name":"Tamanho 3G","canonical_name":"Roupa feminina tamanho 3G","display_order":null,"children":[]}]},{"id":23,"simple_name":"Infantil","canonical_name":"Roupa infantil","display_order":null,"children":[{"id":7,"simple_name":"Meninos","canonical_name":"Roupa infantil masculina","display_order":null,"children":[{"id":1,"simple_name":"Bebê","canonical_name":"Roupa de bebê para menino","display_order":null,"children":[]},{"id":2,"simple_name":"Tamanho 1 a 6","canonical_name":"Roupa para menino tamanaho 1 a 6","display_order":null,"children":[]},{"id":3,"simple_name":"Tamanho 7 a 14","canonical_name":"Roupa para menino tamanaho 7 a 14","display_order":null,"children":[]}]},{"id":8,"simple_name":"Meninas","canonical_name":"Roupa infantil feminina","display_order":null,"children":[{"id":4,"simple_name":"Bebê","canonical_name":"Roupa de bebê para menina","display_order":null,"children":[]},{"id":5,"simple_name":"Tamanho 1 a 6","canonical_name":"Roupa para menina tamanaho 1 a 6","display_order":null,"children":[]},{"id":6,"simple_name":"Tamanho 7 a 14","canonical_name":"Roupa para menina tamanaho 7 a 14","display_order":null,"children":[]}]}]}]},{"id":45,"simple_name":"Casa e cozinha","canonical_name":"Casa e cozinha","display_order":2,"children":[{"id":41,"simple_name":"Móveis","canonical_name":"Móveis","display_order":null,"children":[]},{"id":42,"simple_name":"Eletrodomésticos","canonical_name":"Eletrodomésticos","display_order":null,"children":[]},{"id":43,"simple_name":"Utilidades domésticas","canonical_name":"Utilidades domésticas","display_order":null,"children":[]},{"id":44,"simple_name":"Decoração","canonical_name":"Decoração","display_order":null,"children":[]}]},{"id":39,"simple_name":"Esportes e lazer","canonical_name":"Esportes e lazer","display_order":3,"children":[{"id":34,"simple_name":"Futebol","canonical_name":"Futebol","display_order":null,"children":[]},{"id":35,"simple_name":"Basquetebol","canonical_name":"Basquetebol","display_order":null,"children":[]},{"id":36,"simple_name":"Natação","canonical_name":"Natação","display_order":null,"children":[]},{"id":37,"simple_name":"Ciclismo","canonical_name":"Ciclismo","display_order":null,"children":[]},{"id":38,"simple_name":"Outros esportes","canonical_name":"Outros esportes","display_order":null,"children":[]}]},{"id":50,"simple_name":"Eletrônicos","canonical_name":"Eletrônicos","display_order":4,"children":[{"id":46,"simple_name":"Videogames","canonical_name":"Videogames","display_order":null,"children":[]},{"id":47,"simple_name":"Computadores e acessórios","canonical_name":"Computadores e acessórios","display_order":null,"children":[]},{"id":48,"simple_name":"Celulares, tablets e acessórios","canonical_name":"Celulares, tablets e acessórios","display_order":null,"children":[]},{"id":49,"simple_name":"Áudio, vídeo e fotografia","canonical_name":"Áudio, vídeo e fotografia","display_order":null,"children":[]}]},{"id":59,"simple_name":"Pets","canonical_name":"Pets","display_order":5,"children":[{"id":52,"simple_name":"Cachorros","canonical_name":"Cachorros","display_order":null,"children":[]},{"id":53,"simple_name":"Gatos","canonical_name":"Gatos","display_order":null,"children":[]},{"id":54,"simple_name":"Peixes","canonical_name":"Peixes","display_order":null,"children":[]},{"id":55,"simple_name":"Roedores","canonical_name":"Roedores","display_order":null,"children":[]},{"id":56,"simple_name":"Aves","canonical_name":"Aves","display_order":null,"children":[]},{"id":57,"simple_name":"Répteis","canonical_name":"Répteis","display_order":null,"children":[]},{"id":58,"simple_name":"Outros animais","canonical_name":"Outros animais","display_order":null,"children":[]}]},{"id":51,"simple_name":"Brinquedos","canonical_name":"Brinquedos","display_order":7,"children":[]},{"id":60,"simple_name":"Serviços","canonical_name":"Serviços","display_order":8,"children":[]},{"id":61,"simple_name":"Etc \u0026 tal","canonical_name":"Etc \u0026 tal","display_order":9,"children":[]}]',
      ));
      final categories = productCache.getCategories(fetchAll: false);
      expect(categories, isA<List<ProductCategory>>());
    });

    test('returns null if cache item has expired', () {
      when(mockDiskStorageProvider.getCachePayloadItem(any))
          .thenReturn(CachePayload.fakeExpiredPayload(
        '[{"id":33,"simple_name":"Livros","canonical_name":"Livros","display_order":0,"children":[{"id":25,"simple_name":"Universitários e profissionais","canonical_name":"Livros universitários e profissionais","display_order":null,"children":[]},{"id":26,"simple_name":"Infantojuvenil","canonical_name":"Livros infantojuvenis","display_order":null,"children":[]},{"id":27,"simple_name":"Economia e finanças","canonical_name":"Livros de economia e finanças","display_order":null,"children":[]},{"id":28,"simple_name":"Literatura e ficção","canonical_name":"Livros de literatura e ficção","display_order":null,"children":[]},{"id":29,"simple_name":"Não ficção","canonical_name":"Livros não ficção","display_order":null,"children":[]},{"id":30,"simple_name":"Autoajuda","canonical_name":"Livros de autoajuda","display_order":null,"children":[]},{"id":31,"simple_name":"Religião e espiritualidade","canonical_name":"Livros de religião e espiritualidade","display_order":null,"children":[]},{"id":32,"simple_name":"Em inglês e outras línguas","canonical_name":"Livros em inglês e outras línguas","display_order":null,"children":[]}]},{"id":24,"simple_name":"Roupa","canonical_name":"Roupa","display_order":1,"children":[{"id":21,"simple_name":"Masculina","canonical_name":"Roupa masculina","display_order":null,"children":[{"id":9,"simple_name":"Tamanho PP","canonical_name":"Roupa masculina tamanho PP","display_order":null,"children":[]},{"id":10,"simple_name":"Tamanho P","canonical_name":"Roupa masculina tamanho P","display_order":null,"children":[]},{"id":11,"simple_name":"Tamanho M","canonical_name":"Roupa masculina tamanho M","display_order":null,"children":[]},{"id":12,"simple_name":"Tamanho G","canonical_name":"Roupa masculina tamanho G","display_order":null,"children":[]},{"id":13,"simple_name":"Tamanho GG","canonical_name":"Roupa masculina tamanho GG","display_order":null,"children":[]},{"id":14,"simple_name":"Tamanho 3G","canonical_name":"Roupa masculina tamanho 3G","display_order":null,"children":[]}]},{"id":22,"simple_name":"Feminina","canonical_name":"Roupa feminina","display_order":null,"children":[{"id":15,"simple_name":"Tamanho PP","canonical_name":"Roupa feminina tamanho PP","display_order":null,"children":[]},{"id":16,"simple_name":"Tamanho P","canonical_name":"Roupa feminina tamanho P","display_order":null,"children":[]},{"id":17,"simple_name":"Tamanho M","canonical_name":"Roupa feminina tamanho M","display_order":null,"children":[]},{"id":18,"simple_name":"Tamanho G","canonical_name":"Roupa feminina tamanho G","display_order":null,"children":[]},{"id":19,"simple_name":"Tamanho GG","canonical_name":"Roupa feminina tamanho GG","display_order":null,"children":[]},{"id":20,"simple_name":"Tamanho 3G","canonical_name":"Roupa feminina tamanho 3G","display_order":null,"children":[]}]},{"id":23,"simple_name":"Infantil","canonical_name":"Roupa infantil","display_order":null,"children":[{"id":7,"simple_name":"Meninos","canonical_name":"Roupa infantil masculina","display_order":null,"children":[{"id":1,"simple_name":"Bebê","canonical_name":"Roupa de bebê para menino","display_order":null,"children":[]},{"id":2,"simple_name":"Tamanho 1 a 6","canonical_name":"Roupa para menino tamanaho 1 a 6","display_order":null,"children":[]},{"id":3,"simple_name":"Tamanho 7 a 14","canonical_name":"Roupa para menino tamanaho 7 a 14","display_order":null,"children":[]}]},{"id":8,"simple_name":"Meninas","canonical_name":"Roupa infantil feminina","display_order":null,"children":[{"id":4,"simple_name":"Bebê","canonical_name":"Roupa de bebê para menina","display_order":null,"children":[]},{"id":5,"simple_name":"Tamanho 1 a 6","canonical_name":"Roupa para menina tamanaho 1 a 6","display_order":null,"children":[]},{"id":6,"simple_name":"Tamanho 7 a 14","canonical_name":"Roupa para menina tamanaho 7 a 14","display_order":null,"children":[]}]}]}]},{"id":45,"simple_name":"Casa e cozinha","canonical_name":"Casa e cozinha","display_order":2,"children":[{"id":41,"simple_name":"Móveis","canonical_name":"Móveis","display_order":null,"children":[]},{"id":42,"simple_name":"Eletrodomésticos","canonical_name":"Eletrodomésticos","display_order":null,"children":[]},{"id":43,"simple_name":"Utilidades domésticas","canonical_name":"Utilidades domésticas","display_order":null,"children":[]},{"id":44,"simple_name":"Decoração","canonical_name":"Decoração","display_order":null,"children":[]}]},{"id":39,"simple_name":"Esportes e lazer","canonical_name":"Esportes e lazer","display_order":3,"children":[{"id":34,"simple_name":"Futebol","canonical_name":"Futebol","display_order":null,"children":[]},{"id":35,"simple_name":"Basquetebol","canonical_name":"Basquetebol","display_order":null,"children":[]},{"id":36,"simple_name":"Natação","canonical_name":"Natação","display_order":null,"children":[]},{"id":37,"simple_name":"Ciclismo","canonical_name":"Ciclismo","display_order":null,"children":[]},{"id":38,"simple_name":"Outros esportes","canonical_name":"Outros esportes","display_order":null,"children":[]}]},{"id":50,"simple_name":"Eletrônicos","canonical_name":"Eletrônicos","display_order":4,"children":[{"id":46,"simple_name":"Videogames","canonical_name":"Videogames","display_order":null,"children":[]},{"id":47,"simple_name":"Computadores e acessórios","canonical_name":"Computadores e acessórios","display_order":null,"children":[]},{"id":48,"simple_name":"Celulares, tablets e acessórios","canonical_name":"Celulares, tablets e acessórios","display_order":null,"children":[]},{"id":49,"simple_name":"Áudio, vídeo e fotografia","canonical_name":"Áudio, vídeo e fotografia","display_order":null,"children":[]}]},{"id":59,"simple_name":"Pets","canonical_name":"Pets","display_order":5,"children":[{"id":52,"simple_name":"Cachorros","canonical_name":"Cachorros","display_order":null,"children":[]},{"id":53,"simple_name":"Gatos","canonical_name":"Gatos","display_order":null,"children":[]},{"id":54,"simple_name":"Peixes","canonical_name":"Peixes","display_order":null,"children":[]},{"id":55,"simple_name":"Roedores","canonical_name":"Roedores","display_order":null,"children":[]},{"id":56,"simple_name":"Aves","canonical_name":"Aves","display_order":null,"children":[]},{"id":57,"simple_name":"Répteis","canonical_name":"Répteis","display_order":null,"children":[]},{"id":58,"simple_name":"Outros animais","canonical_name":"Outros animais","display_order":null,"children":[]}]},{"id":51,"simple_name":"Brinquedos","canonical_name":"Brinquedos","display_order":7,"children":[]},{"id":60,"simple_name":"Serviços","canonical_name":"Serviços","display_order":8,"children":[]},{"id":61,"simple_name":"Etc \u0026 tal","canonical_name":"Etc \u0026 tal","display_order":9,"children":[]}]',
      ));
      final categories = productCache.getCategories(fetchAll: false);
      expect(categories, isA<void>());
    });

    test('returns null if cache is valid but serialized data can\'t be parsed',
        () {
      when(mockDiskStorageProvider.getCachePayloadItem(any))
          .thenReturn(CachePayload.fakeValidPayload('can\`t parse me now'));
      final categories = productCache.getCategories(fetchAll: false);
      expect(categories, isA<void>());
    });
  });

  group('#saveCategories', () {
    final serializedData = '[{"id":33,"simple_name":"Livros"}]';

    group('saves with correct cache key', () {
      test('when fetchAll is false', () async {
        await productCache.saveCategories(
          '[{"id":33,"simple_name":"Livros"}]',
          fetchAll: false,
        );

        verify(mockDiskStorageProvider.setCachePayloadItem(
          ProductCache.PRODUCT_CATEGORIES_CACHE_KEY,
          any,
        ));
      });

      test('when fetchAll is true', () async {
        await productCache.saveCategories(
          '[{"id":33,"simple_name":"Livros"}]',
          fetchAll: true,
        );

        verify(mockDiskStorageProvider.setCachePayloadItem(
          '${ProductCache.PRODUCT_CATEGORIES_CACHE_KEY}__fetch_all',
          any,
        ));
      });

      test('when fetchAll is null', () async {
        await productCache.saveCategories(
          '[{"id":33,"simple_name":"Livros"}]',
        );

        verify(mockDiskStorageProvider.setCachePayloadItem(
          ProductCache.PRODUCT_CATEGORIES_CACHE_KEY,
          any,
        ));
      });

      test('when type is donation', () async {
        await productCache.saveCategories(
          '[{"id":33,"simple_name":"Livros"}]',
          type: ListingType.donation,
        );

        verify(mockDiskStorageProvider.setCachePayloadItem(
          '${ProductCache.PRODUCT_CATEGORIES_CACHE_KEY}__type_donation',
          any,
        ));
      });

      test('when type is donation and fetch all is true', () async {
        await productCache.saveCategories('[{"id":33,"simple_name":"Livros"}]',
            type: ListingType.donation, fetchAll: true);

        verify(mockDiskStorageProvider.setCachePayloadItem(
          '${ProductCache.PRODUCT_CATEGORIES_CACHE_KEY}__fetch_all__type_donation',
          any,
        ));
      });
    });

    test('saves cache payload to disk storage', () async {
      final savedPayload = await productCache.saveCategories(
        serializedData,
        fetchAll: false,
      );
      expect(savedPayload.serializedData, serializedData);
      verify(mockDiskStorageProvider.setCachePayloadItem(any, any));
    });
  });
}
