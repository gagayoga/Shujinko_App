import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shujinko_app/app/components/customTextField.dart';
import 'package:shujinko_app/app/data/model/response_book.dart';
import 'package:shujinko_app/app/data/model/response_search_book.dart';
import 'package:shujinko_app/app/routes/app_pages.dart';

import '../controllers/buku_controller.dart';

class BukuView extends GetView<BukuController> {
  const BukuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Change this color as needed
    ));

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/bg_buku.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 100, left: 10, right: 10, bottom: 20),
                child: kontenSemuaBuku(),
              ),
            ),
            Container(
              height: 120,
              color: Colors.black.withOpacity(0.90),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                      child: CustomTextField(
                        controller: controller.searchController,
                        onChanged: (value) {
                          controller.getDataSearchBook(value);
                        },
                        hinText: "Search Book",
                        preficIcon: const Icon(Icons.search_rounded),
                        obsureText: false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kontenSemuaBuku() {
    const Color background = Color(0xFF0C1008);
    const Color borderColor = Color(0xFF424242);

    return Obx(() {
      if (controller.searchBook == null) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA1818)),
          ),
        );
      } else if (controller.searchBook.value == null || controller.searchBook.value!.isEmpty) {
        return Center(
          child: kontenDataBuku(),
        );
      } else {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.searchBook.value!.length,
          itemBuilder: (context, index) {
            var kategori = controller.searchBook.value![index].kategoriBuku;
            var bukuList = controller.searchBook.value![index].buku;
            if (bukuList == null || bukuList.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      kategori!,
                      style: GoogleFonts.inriaSans(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: borderColor,
                          width: 1.3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Belum ada buku dalam kategori ini',
                          style: GoogleFonts.inriaSans(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      kategori!,
                      style: GoogleFonts.inriaSans(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bukuList!.length,
                      itemBuilder: (context, index) {
                        Buku buku = bukuList[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                Routes.DETAILBUKU,
                                parameters: {
                                  'id': (buku.bukuID ?? 0).toString(),
                                  'judul': (buku.judul!).toString(),
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: 125,
                                      height: 175,
                                      child: AspectRatio(
                                        aspectRatio: 4 / 5,
                                        child: Image.network(
                                          buku.coverBuku.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.80),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Center(
                                            child: buku.rating != null &&
                                                    buku.rating! > 0
                                                ? RatingBarIndicator(
                                                    rating: buku.rating!,
                                                    itemCount: 5,
                                                    direction: Axis.horizontal,
                                                    itemSize: 15,
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                  )
                                                : RatingBarIndicator(
                                                    rating: buku.rating!,
                                                    itemCount: 5,
                                                    direction: Axis.horizontal,
                                                    itemSize: 15,
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                FittedBox(
                                  child: Text(
                                    buku.judul!,
                                    style: GoogleFonts.inriaSans(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FittedBox(
                                  child: Text(
                                    "Penulis : ${buku.penulis!}",
                                    style: GoogleFonts.inriaSans(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                FittedBox(
                                  child: Text(
                                    "Penerbit : ${buku.penerbit!}",
                                    style: GoogleFonts.inriaSans(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                FittedBox(
                                  child: Text(
                                    "${buku.jumlahHalaman!} Halaman",
                                    style: GoogleFonts.inriaSans(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                      fontSize: 10.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    });
  }

  Widget kontenDataBuku(){
    const Color background = Color(0xFF0C1008);
    const Color borderColor = Color(0xFF424242);

    return GetBuilder<BukuController>(
        builder: (controller) {
          if (controller.dataBook.isNull) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA1818)),
              ),
            );
          } else if (controller.dataBook.value!.isEmpty) {
            return Center(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: borderColor,
                      width: 1.3,
                    )
                ),
                child: Center(
                  child: Text(
                    'Belum ada data buku yang',
                    style: GoogleFonts.inriaSans(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }else{
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.dataBook.value!.length,
              itemBuilder: (context, index){
                var kategori = controller.dataBook.value![index].kategoriBuku;
                var bukuList = controller.dataBook.value![index].dataBuku;
                if (bukuList == null || bukuList.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          kategori!,
                          style: GoogleFonts.inriaSans(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: borderColor,
                                width: 1.3,
                              )
                          ),
                          child: Center(
                            child: Text(
                              'Belum ada buku dalam kategori ini',
                              style: GoogleFonts.inriaSans(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          kategori!,
                          style: GoogleFonts.inriaSans(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w700
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        height: 260, // Sesuaikan tinggi container sesuai kebutuhan Anda
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bukuList!.length,
                          itemBuilder: (context, index) {
                            DataBuku buku = bukuList![index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: (){
                                  Get.toNamed(Routes.DETAILBUKU,
                                    parameters: {
                                      'id': (buku.bukuID ?? 0).toString(),
                                      'judul': (buku.judul!).toString()
                                    },
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        SizedBox(
                                          width: 125,
                                          height: 175,
                                          child: AspectRatio(
                                            aspectRatio: 4 / 5,
                                            child: Image.network(
                                              buku.coverBuku.toString(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        Positioned(
                                          left: 0,
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.80)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                              child:
                                              Center(
                                                child:
                                                buku.rating != null && buku.rating! > 0
                                                    ? RatingBarIndicator(
                                                  rating: buku.rating!,
                                                  itemCount: 5,
                                                  direction: Axis.horizontal,
                                                  itemSize: 15,
                                                  itemBuilder: (context, _) => const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                )
                                                    : RatingBarIndicator(
                                                  rating: buku.rating!,
                                                  itemCount: 5,
                                                  direction: Axis.horizontal,
                                                  itemSize: 15,
                                                  itemBuilder: (context, _) => const Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    FittedBox(
                                      child: Text(
                                        buku.judul!,
                                        style: GoogleFonts.inriaSans(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 14.0
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    FittedBox(
                                      child: Text(
                                        "Penulis : ${buku.penulis!}",
                                        style: GoogleFonts.inriaSans(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                            fontSize: 10.0
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    FittedBox(
                                      child: Text(
                                        "Penerbit : ${buku.penerbit!}",
                                        style: GoogleFonts.inriaSans(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                            fontSize: 10.0
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    FittedBox(
                                      child: Text(
                                        "${buku.jumlahHalaman!} Halaman",
                                        style: GoogleFonts.inriaSans(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                            fontSize: 10.0
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }
    );
  }
}
