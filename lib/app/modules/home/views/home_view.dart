import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/provider/storage_provider.dart';
import '../../../routes/app_pages.dart';
import '../../layout/controllers/layout_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double barHeight = MediaQuery.of(context).padding.top;
    double bodyHeight = height - barHeight;

    // const Color colorText = Color(0xFFEA1818);
    const Color background = Color(0xFF03010E);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: background,
      statusBarIconBrightness: Brightness.light,// Change this color as needed
    ));

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async{
            await controller.getData();
          },
          child: Container(
            width: width,
            height: bodyHeight,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/bg_home.png'),
                  fit: BoxFit.cover,
                ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [

                    kontenProfile(),

                    Padding(
                      padding: EdgeInsets.only(top: height * 0.005),
                      child: kontenText(
                        "Selamat datang di Shujinko App mulai lah mencari buku favorit anda!!!",
                      ),
                    ),

                    SizedBox(
                      height: height * 0.025,
                    ),

                    sectionImage(),

                    Padding(
                      padding: EdgeInsets.only(top: height * 0.030),
                      child: SizedBox(
                        width: double.infinity,
                        child: kontenBukuPopular(),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.035,
                    ),

                    sectionKategoriBuku(),

                    SizedBox(
                      height: height * 0.035,
                    ),

                    kontenBukuTerbaru(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget kontenProfile(){

    // ambil data username dari storage provider
    String usernameUser = "Hallo ${StorageProvider.read(StorageKey.username)}";

    // Ucapan selamat pagi sesuai jam
    var jam = DateTime.now().hour;
    String ucapan;

    if(jam >= 1 && jam <= 11){
      ucapan = "OHAYÔ GOZAIMASU";
    }else if(jam >= 11 && jam < 15){
      ucapan = "KONNICHIWA✨";
    }else if(jam >= 15 && jam < 18){
      ucapan = "KONNICHIWA☀️";
    }else {
      ucapan = "KONBANWA🌙";
    }


    return SizedBox(
      width: double.infinity,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'lib/assets/images/fotoprofile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    usernameUser,
                    style: GoogleFonts.inriaSans(
                      fontSize: 16.0,
                      color: const Color(0xFFEA1818),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  AutoSizeText(
                    ucapan,
                    style: GoogleFonts.inriaSans(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              )
            ],
          ),

          InkWell(
            onTap: (){

            },
            child: const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
              size: 28,
            ),
          )
        ],
      ),
    );
  }

  Widget kontenText(String ucapanUser){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0XFF1B1B1D)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: AutoSizeText(
          ucapanUser,
          minFontSize: 18,
          maxLines: 2,
          maxFontSize: 20,
          style: GoogleFonts.inriaSans(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget kontenBukuPopular(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Buku Terpopuler",
          maxLines: 1,
          style: GoogleFonts.inriaSans(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GetBuilder<HomeController>(
          builder: (controller) {
            if (controller.popularBooks.isNull) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA1818)),
                ),
              );
            } else if (controller.popularBooks.value == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA1818)),
                ),
              );
            } else {
              return SizedBox(
                height: 205,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.popularBooks.value!.length,
                        itemBuilder: (context, index) {
                          var buku = controller.popularBooks.value![index];
                          return InkWell(
                            onTap: () {
                              Get.toNamed(Routes.DETAILBUKU,
                                parameters: {
                                  'id': (buku.bukuID ?? 0).toString(),
                                  'judul': (buku.judul!).toString()
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: 123, // Sesuaikan lebar gambar sesuai kebutuhan Anda
                                        height: 175, // Sesuaikan tinggi gambar sesuai kebutuhan Anda
                                        child: AspectRatio(
                                          aspectRatio: 4 / 5,
                                          child: Image.network(
                                            buku.coverBuku.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEA1818).withOpacity(0.9),
                                          ),
                                          child: Center(
                                            child: Text(
                                              (index + 1).toString(), // Nomor urut buku
                                              style: GoogleFonts.inriaSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Positioned(
                                        left: 0,
                                        bottom: -0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.80)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Center(
                                              child: RatingBarIndicator(
                                                rating: buku.rating!,
                                                itemCount: 5,
                                                direction: Axis.horizontal,
                                                itemSize: 15,
                                                itemBuilder: (context, _) => const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  FittedBox(
                                    child: Text(
                                      buku.judul!,
                                      style: GoogleFonts.inriaSans(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 14.0
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      InkWell(
                        onTap: () {
                        },
                        child: Container(
                          width: 120,
                          height: 205,
                          color: const Color(0XFF1B1B1D),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Lihat Semuanya",
                                style: GoogleFonts.inriaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget sectionKategoriBuku() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Kategori Buku",
          maxLines: 1,
          style: GoogleFonts.inriaSans(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        GetBuilder<HomeController>(
          builder: (controller) {
            if (controller.kategoriBuku.isNull || controller.kategoriBuku.value == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA1818)),
                ),
              );
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150, // Lebar maksimum setiap item dalam grid
                  mainAxisSpacing: 10, // Spasi antar item di dalam grid
                  childAspectRatio: 5 / 1.5, // Rasio lebar dan tinggi setiap item dalam grid
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.kategoriBuku.value!.length,
                itemBuilder: (context, index) {
                  var buku = controller.kategoriBuku.value![index];
                  return SizedBox(
                    width: 150, // Lebar item dalam grid
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0XFF1B1B1D),
                          shape: RoundedRectangleBorder( // Membuat tombol menjadi kotak
                            borderRadius: BorderRadius.circular(5), // Menentukan sudut kotak
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            buku.namaKategori!,
                            style: GoogleFonts.inriaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget kontenBukuTerbaru() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Buku Terbaru",
          maxLines: 1,
          style: GoogleFonts.inriaSans(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GetBuilder<HomeController>(
          builder: (controller) {
            if (controller.newBooks.isNull) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA1818)),
                ),
              );
            } else if (controller.newBooks.value == null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEA1818)),
                ),
              );
            } else {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 3 / 6,
                ),
                itemCount: controller.newBooks.value!.length,
                itemBuilder: (context, index) {
                  var buku = controller.newBooks.value![index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.DETAILBUKU,
                        parameters: {
                          'id': (buku.bukuID ?? 0).toString(),
                          'judul': (buku.judulBuku!).toString()
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 10,
                          child: SizedBox(
                            height: 175, // Tetapkan tinggi container
                            child: Image.network(
                              buku.coverBuku.toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                            child: Text(
                              buku.judulBuku!,
                              style: GoogleFonts.inriaSans(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget sectionImage(){
    // Size
    double width = MediaQuery.of(Get.context!).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: width,
        height: 115,
        decoration: const BoxDecoration(
          image:  DecorationImage(
              image: AssetImage(
                'lib/assets/images/konten_home.png',
              ),
              fit: BoxFit.cover
          ),
        ),
      
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temukan Ribuan Buku',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 26.0
                      ),
                    ),
                    Text(
                      'Dengan sekali klik',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 14.0
                      ),
                    )
                  ],
                ),
              ),
      
              InkWell(
                onTap: () {
                  Get.find<LayoutController>().changeTabIndex(1);
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
