class SanPham {
  int? idSanpham;
  String? tenSanpham;
  int? idNguoidung;
  int? idDanhmuc;
  int? ngayTao;
  double? gia;
  String? moTa;
  String? sdt;
  String? diachi;
  bool? status;
  String? danhmuc;
  String? nguoidung;
  List<String>? imageArr;

  SanPham(
      {this.idSanpham,
      this.tenSanpham,
      this.idNguoidung,
      this.idDanhmuc,
      this.ngayTao,
      this.gia,
      this.moTa,
      this.sdt,
      this.diachi,
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
    gia = json['gia'];
    moTa = json['mo_ta'];
    sdt = json['sdt'];
    diachi = json['diachi'];
    status = json['status'];
    danhmuc = json['danhmuc'];
    nguoidung = json['nguoidung'];
    imageArr = json['imageArr'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_sanpham'] = idSanpham;
    data['ten_sanpham'] = tenSanpham;
    data['id_nguoidung'] = idNguoidung;
    data['id_danhmuc'] = idDanhmuc;
    data['ngay_tao'] = ngayTao;
    data['gia'] = gia;
    data['mo_ta'] = moTa;
    data['sdt'] = sdt;
    data['diachi'] = diachi;
    data['status'] = status;
    data['danhmuc'] = danhmuc;
    data['nguoidung'] = nguoidung;
    data['imageArr'] = imageArr;
    return data;
  }
}
