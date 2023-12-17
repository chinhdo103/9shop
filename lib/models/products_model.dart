import 'package:cloud_firestore/cloud_firestore.dart';

class Products implements Comparable<Products> {
  final String tenSP, danhmuc, danhmucchinh, danhmucphu, hinhanh;
  final num giaSP;
  final DocumentSnapshot documnet;

  const Products(
      {required this.tenSP,
      required this.danhmuc,
      required this.danhmucchinh,
      required this.danhmucphu,
      required this.hinhanh,
      required this.giaSP,
      required this.documnet});

  @override
  int compareTo(Products other) => tenSP.compareTo(other.tenSP);
}
