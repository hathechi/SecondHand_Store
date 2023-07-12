class DanhMuc {
  int? idDanhmuc;
  String? tenDanhmuc;
  bool? status;

  DanhMuc({this.idDanhmuc, this.tenDanhmuc, this.status});

  DanhMuc.fromJson(Map<String, dynamic> json) {
    idDanhmuc = json['id_danhmuc'];
    tenDanhmuc = json['ten_danhmuc'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_danhmuc'] = idDanhmuc;
    data['ten_danhmuc'] = tenDanhmuc;
    data['status'] = status;
    return data;
  }
}
