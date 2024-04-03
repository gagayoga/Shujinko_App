import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shujinko_app/app/data/model/response_book_new.dart';
import 'package:shujinko_app/app/data/model/response_popular_book.dart';

import '../../../data/constant/endpoint.dart';
import '../../../data/model/response_kategori.dart';
import '../../../data/provider/api_provider.dart';

class HomeController extends GetxController with StateMixin {
  var newBooks = RxList<DataBookNew>();
  var popularBooks = RxList<DataPopularBook>();
  var kategoriBuku = RxList<DataKategori>();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());

    try {
      final responseNew = await ApiProvider.instance().get(Endpoint.bukuNew);
      final responsePopular = await ApiProvider.instance().get(Endpoint.bukuPopular);
      final responseKategori = await ApiProvider.instance().get(Endpoint.kategoriBuku);

      if (responseNew.statusCode == 200 && responsePopular.statusCode == 200) {
        final ResponseBookNew responseBukuNew = ResponseBookNew.fromJson(responseNew.data);
        final ResponsePopularBook responseBukuPopular = ResponsePopularBook.fromJson(responsePopular.data);
        final ResponseKategori responseKategoriBuku = ResponseKategori.fromJson(responseKategori.data);

        if (responseBukuNew.data!.isEmpty && responseBukuPopular.data!.isEmpty) {
          newBooks.clear();
          popularBooks.clear();
          kategoriBuku.clear();
          change(null, status: RxStatus.empty());
        } else {
          newBooks.assignAll(responseBukuNew.data!);
          popularBooks.assignAll(responseBukuPopular.data!);
          kategoriBuku.assignAll(responseKategoriBuku.data!);

          change(null, status: RxStatus.success());
        }
      } else {
        change(null, status: RxStatus.error("Gagal Memanggil Data"));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData != null) {
          final errorMessage = responseData['message'] ?? "Unknown error";
          change(null, status: RxStatus.error(errorMessage));
        }
      } else {
        change(null, status: RxStatus.error(e.message));
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
