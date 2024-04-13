import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shujinko_app/app/data/model/buku/response_search_book.dart';

import '../../../data/constant/endpoint.dart';
import '../../../data/model/buku/response_book.dart';
import '../../../data/provider/api_provider.dart';

class BukuController extends GetxController with StateMixin{

  var dataBook = RxList<DataBook>();
  var searchBook = RxList<DataSearch>();


  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());

    try {

      final responseBook = await ApiProvider.instance().get(
          Endpoint.buku);

      if (responseBook.statusCode == 200) {
        final ResponseBook responseDataBook = ResponseBook.fromJson(responseBook.data);

        if (responseDataBook.data!.isEmpty) {
          change(null, status: RxStatus.empty());
        } else {
          dataBook(responseDataBook.data);
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

  Future<void> getDataSearchBook(String keyword) async {
    try {
      change(null, status: RxStatus.loading()); // Ubah status menjadi loading

      final response = await ApiProvider.instance().get('${Endpoint.searchBook}?keyword=$keyword');

      if (response.statusCode == 200) {
        final responseData = ResponseSearchBook.fromJson(response.data);

        if (responseData.data!.isEmpty) {
          searchBook.clear();
          change(null, status: RxStatus.empty());
        } else {
          searchBook.assignAll(responseData.data!);
          change(null, status: RxStatus.success());
        }
      } else {
        // Tangani kasus jika status kode respons bukan 200
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

}
