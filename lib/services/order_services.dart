import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('donhang');

  Future<DocumentReference> saveOrder(Map<String, dynamic> data) {
    var result = orders.add(
      data,
    );
    return result;
  }
}
