import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/providers.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _loadInitialProducts();
  }

  Future<void> _loadInitialProducts() async {
    // Carrega os produtos iniciais
    await ref.read(productListProvider.notifier).loadInitialProducts();

    // Verifica se o widget ainda está montado
    if (!mounted) return;

    // Obtém o estado atual
    final state = ref.read(productListProvider);

    // Se carregou com sucesso, navega para a tela de produtos
    if (state.error == null && state.products.isNotEmpty) {
      context.go('/products');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo/Ícone do app
            Icon(Icons.shopping_bag, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            // Título do app
            Text(
              'Produtos',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            // Exibe loading ou erro
            if (state.error == null)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            else
              _buildErrorView(state.error!),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadInitialProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text('Tentar Novamente'),
          ),
        ],
      ),
    );
  }
}
