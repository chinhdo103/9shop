import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/services/product_service.dart';
import 'package:project_9shop/widgets/products/product_card_widget.dart';

class SaveProductScreen extends StatelessWidget {
  static const String id = 'favorite-products-screen';
  final List<DocumentSnapshot> favoriteProducts;

  const SaveProductScreen({Key? key, required this.favoriteProducts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    Stream<List<DocumentSnapshot>> favoriteProductsStream =
        _services.favoriteProductsStream;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sản Phẩm Yêu Thích'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: favoriteProductsStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data == null) {
            print('Loading...');
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No favorite products found.'),
            );
          }

          return Column(
            children: [
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'Sản Phẩm Yêu Thích',
                      style: TextStyle(
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          )
                        ],
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic>? data =
                          document.data() as Map<String, dynamic>?;

                      if (data == null) {
                        return Container(); // or some placeholder widget
                      }

                      return ProductCard(document: document);
                    },
                  ).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
