import 'package:giv_flutter/model/product/product_category.dart';
import 'package:giv_flutter/model/product/repository/product_repository.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

void main() {
  ProductRepository productRepository;
  MockProductApi mockProductApi;
  MockProductCache mockProductCache;

  setUp(() {
    mockProductApi = MockProductApi();
    mockProductCache = MockProductCache();
    productRepository = ProductRepository(
      productApi: mockProductApi,
      productCache: mockProductCache,
    );
  });

  tearDown(() {
    reset(mockProductApi);
    reset(mockProductCache);
  });

  test('gets featured product categories from api', () async {
    await productRepository.getFeaturedProductsCategories();
    verify(mockProductApi.getFeaturedProductsCategories()).called(1);
  });

  test('gets my products from api', () async {
    await productRepository.getMyProducts();
    verify(mockProductApi.getMyProducts()).called(1);
  });

  test('gets search query results from api', () async {
    final searchQuery = 'test';
    await productRepository.getProductsBySearchQuery(q: searchQuery);
    verify(mockProductApi.getProductsBySearchQuery(q: searchQuery)).called(1);
  });

  test('gets user\'s products from api', () async {
    final userId = 1;
    await productRepository.getUserProducts(userId);
    verify(mockProductApi.getUserProducts(userId)).called(1);
  });

  test('gets categores from cache if cache is valid', () async {
    when(mockProductCache.getCategories(any))
        .thenReturn(ProductCategory.fakeListBrowsing());
    final response = await productRepository.getSearchCategories();
    // Calls cache
    verify(mockProductCache.getCategories(any)).called(1);
    // Doesn't call API if cache returns an Location
    verifyZeroInteractions(mockProductApi);
    // Returns a Location
    expect(response.data, isA<List<ProductCategory>>());
  });

  test('gets categories from API if cache is not valid and then saves result to cache', () async {
    when(mockProductCache.getCategories(any)).thenReturn(null);
    when(mockProductApi.getSearchCategories(fetchAll: false))
        .thenAnswer((_) async => HttpResponse<List<ProductCategory>>(
              data: ProductCategory.fakeListBrowsing(),
              originalBody: 'an http response body string',
            ));
    final response =
        await productRepository.getSearchCategories(fetchAll: false);
    // Calls cache
    verify(mockProductCache.getCategories(any)).called(1);
    // Calls API if cache returns null
    verify(mockProductApi.getSearchCategories(fetchAll: false)).called(1);
    // Saves API result to cache
    verify(mockProductCache.saveCategories(any, false)).called(1);
    // Returns a Location
    expect(response.data, isA<List<ProductCategory>>());
  });
}
