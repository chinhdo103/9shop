import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  DocumentSnapshot? productData;
  getProductDetails(details) {
    productData = details;
    notifyListeners();
  }

  Future<void> fetchTaiKhoanAdminData() async {
    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the TaiKhoanAdmin collection
      CollectionReference taiKhoanAdminCollection =
          firestore.collection('TaiKhoan');

      // Fetch all documents from the collection
      QuerySnapshot querySnapshot = await taiKhoanAdminCollection.get();

      // Print the data for debugging
      querySnapshot.docs.forEach((doc) {
        print('Matk: ${doc['matk']}');
        print(
            'Other Fields: ${doc['other_field']}'); // Replace 'other_field' with your actual field names
      });

      // Notify listeners or update your state with the fetched data if needed
      // ...
    } catch (error) {
      // Handle errors here
      print('Error fetching TaiKhoanAdmin data: $error');
    }
  }
}
