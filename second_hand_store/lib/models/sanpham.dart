// ignore_for_file: public_member_api_docs, sort_constructors_first

// class SanPham {
//   int? idSanpham;
//   String? tenSanpham;
//   int? idNguoidung;
//   int? idDanhmuc;
//   String? ngayTao;
//   String? gioTao;
//   double? gia;
//   String? moTa;
//   bool? status;
//   String? danhmuc;
//   String? nguoidung;
//   List<dynamic>? imageArr;
//   SanPham({
//     this.idSanpham,
//     this.tenSanpham,
//     this.idNguoidung,
//     this.idDanhmuc,
//     this.ngayTao,
//     this.gioTao,
//     this.gia,
//     this.moTa,
//     this.status,
//     this.danhmuc,
//     this.nguoidung,
//     this.imageArr,
//   });

//   SanPham copyWith({
//     int? idSanpham,
//     String? tenSanpham,
//     int? idNguoidung,
//     int? idDanhmuc,
//     String? ngayTao,
//     String? gioTao,
//     double? gia,
//     String? moTa,
//     bool? status,
//     String? danhmuc,
//     String? nguoidung,
//     List<dynamic>? imageArr,
//   }) {
//     return SanPham(
//       idSanpham: idSanpham ?? this.idSanpham,
//       tenSanpham: tenSanpham ?? this.tenSanpham,
//       idNguoidung: idNguoidung ?? this.idNguoidung,
//       idDanhmuc: idDanhmuc ?? this.idDanhmuc,
//       ngayTao: ngayTao ?? this.ngayTao,
//       gioTao: gioTao ?? this.gioTao,
//       gia: gia ?? this.gia,
//       moTa: moTa ?? this.moTa,
//       status: status ?? this.status,
//       danhmuc: danhmuc ?? this.danhmuc,
//       nguoidung: nguoidung ?? this.nguoidung,
//       imageArr: imageArr ?? this.imageArr,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'idSanpham': idSanpham,
//       'tenSanpham': tenSanpham,
//       'idNguoidung': idNguoidung,
//       'idDanhmuc': idDanhmuc,
//       'ngayTao': ngayTao,
//       'gioTao': gioTao,
//       'gia': gia,
//       'moTa': moTa,
//       'status': status,
//       'danhmuc': danhmuc,
//       'nguoidung': nguoidung,
//       'imageArr': imageArr,
//     };
//   }

//   factory SanPham.fromMap(Map<String, dynamic> map) {
//     return SanPham(
//       idSanpham: map['id_sanpham'] != null ? map['id_sanpham'] as int : null,
//       tenSanpham:
//           map['ten_sanpham'] != null ? map['ten_sanpham'] as String : null,
//       idNguoidung:
//           map['id_nguoidung'] != null ? map['id_nguoidung'] as int : null,
//       idDanhmuc: map['id_danhmuc'] != null ? map['id_danhmuc'] as int : null,
//       ngayTao: map['ngay_tao'] != null ? map['ngay_tao'] as String : null,
//       gioTao: map['gio_tao'] != null ? map['gio_tao'] as String : null,
//       gia: map['gia'] != null ? map['gia'] as double : null,
//       moTa: map['mo_ta'] != null ? map['mo_ta'] as String : null,
//       status: map['status'] != null ? map['status'] as bool : null,
//       danhmuc: map['danhmuc'] != null ? map['danhmuc'] as String : null,
//       nguoidung: map['nguoidung'] != null ? map['nguoidung'] as String : null,
//       imageArr: map['imageArr'] != null
//           ? List<dynamic>.from((map['imageArr'] as List<dynamic>))
//           : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory SanPham.fromJson(String source) =>
//       SanPham.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'SanPham(idSanpham: $idSanpham, tenSanpham: $tenSanpham, idNguoidung: $idNguoidung, idDanhmuc: $idDanhmuc, ngayTao: $ngayTao, gioTao: $gioTao, gia: $gia, moTa: $moTa, status: $status, danhmuc: $danhmuc, nguoidung: $nguoidung, imageArr: $imageArr)';
//   }

class SanPham {
  int? idSanpham;
  String? tenSanpham;
  int? idNguoidung;
  int? idDanhmuc;
  String? ngayTao;
  String? gioTao;
  double? gia;
  String? moTa;
  bool? status;
  String? danhmuc;
  String? nguoidung;
  List<dynamic>? imageArr;

  SanPham(
      {this.idSanpham,
      this.tenSanpham,
      this.idNguoidung,
      this.idDanhmuc,
      this.ngayTao,
      this.gioTao,
      this.gia,
      this.moTa,
      this.status,
      this.danhmuc,
      this.nguoidung,
      this.imageArr});

  SanPham.fromJson(Map<String, dynamic> json) {
    idSanpham = json['id_sanpham'];
    tenSanpham = json['ten_sanpham'];
    idNguoidung = json['id_nguoidung'];
    idDanhmuc = json['id_danhmuc'];
    ngayTao = json['ngay_tao'];
    gioTao = json['gio_tao'];
    gia = json['gia'];
    moTa = json['mo_ta'];
    status = json['status'];
    danhmuc = json['danhmuc'];
    nguoidung = json['nguoidung'];
    if (json['imageArr'] != null) {
      imageArr = [];
      json['imageArr'].forEach((v) {
        imageArr!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_sanpham'] = idSanpham;
    data['ten_sanpham'] = tenSanpham;
    data['id_nguoidung'] = idNguoidung;
    data['id_danhmuc'] = idDanhmuc;
    data['ngay_tao'] = ngayTao;
    data['gio_tao'] = gioTao;
    data['gia'] = gia;
    data['mo_ta'] = moTa;
    data['status'] = status;
    data['danhmuc'] = danhmuc;
    data['nguoidung'] = nguoidung;
    if (imageArr != null) {
      data['imageArr'] = imageArr!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
