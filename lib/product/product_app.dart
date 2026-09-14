import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme.dart';
import 'drakson_store.dart';
import 'screens.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final store = DraksonStore();
        store.loadData();
        return store;
      },
      child: MaterialApp(
        title: 'Drakson',
        theme: AppTheme.build(),
        home: const DraksonHome(),
      ),
    );
  }
}
