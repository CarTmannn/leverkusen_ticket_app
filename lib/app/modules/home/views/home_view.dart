import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ticket_app/app/modules/booking/views/booking_view.dart';
import 'package:ticket_app/app/modules/login/controllers/login_controller.dart';
import 'package:ticket_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:ticket_app/app/modules/schedule/views/schedule_view.dart';
import 'package:ticket_app/app/routes/app_pages.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final homeController = Get.put(HomeController());
  final homeController2 = Get.put(ProfileController());
  final homeController3 = Get.put(LoginController());

  final List<String> imageString = [
    "https://assets.goal.com/images/v3/blt7d34e4e009b71601/Bayer_Leverkusen_Bundesliga_winners.jpg?auto=webp&format=pjpg&width=3840&quality=60",
    "https://i0.web.de/image/712/39544712,pd=2/bayer-leverkusen-jubelt.jpg",
    "https://wgnradio.com/wp-content/uploads/sites/6/2024/04/661c1b3e343635.34228192.jpeg?w=2560&h=1440&crop=1",
    "https://i2-prod.football.london/incoming/article28908845.ece/ALTERNATES/s1200/0_XABI-ALONSO-LIVERPOOL.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF7c0b0d),
      appBar: AppBar(
        backgroundColor: Color(0XFF750000),
        toolbarHeight: 70,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Image.asset(
              "assets/image/leverkusen.png",
              fit: BoxFit.contain,
              width: 70,
              height: 70,
            )),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Obx(() {
              if (homeController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 320,
                        height: 205,
                        child: CarouselSlider(
                          items: imageString.map((url) {
                            return Image.network(
                              url,
                              fit: BoxFit.fill,
                            );
                          }).toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            viewportFraction: 1,
                            enableInfiniteScroll: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "NEXT FIXTURE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () {
                          if (controller.nearestMatch.isEmpty) {
                            return CircularProgressIndicator();
                          } else {
                            return NextFixture(
                              date: homeController
                                  .nearestMatch["formattedTimeStart"]
                                  .substring(0, 21)
                                  .toString(),
                              logo: homeController.nearestMatch["link"],
                              clubName: homeController.nearestMatch["against"],
                              timeStart: homeController
                                  .nearestMatch["formattedTimeStart"]
                                  .substring(21),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "SQUAD",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 540,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.players.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: PlayerInfo(
                              name: controller.players[index]["name"],
                              birthDate: controller.players[index]["birthdate"],
                              position: controller.players[index]["position"],
                              height: controller.players[index]["height"],
                              nationality: controller.players[index]
                                  ["nationality"],
                              goal: controller.players[index]["goal"],
                              assist: controller.players[index]["assist"],
                              link: controller.players[index]["link"],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                      )
                    ],
                  ),
                );
              }
            }),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
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
                    NavBar(
                      iconData: Icons.home_filled,
                      color: Colors.amber,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.SCHEDULE,
                        );
                      },
                      child: NavBar(
                        iconData: Icons.sports_soccer,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.BOOKING);
                      },
                      child: NavBar(
                          iconData: Icons.card_membership_sharp,
                          color: Colors.white),
                    ),
                    GestureDetector(
                        onTap: () async {
                          await homeController2
                              .getTicket(homeController2.customerId.value);
                          await homeController2
                              .getSaldo(homeController2.customerId.value);
                          Get.toNamed(Routes.PROFILE);
                        },
                        child: NavBar(
                            iconData: Icons.person, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  NavBar({super.key, required this.iconData, required this.color});
  Color color;
  final iconData;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: color,
      size: 35,
    );
  }
}

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({
    super.key,
    required this.name,
    required this.birthDate,
    required this.position,
    required this.height,
    required this.nationality,
    required this.goal,
    required this.assist,
    required this.link,
  });

  final name;
  final birthDate;
  final position;
  final height;
  final nationality;
  final goal;
  final assist;
  final link;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: [
            Container(
              width: 360,
              height: 520,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 3))
                  ]),
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 180,
                      width: 360,
                    ),
                    Text(
                      "Personal details",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Nationality",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                nationality,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Date of Birth",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                birthDate,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Height",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                height.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Bundesliga Record",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Goals",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                goal.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Assists",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                assist.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 180,
          width: 360,
          child: Stack(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    child: Image.asset(
                      "assets/image/red.jpg",
                      fit: BoxFit.fill,
                      width: 520,
                    ),
                  ),
                  Center(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 170,
                          height: 180,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    position,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Stack(
                              children: <Widget>[
                                Positioned(
                                    left: 0,
                                    child: Container(
                                      height: 45,
                                      width: 50,
                                      child: Image.asset(
                                          "assets/image/bundes.png"),
                                    )),
                                Container(
                                  width: 180,
                                  height: 180,
                                  child: Center(
                                    child: Image.network(link),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class NextFixture extends StatelessWidget {
  const NextFixture(
      {super.key,
      required this.date,
      required this.logo,
      required this.clubName,
      required this.timeStart});

  final String date;
  final String timeStart;
  final String logo;
  final String clubName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            width: 360,
            height: 180,
            decoration: BoxDecoration(
                color: Color(0XFFf8cb3a),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, 2))
                ]),
            child: Stack(children: <Widget>[
              Container(
                height: 180,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/image/yellow.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    timeStart,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
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
                                width: 100,
                                height: 100,
                                child: Image.asset(
                                    "assets/image/leverkusen.png",
                                    fit: BoxFit.contain),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "VS",
                        style: TextStyle(
                            color: Colors.black,
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
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  logo,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
