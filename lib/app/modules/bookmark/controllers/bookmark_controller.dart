import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/customTextField.dart';
import '../../../data/constant/endpoint.dart';
import '../../../data/model/bookmarknhistory/response_history_peminjaman.dart';
import '../../../data/model/bookmarknhistory/response_koleksi_book.dart';
import '../../../data/provider/api_provider.dart';
import '../../../data/provider/storage_provider.dart';

class BookmarkController extends GetxController with StateMixin {
  var koleksiBook = RxList<DataKoleksiBook>();
  var historyPeminjaman = RxList<DataHistory>();
  String idUser = StorageProvider.read(StorageKey.idUser);

  var loadingPinjam = false.obs;

  // Post Ulasan
  double ratingBuku = 0;
  final loadingUlasan = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController ulasanController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getDataKoleksi();
    getDataPeminjaman();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getDataPeminjaman() async {
    change(null, status: RxStatus.loading());

    try {
      final responseHistoryPeminjaman = await ApiProvider.instance()
          .get('${Endpoint.historyPeminjaman}/$idUser');

      if (responseHistoryPeminjaman.statusCode == 200) {
        final ResponseHistoryPeminjaman responseHistory =
            ResponseHistoryPeminjaman.fromJson(responseHistoryPeminjaman.data);

        if (responseHistory.data!.isEmpty) {
          historyPeminjaman.clear();
          change(null, status: RxStatus.empty());
        } else {
          historyPeminjaman.assignAll(responseHistory.data!);
          change(null, status: RxStatus.success());
        }
      } else {
        change(null, status: RxStatus.error("Gagal Memanggil Data"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData != null) {
          final errorMessage = responseData['Message'] ?? "Unknown error";
          change(null, status: RxStatus.error(errorMessage));
        }
      } else {
        change(null, status: RxStatus.error(e.message));
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> getDataKoleksi() async {
    change(null, status: RxStatus.loading());

    try {
      final responseKoleksiBuku =
          await ApiProvider.instance().get('${Endpoint.koleksiBuku}/$idUser');

      if (responseKoleksiBuku.statusCode == 200) {
        final ResponseKoleksiBook responseKoleksi =
            ResponseKoleksiBook.fromJson(responseKoleksiBuku.data);

        if (responseKoleksi.data!.isEmpty) {
          koleksiBook.clear();
          change(null, status: RxStatus.empty());
        } else {
          koleksiBook.assignAll(responseKoleksi.data!);
          change(null, status: RxStatus.success());
        }
      } else {
        change(null, status: RxStatus.error("Gagal Memanggil Data"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData != null) {
          final errorMessage = responseData['Message'] ?? "Unknown error";
          change(null, status: RxStatus.error(errorMessage));
        }
      } else {
        change(null, status: RxStatus.error(e.message));
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  // View Post Ulasan Buku
  Future<void> kontenBeriUlasan(String idBuku, String namaBuku) async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: GoogleFonts.inriaSans(
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
            color: const Color(0xFFEA1818),
          ),
          backgroundColor: const Color(0xFF03010E),
          title: Text(
            'Berikan Ulasan Buku',
            style: GoogleFonts.inriaSans(
              fontWeight: FontWeight.w800,
              fontSize: 20.0,
              color: const Color(0xFFEA1818),
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              child: Form(
                key: formKey,
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'Rating Buku',
                      style: GoogleFonts.inriaSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: RatingBar.builder(
                        allowHalfRating: false,
                        itemCount: 5,
                        minRating: 1,
                        initialRating: 5,
                        direction: Axis.horizontal,
                        itemSize: 47,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (double value) {
                          ratingBuku = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Ulasan Buku',
                      style: GoogleFonts.inriaSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: ulasanController,
                      hinText: 'Ulasan Buku',
                      obsureText: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Pleasse input ulasan buku';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: MediaQuery.of(Get.context!).size.width,
                  height: 50,
                  child: TextButton(
                    autofocus: true,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFEA1818),
                      animationDuration: const Duration(milliseconds: 300),
                    ),
                    onPressed: () {
                      postUlasanBuku(idBuku, namaBuku);
                      Navigator.of(Get.context!).pop();
                    },
                    child: Text(
                      'Simpan Ulasan Buku',
                      style: GoogleFonts.inriaSans(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  postUlasanBuku(String buku, String namaBuku) async {
    loadingUlasan(true);
    try {
      FocusScope.of(Get.context!).unfocus();
      formKey.currentState?.save();
      if (formKey.currentState!.validate()) {
        int ratingBukuInt = ratingBuku.round();
        final response = await ApiProvider.instance().post(Endpoint.ulasanBuku,
            data: dio.FormData.fromMap({
              "Rating": ratingBukuInt,
              "BukuID": buku,
              "Ulasan": ulasanController.text.toString()
            }));
        if (response.statusCode == 201) {
          _showMyDialog(() {
            Navigator.of(Get.context!).pop();
          }, "Pemberitahuan", "Ulasan Buku $namaBuku berhasil di simpan", "Ok");
          ulasanController.text = '';
        } else {
          _showMyDialog(() {
            Navigator.pop(Get.context!, 'OK');
          }, "Pemberitahuan", "Ulasan Gagal disimpan, Silakan coba kembali",
              "Ok");
        }
      }
      loadingUlasan(false);
    } on dio.DioException catch (e) {
      loadingUlasan(false);
      if (e.response != null) {
        if (e.response?.data != null) {
          _showMyDialog(() {
            Navigator.pop(Get.context!, 'OK');
          }, "Pemberitahuan", "${e.response?.data['Message']}", "Ok");
        }
      } else {
        _showMyDialog(
          () {
            Navigator.pop(Get.context!, 'OK');
          },
          "Pemberitahuan",
          e.message ?? "",
          "OK",
        );
      }
    } catch (e) {
      loadingUlasan(false);
      _showMyDialog(
        () {
          Navigator.pop(Get.context!, 'OK');
        },
        "Error",
        e.toString(),
        "OK",
      );
    }
  }

  updatePeminjaman(String peminjamanID, String asal) async {
    loadingPinjam(true);
    try {
      FocusScope.of(Get.context!).unfocus();
      var response;
      if (asal == "booking") {
        response = await ApiProvider.instance()
            .patch('${Endpoint.updatePeminjaman}booking/$peminjamanID');
      } else {
        response = await ApiProvider.instance()
            .patch('${Endpoint.updatePeminjaman}$peminjamanID');
      }

      if (response.statusCode == 200) {
        if (asal == 'booking') {
          _showMyDialog(
                () {
              Navigator.pop(Get.context!, 'OK');
            },
            "Berhasil",
            "Peminjaman berhasil diperbarui",
            "Oke",
          );
          getDataPeminjaman();
        } else {
          _showMyDialog(
                () {
              Navigator.pop(Get.context!, 'OK');
            },
            "Berhasil",
            "Peminjaman buku berhasil dikembalikan",
            "Oke",
          );
        }
        getDataPeminjaman();
      } else {
        _showMyDialog(
              () {
            Navigator.pop(Get.context!, 'OK');
          },
          "Pemberitahuan",
          "Buku gagal diupdate, silakan coba kembali",
          "Ok",
        );
      }
      loadingUlasan(false);
    } on dio.DioException catch (e) {
      loadingUlasan(false);
      if (e.response != null) {
        if (e.response?.data != null) {}
      } else {
        _showMyDialog(
          () {
            Navigator.pop(Get.context!, 'OK');
          },
          "Pemberitahuan",
          e.message ?? "",
          "OK",
        );
      }
    } catch (e) {
      loadingPinjam(false);
      _showMyDialog(
        () {
          Navigator.pop(Get.context!, 'OK');
        },
        "Error",
        e.toString(),
        "OK",
      );
    }
  }

  Future<void> showConfirmPeminjaman(String idPeminjaman, String asal) async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: GoogleFonts.inriaSans(
            fontWeight: FontWeight.w800,
            fontSize: 20.0,
            color: const Color(0xFFEA1818),
          ),
          backgroundColor: const Color(0xFF03010E),
          title: Text(
            'Konfirmasi Peminjaman',
            style: GoogleFonts.inriaSans(
              fontWeight: FontWeight.w800,
              fontSize: 20.0,
              color: const Color(0xFFEA1818),
            ),
          ),

          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Apakah buku yang Anda pinjam, sudah Anda ambil di Perpustakaan?",
                    style: GoogleFonts.inriaSans(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 26
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width,
                        height: 45,
                        child: TextButton(
                          autofocus: true,
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF1B1B1D),
                            animationDuration: const Duration(milliseconds: 300),
                          ),
                          onPressed: (){
                            Navigator.pop(Get.context!, 'OK');
                          },
                          child: Text(
                            'Belum',
                            style: GoogleFonts.inriaSans(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width,
                        height: 45,
                        child: TextButton(
                          autofocus: true,
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFEA1818),
                            animationDuration: const Duration(milliseconds: 300),
                          ),
                          onPressed: (){
                            Navigator.pop(Get.context!, 'OK');
                            updatePeminjaman(idPeminjaman, asal);
                          },
                          child: Text(
                            "Sudah",
                            style: GoogleFonts.inriaSans(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(final onPressed, String judul, String deskripsi,
      String nameButton) async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF03010E),
          title: Text(
            'Shujinko App',
            style: GoogleFonts.inriaSans(
              fontWeight: FontWeight.w800,
              fontSize: 20.0,
              color: const Color(0xFFEA1818),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  judul,
                  style: GoogleFonts.inriaSans(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 18.0),
                ),
                Text(
                  deskripsi,
                  style: GoogleFonts.inriaSans(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              autofocus: true,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEA1818),
                animationDuration: const Duration(milliseconds: 300),
              ),
              onPressed: onPressed,
              child: Text(
                nameButton,
                style: GoogleFonts.inriaSans(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
