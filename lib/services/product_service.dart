import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ProductServices {
  CollectionReference category =
      FirebaseFirestore.instance.collection('DanhMucPhu');
  CollectionReference products =
      FirebaseFirestore.instance.collection('SanPham');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final StreamController<List<DocumentSnapshot>> _favoriteProductsController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get favoriteProductsStream =>
      _favoriteProductsController.stream;

  Future<List<DocumentSnapshot>> getFavoriteProducts(String userId) async {
    try {
      // Query the yeuthich collection where the 'userid' field matches the provided user ID
      QuerySnapshot querySnapshot = await _firestore
          .collection('yeuthich')
          .where('id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;

        CollectionReference sanphamCollectionRef =
            userDoc.reference.collection('SanPham');

        // Fetch the documents from the SanPham subcollection
        QuerySnapshot snapshot = await sanphamCollectionRef.get();
        // Extract the documents and return them
        List<DocumentSnapshot> documents = snapshot.docs;
        return documents;
      } else {
        return [];
      }
    } catch (error) {
      print('Error getting favorite products: $error');
      // Handle the error by returning an empty list
      return [];
    }
  }
}
