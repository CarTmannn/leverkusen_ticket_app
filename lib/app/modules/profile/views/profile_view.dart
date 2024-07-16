import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/app/modules/dump/views/dump_view.dart';
import 'package:ticket_app/app/modules/home/controllers/home_controller.dart';
import 'package:ticket_app/app/modules/home/views/home_view.dart';
import 'package:ticket_app/app/modules/login/controllers/login_controller.dart';
import 'package:ticket_app/app/modules/top_up/controllers/top_up_controller.dart';
import 'package:ticket_app/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final profileController = Get.find<LoginController>();
  final profileController2 = Get.put(TopUpController());
  final profileController3 = Get.put(HomeController());

  String formatCurrency(String value) {
    final formatCurrency = NumberFormat.currency(locale: 'id', symbol: 'Rp');
    return formatCurrency.format(double.parse(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                controller.logout();
              },
              icon: Icon(
                Icons.logout,
                size: 30,
                color: Colors.amber,
              ))
        ],
        backgroundColor: Color(0XFF7c0000),
        elevation: 5,
        automaticallyImplyLeading: false,
        title: Text(
          "PROFILE",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90 * 2 + 45,
                width: 160 * 2 + 80,
                color: Colors.grey,
                child: Image.network(
                  "https://pbs.twimg.com/media/DHxlH7vXYAABC4D.jpg:large",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: 500,
                height: 20,
                color: Color(0XFF7c0000),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Obx(
                () => Center(
                  child: controller.tickets.isEmpty
                      ? Container(
                          height: 300,
                          width: 300,
                          child: LottieBuilder.asset(
                            "assets/lottie/blank.json",
                            fit: BoxFit.cover,
                          ),
                        )
                      : SizedBox(
                          height: 200,
                          width: 400,
                          child: Center(
                            child: ListView.builder(
                              itemCount: controller.tickets.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Row(children: [
                                SizedBox(
                                  width: 22,
                                ),
                                TicketSheet(
                                  customer:
                                      controller.customerId.value.toString(),
                                  date: controller.tickets[index]
                                      ["booking_date"],
                                  ticketId: controller.tickets[index]
                                          ["ticket_id"]
                                      .toString(),
                                  seat: controller.tickets[index]["seat_id"],
                                  opponent:
                                      profileController3.nearestMatch["link"],
                                ),
                                SizedBox(
                                  width: 20,
                                )
                              ]),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.2,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                width: 500,
                height: 700,
                decoration: BoxDecoration(
                  color: Color(0XFF7c0000),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, top: 20, bottom: 60),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color(0XFF7c0000)),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: GetBuilder<ProfileController>(
                                    init: ProfileController(),
                                    builder: (controller) {
                                      return GestureDetector(
                                        onVerticalDragUpdate: (details) {
                                          double newPositionY =
                                              controller.positionY +
                                                  details.delta.dy;
                                          controller
                                              .updatePosition(newPositionY);
                                        },
                                        child: Container(
                                          height: 125,
                                          width: 125,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.amber),
                                          child: controller.photo == ""
                                              ? Image.network(
                                                  "https://cdn.idntimes.com/content-images/community/2023/05/5f6fa1a35b9240668d0824540ede58bb-241112060-223804176378243-6627428181004591071-n-b9c7fac7543a061202919ad3b742ab1f-993bfed02ebac1febcd7afa806ae76bb.jpg",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  controller.photo.value
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Name",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            SizedBox(height: 10),
                            Text(
                              controller.name.value,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 340,
                              height: 0.5,
                              color: Colors.black,
                            ),
                            SizedBox(height: 10),
                            Text("Email",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            SizedBox(height: 10),
                            Text(
                              controller.email.value,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 340,
                              height: 0.5,
                              color: Colors.black,
                            ),
                            SizedBox(height: 20),
                            Text("Gender",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            SizedBox(height: 10),
                            Text(
                              controller.gender.value,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 340,
                              height: 0.5,
                              color: Colors.black,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Date of Birth",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            Text(
                              controller.birthDate.value,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 340,
                              height: 0.5,
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Wallet",
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Obx(
                                  () => controller.isLoading.value
                                      ? CircularProgressIndicator(
                                          backgroundColor: Colors.red,
                                        )
                                      : Text(
                                          formatCurrency(controller.saldo.value
                                              .toString()),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.TOP_UP);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 90,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "TOP UP",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.amber,
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    Colors.red.withOpacity(0.3),
                                                spreadRadius: 3,
                                                blurRadius: 3,
                                                offset: Offset(0, 3))
                                          ]),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
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
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.SCHEDULE);
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
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.PROFILE);
                      },
                      child: NavBar(
                        iconData: Icons.person,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TicketSheet extends StatelessWidget {
  TicketSheet({
    super.key,
    required this.date,
    required this.ticketId,
    required this.customer,
    required this.seat,
    required this.opponent,
  });

  final date;
  final ticketId;
  final customer;
  final seat;
  final opponent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: 350,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0XFF0a2472),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 180,
                    width: 350 * 0.2,
                    color: Colors.amber,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Image.asset(
                                "assets/image/leverkusen.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "VS",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Image.network(
                                opponent,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 180,
                    width: 350 * 0.8,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "TICKET",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          date,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "16:00",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: [
                                Container(
                                  height: 25,
                                  width: 50,
                                  color: Colors.black,
                                  child: Center(
                                      child: Text(
                                    "Ticket",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      ticketId,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 25,
                                  width: 50,
                                  color: Colors.black,
                                  child: Center(
                                      child: Text(
                                    "Customer",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      customer,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 25,
                                  width: 50,
                                  color: Colors.black,
                                  child: Center(
                                      child: Text(
                                    "Seat",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      seat,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
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
            ),
            Positioned(
              left: 45,
              child: Container(
                width: 50,
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100)),
                    color: Colors.white),
              ),
            ),
            Positioned(
              left: 45,
              bottom: 0,
              child: Container(
                width: 50,
                height: 25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(100)),
                    color: Colors.white),
              ),
            ),
            Shimmer(
              child: Container(width: 350, height: 180, color: Colors.black),
              gradient: LinearGradient(stops: [
                0.45,
                0.5,
                0.55
              ], colors: [
                Colors.amber.withOpacity(0),
                Colors.amber.withOpacity(0.5),
                Colors.amber.withOpacity(0),
              ]),
            )
          ],
        ),
      ],
    );
  }
}
