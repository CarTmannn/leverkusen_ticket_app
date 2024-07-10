import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ticket_app/app/modules/home/controllers/home_controller.dart';
import 'package:ticket_app/app/modules/login/controllers/login_controller.dart';
import 'package:ticket_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:ticket_app/app/routes/app_pages.dart';

import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  final scheduleController = Get.put(HomeController());
  final scheduleController2 = Get.put(ProfileController());
  final scheduleController3 = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF7c0b0d),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                "GAMES THIS SEASON",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Obx(() {
              if (scheduleController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else {
                return Expanded(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Obx(
                          () => Container(
                            height: 620,
                            width: 500,
                            child: ListView.builder(
                              itemCount: scheduleController.matches.length,
                              itemBuilder: (context, index) => Column(
                                children: [
                                  schedule(
                                      date: scheduleController.matches[index]
                                          ['formattedTimeStart'],
                                      logo: scheduleController.matches[index]
                                          ["link"],
                                      clubName: scheduleController
                                          .matches[index]["against"]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Center(
                          child: Container(
                            width: 400,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(0.4),
                                  blurRadius: 3,
                                  spreadRadius: 3,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.HOME);
                                    },
                                    child: NavBar(
                                      iconData: Icons.home_filled,
                                      color: Colors.white,
                                    )),
                                NavBar(
                                  iconData: Icons.sports_soccer,
                                  color: Colors.amber,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.BOOKING);
                                  },
                                  child: NavBar(
                                    iconData: Icons.card_membership_sharp,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await scheduleController2.getTicket(
                                        scheduleController3.customerId.value);
                                    await scheduleController2.getSaldo(
                                        scheduleController3.customerId.value);
                                    await Get.toNamed(Routes.PROFILE);
                                  },
                                  child: NavBar(
                                    iconData: Icons.person,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  NavBar({super.key, required this.iconData, required this.color});

  final iconData;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: color,
      size: 35,
    );
  }
}

class schedule extends StatelessWidget {
  const schedule(
      {super.key,
      required this.date,
      required this.logo,
      required this.clubName});

  final String date;
  final String logo;
  final String clubName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 3,
                spreadRadius: 0,
                offset: Offset(0, 2))
          ]),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 25,
          ),
          Text(
            date,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        child: Image.asset("assets/image/leverkusen.png",
                            fit: BoxFit.contain),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Leverkusen",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "VS",
                style: TextStyle(
                    color: Colors.red[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Container(
                width: 100,
                height: 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        child: Image.network(
                          logo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        clubName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
