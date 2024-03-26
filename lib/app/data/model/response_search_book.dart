/// Status : 200
/// Message : "Berhasil menampilkan data pencarian buku"
/// data : [{"KategoriBuku":"Novel Non Fiksi","Buku":[{"BukuID":1,"CoverBuku":"http://192.168.43.21:8000/storage/images/coverbook/Buya Hamka.png","Judul":"Buya Hamka","Penulis":"A Fuadi","Penerbit":"Gramedia Center","TahunTerbit":"2013","JumlahHalaman":"438","Rating":0,"Total_ulasan":0,"JumlahRating":0,"JumlahPeminjam":0}]}]

class ResponseSearchBook {
  ResponseSearchBook({
      this.status, 
      this.message, 
      this.data,});

  ResponseSearchBook.fromJson(dynamic json) {
    status = json['Status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataSearch.fromJson(v));
      });
    }
  }
  int? status;
  String? message;
  List<DataSearch>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = status;
    map['Message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// KategoriBuku : "Novel Non Fiksi"
/// Buku : [{"BukuID":1,"CoverBuku":"http://192.168.43.21:8000/storage/images/coverbook/Buya Hamka.png","Judul":"Buya Hamka","Penulis":"A Fuadi","Penerbit":"Gramedia Center","TahunTerbit":"2013","JumlahHalaman":"438","Rating":0,"Total_ulasan":0,"JumlahRating":0,"JumlahPeminjam":0}]

class DataSearch {
  DataSearch({
      this.kategoriBuku, 
      this.buku,});

  DataSearch.fromJson(dynamic json) {
    kategoriBuku = json['KategoriBuku'];
    if (json['Buku'] != null) {
      buku = [];
      json['Buku'].forEach((v) {
        buku?.add(Buku.fromJson(v));
      });
    }
  }
  String? kategoriBuku;
  List<Buku>? buku;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['KategoriBuku'] = kategoriBuku;
    if (buku != null) {
      map['Buku'] = buku?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// BukuID : 1
/// CoverBuku : "http://192.168.43.21:8000/storage/images/coverbook/Buya Hamka.png"
/// Judul : "Buya Hamka"
/// Penulis : "A Fuadi"
/// Penerbit : "Gramedia Center"
/// TahunTerbit : "2013"
/// JumlahHalaman : "438"
/// Rating : 0
/// Total_ulasan : 0
/// JumlahRating : 0
/// JumlahPeminjam : 0

class Buku {
  Buku({
      this.bukuID, 
      this.coverBuku, 
      this.judul, 
      this.penulis, 
      this.penerbit, 
      this.tahunTerbit, 
      this.jumlahHalaman, 
      this.rating, 
      this.totalUlasan, 
      this.jumlahRating, 
      this.jumlahPeminjam,});

  Buku.fromJson(dynamic json) {
    bukuID = json['BukuID'];
    coverBuku = json['CoverBuku'];
    judul = json['Judul'];
    penulis = json['Penulis'];
    penerbit = json['Penerbit'];
    tahunTerbit = json['TahunTerbit'];
    jumlahHalaman = json['JumlahHalaman'];
    rating = json['Rating']?.toDouble();
    totalUlasan = json['Total_ulasan'];
    jumlahRating = json['JumlahRating'];
    jumlahPeminjam = json['JumlahPeminjam'];
  }
  int? bukuID;
  String? coverBuku;
  String? judul;
  String? penulis;
  String? penerbit;
  String? tahunTerbit;
  String? jumlahHalaman;
  double? rating;
  int? totalUlasan;
  int? jumlahRating;
  int? jumlahPeminjam;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BukuID'] = bukuID;
    map['CoverBuku'] = coverBuku;
    map['Judul'] = judul;
    map['Penulis'] = penulis;
    map['Penerbit'] = penerbit;
    map['TahunTerbit'] = tahunTerbit;
    map['JumlahHalaman'] = jumlahHalaman;
    map['Rating'] = rating;
    map['Total_ulasan'] = totalUlasan;
    map['JumlahRating'] = jumlahRating;
    map['JumlahPeminjam'] = jumlahPeminjam;
    return map;
  }

}