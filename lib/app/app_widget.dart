import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

/// Widget raiz do aplicativo
class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Produtos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
