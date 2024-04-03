import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shujinko_app/app/data/provider/storage_provider.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double barHeight = MediaQuery.of(context).padding.top;
    double bodyHeight = height - barHeight;

    var usernameUser = StorageProvider.read(StorageKey.username);
    var emailUser = StorageProvider.read(StorageKey.email);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: bodyHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'lib/assets/images/bg_history.png',
              )
            )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Stack(
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    SizedBox(
                      height: height * 0.080,
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          'lib/assets/images/profile.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.025,
                    ),

                    SizedBox(
                      width: 120,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9).withOpacity(0.20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: FittedBox(
                          child: Text(
                            "Edit Profile",
                            style: GoogleFonts.inriaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.025,
                    ),

                    Column(
                      children: [
                        kontenProfileUser(
                            'Username : $usernameUser'
                        ),

                        kontenProfileUser(
                            'Email : $emailUser'
                        ),

                        kontenProfileUser(
                            'Bio : Bismillah 2024 di jepang'
                        ),
                      ],
                    ),
                  ],
                ),

                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget kontenProfileUser(String dataUser){
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dataUser,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inriaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Divider(
            height: 1,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
