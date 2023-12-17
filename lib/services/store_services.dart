import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StoreServices extends ChangeNotifier {
  DocumentSnapshot? storedetails;
  String? distance;
  String? selectedProductCategory;

  void getSelectedStore(DocumentSnapshot storeDetails, String distance) {
    this.storedetails = storeDetails;
    this.distance = distance;
    notifyListeners();
  }

  void selectedCategory(String category) {
    selectedProductCategory = category;
    notifyListeners();
  }
}
