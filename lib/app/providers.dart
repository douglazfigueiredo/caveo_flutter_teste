import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/repositories/product_repository.dart';
import '../application/use-cases/load_initial_products_command.dart';
import '../application/use-cases/load_more_products_command.dart';
import '../infrastructure/api/fake_store_api_client.dart';
import '../infrastructure/repositories/product_repository_impl.dart';
import '../presentation/state/product_list_notifier.dart';
import '../presentation/state/product_list_state.dart';

/// Provider para a instância do Dio
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: FakeStoreApiClient.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
});

/// Provider para o cliente da API
final apiClientProvider = Provider<FakeStoreApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return FakeStoreApiClient(dio);
});

/// Provider para o repositório de produtos
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductRepositoryImpl(apiClient);
});

/// Provider para o comando de carregamento inicial de produtos
final loadInitialProductsCommandProvider = Provider<LoadInitialProductsCommand>(
  (ref) {
    final repository = ref.watch(productRepositoryProvider);
    return LoadInitialProductsCommand(repository);
  },
);

/// Provider family para o comando de carregamento de mais produtos
/// Recebe o offset atual como parâmetro
final loadMoreProductsCommandProvider =
    Provider.family<LoadMoreProductsCommand, int>((ref, offset) {
      final repository = ref.watch(productRepositoryProvider);
      return LoadMoreProductsCommand(
        repository: repository,
        currentOffset: offset,
      );
    });

/// Provider para o estado da lista de produtos
final productListProvider =
    StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
      return ProductListNotifier(ref);
    });
