import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_9shop/widgets/products/add_to_cart_widget.dart';
import 'package:project_9shop/widgets/products/save_for_later.dart';

class BottomSheetContainner extends StatefulWidget {
  final DocumentSnapshot document;
  const BottomSheetContainner({super.key, required this.document});

  @override
  State<BottomSheetContainner> createState() => _BottomSheetContainnerState();
}

class _BottomSheetContainnerState extends State<BottomSheetContainner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: SaveForLater(
              document: widget.document,
            ),
          ),
          Flexible(
            flex: 1,
            child: AddToCartWidget(
              document: widget.document,
            ),
          ),
        ],
      ),
    );
  }
}
