import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_9shop/services/store_services.dart';

class StoreProvider with ChangeNotifier {
  final StoreServices _storeServices = StoreServices();
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? storedetails;
  String? distance;
  String? selectedProductCategory;

  StoreProvider({
    this.storedetails,
    this.distance,
    this.selectedProductCategory,
  });

  getSelectedStore(storeDetails, distance) {
    storedetails = storeDetails;
    distance = distance;
    notifyListeners();
  }

  selectedCategory(category) {
    selectedProductCategory = category;
    notifyListeners();
  }
}
