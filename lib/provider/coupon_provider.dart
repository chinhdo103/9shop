import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier {
  List<Map<String, dynamic>> availableCoupons = [];
  bool? expired;
  DocumentSnapshot? document;
  int discountRate = 0;

  Future<void> getCouponDetails(String title) async {
    DocumentSnapshot? document = await FirebaseFirestore.instance
        .collection('MaGiamGia')
        .doc(title)
        .get();

    if (document.exists) {
      this.document = document;
      notifyListeners();
      checkExpiry(document);
    } else {
      document = null;
      notifyListeners();
    }
  }

  bool isCouponExpired(Map<String, dynamic> couponDetails) {
    Timestamp timestamp = couponDetails['ngayhethan'];
    DateTime expirationDate = timestamp.toDate();
    int dateDiff = expirationDate.difference(DateTime.now()).inDays;
    return dateDiff < 0;
  }

  Future<void> getAllCoupons() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('MaGiamGia')
              .where('trangthai', isEqualTo: true)
              .get();

      availableCoupons = querySnapshot.docs.map((doc) => doc.data()).toList();

      notifyListeners();
    } catch (error) {
      print('Error fetching coupons: $error');
    }
  }

  checkExpiry(DocumentSnapshot document) {
    Timestamp timestamp =
        (document.data() as Map<String, dynamic>)['ngayhethan'];

    DateTime date = timestamp.toDate();
    int dateDiff = date.difference(DateTime.now()).inDays;

    if (dateDiff < 0) {
      expired = true;
      notifyListeners();
    } else {
      document = document;
      expired = false;
      discountRate =
          (document.data() as Map<String, dynamic>)['%giamgia'] ?? '';

      notifyListeners();
    }
  }
}
