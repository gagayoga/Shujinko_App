import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shujinko_app/app/data/model/response_search_book.dart';

import '../../../data/constant/endpoint.dart';
import '../../../data/model/response_book.dart';
import '../../../data/model/response_book.dart';
import '../../../data/provider/api_provider.dart';

class BukuController extends GetxController with StateMixin{

  var dataBook = Rxn<List<DataBook>>();
  var searchBook = Rxn<List<DataSearch>>();


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
          dataBook(responseDataBook.data!);
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
    change(null, status: RxStatus.loading());

    try {
      final responseSearchBook = await ApiProvider.instance()
          .get('${Endpoint.searchBook}?keyword=$keyword');

      if (responseSearchBook.statusCode == 200) {
        final ResponseSearchBook responseDataSearchBook =
        ResponseSearchBook.fromJson(responseSearchBook.data);

        if (responseDataSearchBook.data!.isEmpty) {
          change(null, status: RxStatus.empty());
        } else {
          searchBook(responseDataSearchBook.data!);
          change(null, status: RxStatus.success());
        }
      } else {
        change(null, status: RxStatus.error("Gagal Memanggil Data"));
      }
    } on DioError catch (e) {
      handleError(e);
    } catch (e) {
      handleError(e);
    }
  }

  void handleError(dynamic e) {
    if (e is DioError) {
      if (e.response != null) {
        final responseData = e.response?.data;
        if (responseData != null) {
          final errorMessage = responseData['message'] ?? "Unknown error";
          change(null, status: RxStatus.error(errorMessage));
        }
      } else {
        change(null, status: RxStatus.error(e.message));
      }
    } else {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
}
