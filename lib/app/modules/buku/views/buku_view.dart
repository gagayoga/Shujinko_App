import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shujinko_app/app/routes/app_pages.dart';

import '../../../components/custom_search_textfield.dart';
import '../../../data/model/buku/response_book.dart';
import '../controllers/buku_controller.dart';

class BukuView extends GetView<BukuController> {
  const BukuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
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
                child: Obx((){
                  if (controller.searchController.text.isEmpty) {
                    return controller.dataBook.isEmpty
                        ? shimmerDataBuku()
                        : kontenDataBuku();
                  } else {
                    return kontenSearchBuku();
                  }
                },
                ),
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
                      child: CustomSearchTextField(
                        keyboardType: TextInputType.text,
                        controller: controller.searchController,
                        onChanged: (value) {
                          // Pembaruan konten saat input berubah
                          if (value.isEmpty) {
                            controller.getData();
                          } else {
                            controller.getDataSearchBook(value);
                          }
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

  Widget kontenSearchBuku() {
    return Obx((){
      if (controller.searchBook.isEmpty) {
        return kontenDataKosong();
      } else {
        return GridView.builder(
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 6 / 8,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.searchBook.length,
          itemBuilder: (context, index) {
            var bukuList = controller.searchBook[index];
            return SizedBox(
              height: 260,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      Routes.DETAILBUKU,
                      parameters: {
                        'id': (bukuList.bukuID ?? 0).toString(),
                        'judul': (bukuList.judul.toString()).toString(),
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 200,
                            child: AspectRatio(
                              aspectRatio: 6 / 7,
                              child: Image.network(
                                bukuList.coverBuku.toString(),
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
                                  child: bukuList.rating != null &&
                                      bukuList.rating! > 0
                                      ? RatingBarIndicator(
                                    rating: bukuList.rating!,
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
                                    rating: 5,
                                    itemCount: 5,
                                    direction: Axis.horizontal,
                                    itemSize: 15,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.white
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          bukuList.judul.toString(),
                          style: GoogleFonts.inriaSans(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }

  Widget kontenDataKosong(){
    // Color
    const Color background = Color(0xFF0C1008);
    const Color borderColor = Color(0xFF424242);

    String keywordBuku = controller.searchController.text.toString();

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
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
              'Buku $keywordBuku tidak ditemukan',
              style: GoogleFonts.inriaSans(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget kontenDataBuku(){
    const Color background = Color(0xFF0C1008);
    const Color borderColor = Color(0xFF424242);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.dataBook.length,
      itemBuilder: (context, index){
        var kategori = controller.dataBook[index].kategoriBuku;
        var bukuList = controller.dataBook[index].dataBuku;
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
                      'Belum ada bukuList dalam kategori ini',
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
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bukuList.length,
                  itemBuilder: (context, index) {
                    DataBuku dataBuku = bukuList[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        onTap: (){
                          Get.toNamed(Routes.DETAILBUKU,
                            parameters: {
                              'id': (dataBuku.bukuID ?? 0).toString(),
                              'judul': (dataBuku.judul!).toString()
                            },
                          );
                        },
                        child: SizedBox(
                          width: 145,
                          height: 220,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    width: 145,
                                    height: 195,
                                    child: AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: Image.network(
                                        dataBuku.coverBuku.toString(),
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
                                          dataBuku.rating != null && dataBuku.rating! > 0
                                              ? RatingBarIndicator(
                                            rating: dataBuku.rating!,
                                            itemCount: 5,
                                            direction: Axis.horizontal,
                                            itemSize: 15,
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          )
                                              : RatingBarIndicator(
                                            rating: 5,
                                            itemCount: 5,
                                            direction: Axis.horizontal,
                                            itemSize: 15,
                                            itemBuilder: (context, _) =>  Icon(
                                              Icons.star,
                                              color: Colors.white.withOpacity(0.40),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  dataBuku.judul!,
                                  style: GoogleFonts.inriaSans(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 16.0
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ],
                          ),
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

  Widget shimmerDataBuku(){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: kontenDataBuku(),
    );
  }
}
