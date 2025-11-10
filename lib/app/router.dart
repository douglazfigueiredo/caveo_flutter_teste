import 'package:go_router/go_router.dart';
import '../presentation/pages/splash_page.dart';
import '../presentation/pages/product_list_page.dart';

/// Configuração de rotas do aplicativo usando GoRouter
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) => const ProductListPage(),
    ),
  ],
);
