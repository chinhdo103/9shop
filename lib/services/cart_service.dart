import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices {
  CollectionReference cart = FirebaseFirestore.instance.collection('GioHang');
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document) {
    cart.doc(user!.uid).set({
      'id': user!.uid,
    });

    // Extract 'MaSP' from the document data
    String maSP = (document.data() as Map<String, dynamic>)['MaSP'] ?? '';

    return cart.doc(user!.uid).collection('SanPham').add({
      'MaSP': maSP,
      'TenSP': (document.data() as Map<String, dynamic>)['TenSP'] ?? '',
      'hinhanh': (document.data() as Map<String, dynamic>)['hinhanh'] ?? '',
      'GiaSP': (document.data() as Map<String, dynamic>)['GiaSP'] ?? '',
      'DonViSP': (document.data() as Map<String, dynamic>)['DonViSP'] ?? '',
      'SoLuong': 1,
      'TongGia': (document.data() as Map<String, dynamic>)['GiaSP'] ?? '',
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

  Future<void> updateProductQuantity(productId, quantity) async {
    DocumentReference cartReference = FirebaseFirestore.instance
        .collection('GioHang')
        .doc(user!.uid)
        .collection('SanPham')
        .doc(productId);

    DocumentReference productReference =
        FirebaseFirestore.instance.collection('SanPham').doc(productId);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document from the cart
          DocumentSnapshot cartSnapshot = await transaction.get(cartReference);

          if (!cartSnapshot.exists) {
            throw Exception("Sản phẩm không tồn tại trong giỏ hàng");
          }

          // Get the document from the product table
          DocumentSnapshot productSnapshot =
              await transaction.get(productReference);

          if (!productSnapshot.exists) {
            throw Exception("Sản phẩm không tồn tại trong bảng sản phẩm");
          }

          // Perform an update on the cart document
          int currentCartQuantity =
              (cartSnapshot.data() as Map<String, dynamic>)['SoLuong'];
          num newCartQuantity = currentCartQuantity - quantity;

          if (newCartQuantity < 0) {
            newCartQuantity = 0;
          }

          num newCartTotalPrice = newCartQuantity *
              (cartSnapshot.data() as Map<String, dynamic>)['GiaSP'];

          transaction.update(cartReference, {
            'SoLuong': newCartQuantity,
            'TongGia': newCartTotalPrice,
          });

          // Perform an update on the product table document
          int currentProductQuantity =
              (productSnapshot.data() as Map<String, dynamic>)['SoLuong'];
          num newProductQuantity = currentProductQuantity - quantity;

          if (newProductQuantity < 0) {
            newProductQuantity = 0;
          }

          transaction.update(productReference, {'SoLuong': newProductQuantity});

          // Return the new quantity in the cart
          return newCartQuantity;
        })
        .then((value) => print("Cập nhật số lượng sản phẩm trong giỏ hàng"))
        .catchError((error) => print(
            "Cập nhật số lượng sản phẩm trong giỏ hàng thất bại: $error"));
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
