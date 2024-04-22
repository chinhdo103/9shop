import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/services/cart_service.dart';
import 'package:project_9shop/widgets/cart/cart_card.dart';

class CartList extends StatefulWidget {
  final DocumentSnapshot? document;

  const CartList({Key? key, required this.document}) : super(key: key);

  @override
  State<CartList> createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  CartServices _cart = CartServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cart.cart.doc(_cart.user!.uid).collection('SanPham').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Check if there is no data
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Text("No data available");
        }

        // Process and display the data

        return ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return Container(
              height: 130,
              child: CartCard(
                document:
                    document, // Use the document from the current iteration
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
