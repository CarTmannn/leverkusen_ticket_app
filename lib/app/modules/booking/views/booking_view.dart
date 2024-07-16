import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ticket_app/app/modules/home/views/home_view.dart';
import 'package:ticket_app/app/modules/list_ticket/controllers/list_ticket_controller.dart';
import 'package:ticket_app/app/modules/login/controllers/login_controller.dart';
import 'package:ticket_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:ticket_app/app/routes/app_pages.dart';

import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  BookingView({Key? key}) : super(key: key);
  final scheduleController = Get.put(ProfileController());
  final scheduleController2 = Get.find<LoginController>();
  final scheduleController3 = Get.put(ProfileController());
  final scheduleController4 = Get.put(ListTicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF7c0b0d),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0XFF7c0b0d),
        title: Text(
          "TICKETS",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Expanded(
        child: Center(
          child: Stack(
            children: [
              ListView(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 315,
                    color: Colors.grey,
                    child: Image.asset("assets/image/BAYARENA.jpg"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await scheduleController
                          .getSaldo(scheduleController2.customerId.value);
                      if (scheduleController.saldo.value < 600000) {
                        showDialog(
                            context: context,
                            builder: (BuildContext) {
                              return AlertDialog(
                                backgroundColor: Colors.grey,
                                content:
                                    Text("PLEASE RECHARGE YOUR WALLET FIRST"),
                              );
                            });
                      } else {
                        Get.toNamed(Routes.LIST_TICKET);
                      }
                    },
                    child: TicketBox(
                      color: Colors.white,
                      seat: "VIP",
                      price: "600.000",
                      buyColor: Colors.amber,
                      status: "buy",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TicketBox(
                    color: Color(0XFF01aef0),
                    seat: "CAT 1",
                    price: "450.000",
                    buyColor: Colors.grey,
                    status: "sold",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TicketBox(
                    color: Color(0XFFd7c7ae),
                    seat: "CAT 2",
                    price: "400.000",
                    buyColor: Colors.grey,
                    status: "sold",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TicketBox(
                    color: Color(0XFFbbd037),
                    seat: "CAT 3",
                    price: "400.000",
                    buyColor: Colors.grey,
                    status: "sold",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TicketBox(
                    color: Color(0XFFd52027),
                    seat: "CAT 4",
                    price: "350.000",
                    buyColor: Colors.grey,
                    status: "sold",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TicketBox(
                    color: Color(0XFFff951f),
                    seat: "CAT 5",
                    price: "200.000",
                    buyColor: Colors.grey,
                    status: "sold",
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
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
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.SCHEDULE);
                        },
                        child: NavBar(
                          iconData: Icons.sports_soccer,
                          color: Colors.white,
                        ),
                      ),
                      NavBar(
                        iconData: Icons.card_membership_sharp,
                        color: Colors.amber,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await scheduleController3
                              .getTicket(scheduleController.customerId.value);
                          await scheduleController
                              .getSaldo(scheduleController.customerId.value);
                          await Get.toNamed(Routes.PROFILE);
                        },
                        child: NavBar(
                          iconData: Icons.person,
                          color: Colors.white,
                        ),
                      ),
                    ],
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

class TicketBox extends StatelessWidget {
  const TicketBox(
      {super.key,
      required this.color,
      required this.seat,
      required this.price,
      required this.buyColor,
      required this.status});

  final color;
  final seat;
  final price;
  final buyColor;
  final status;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(15)),
        ),
        Positioned(
          left: 20,
          child: Container(
            width: 380,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  seat,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  price,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                Container(
                  height: 30,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), color: buyColor),
                  child: Center(
                    child: Text(
                      status,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
