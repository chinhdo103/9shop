import 'package:flutter/material.dart';
import 'package:project_9shop/provider/store_provider.dart';
import 'package:project_9shop/widgets/products/product_list.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  static const String id = 'product-list-screen';
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(
                _storeProvider.selectedProductCategory ?? 'Default Category',
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            )
          ];
        },
        body: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            ProductListWidget(),
          ],
        ),
      ),
    );
  }
}
