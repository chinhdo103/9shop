import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices {
  CollectionReference cart = FirebaseFirestore.instance.collection('GioHang');
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document) {
    cart.doc(user!.uid).set({
      'id': user!.uid,
    });
    return cart.doc(user!.uid).collection('SanPham').add({
      'MaSP': (document.data() as Map<String, dynamic>)['MaSP'] ?? '',
      'TenSP': (document.data() as Map<String, dynamic>)['TenSP'] ?? '',
      'hinhanh': (document.data() as Map<String, dynamic>)['hinhanh'] ?? '',
      'GiaSP': (document.data() as Map<String, dynamic>)['GiaSP'] ?? '',
      'SoLuong': 1,
      'TongGia': (document.data() as Map<String, dynamic>)['GiaSP'] ?? ''
    });
  }

  Future<void> updateCartQty(docId, qty, total) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('GioHang')
        .doc(user!.uid)
        .collection('SanPham')
        .doc(docId);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("Sản phẩm không tồn tại trong giỏ hàng");
          }

          // Perform an update on the document
          transaction
              .update(documentReference, {'SoLuong': qty, 'TongGia': total});

          // Return the new count
          return qty;
        })
        .then((value) => print("Cập nhật giỏ hàng"))
        .catchError((error) => print("Cập nhật giỏ hàng thất bại: $error"));
  }

  Future<void> removeFromCart(docId) async {
    cart.doc(user!.uid).collection('SanPham').doc(docId).delete();
  }

  Future<void> checkData() async {
    final snapshot = await cart.doc(user!.uid).collection('SanPham').get();
    if (snapshot.docs.length == 0) {
      cart.doc(user!.uid).delete();
    }
  }

  Future<void> deleteCart() async {
    final result =
        await cart.doc(user!.uid).collection('SanPham').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
