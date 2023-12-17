import 'package:cloud_firestore/cloud_firestore.dart';

class SanPham {
  // Add other properties as needed

  SanPham(
      {this.maSP,
      this.tenSP,
      this.motaSP,
      this.tenDanhMucPhu,
      this.tenDanhMuc,
      this.tenDanhMucChinh,
      required this.hinhAnh,
      this.giaSP,
      this.trangThai});

  SanPham.fromJson(Map<String, dynamic> json)
      : this(
          maSP: json['MaSP'] as String?,
          tenSP: json['TenSP'] as String?,
          motaSP: json['MotaSP'] as String?,
          giaSP: json['GiaSP'] as int?,
          tenDanhMucPhu: json['TenDanhMucPhu'] as String?,
          tenDanhMucChinh: json['DanhMucChinh'] as String?,
          tenDanhMuc: json['TenDanhMuc'] as String?,
          hinhAnh: _parseHinhAnh(json['hinhanh']),
          trangThai: json['trangthai'],
        );

  static List<String>? _parseHinhAnh(dynamic hinhanh) {
    if (hinhanh is List<dynamic>?) {
      return hinhanh?.map((e) => e as String).toList();
    } else if (hinhanh is String?) {
      // If it's a single string, convert it to a list with one element
      return [hinhanh ?? ''];
    } else {
      return null; // or handle other cases accordingly
    }
  }

  final String? maSP;
  final String? tenSP;
  final String? motaSP;
  final String? tenDanhMucPhu;
  final String? tenDanhMucChinh;
  final String? tenDanhMuc;
  final int? giaSP;
  final List<String>? hinhAnh;

  final bool? trangThai;

  Map<String, Object?> toJson() {
    return {
      'MaSP': maSP,
      'TenSP': tenSP,
      'MotaSP': motaSP,
      'GiaSP': giaSP,
      'TenDanhMucPhu': tenDanhMucPhu,
      'DanhMucChinh': tenDanhMuc,
      'TenDanhMuc': tenDanhMucChinh,
      'hinhanh': hinhAnh,
      'trangthai': trangThai,
    };
  }
}

productQuery({tenDanhMuc}) {
  return FirebaseFirestore.instance
      .collection('SanPham')
      .where('trangthai', isEqualTo: true)
      .where('TenDanhMuc', isEqualTo: tenDanhMuc)
      .withConverter<SanPham>(
        fromFirestore: (snapshot, _) => SanPham.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );
}
