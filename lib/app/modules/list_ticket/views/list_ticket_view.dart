import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:ticket_app/app/modules/home/controllers/home_controller.dart';
import 'package:ticket_app/app/modules/home/views/home_view.dart';
import 'package:ticket_app/app/modules/login/controllers/login_controller.dart';
import 'package:ticket_app/app/routes/app_pages.dart';

import '../controllers/list_ticket_controller.dart';

class ListTicketView extends GetView<ListTicketController> {
  ListTicketView({Key? key}) : super(key: key);
  final listTicketController = Get.put(HomeController());
  final listTicketController2 = Get.put(LoginController());
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF7c0b0d),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Get.toNamed(Routes.BOOKING);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
        ),
        backgroundColor: Color(0XFF7c0b0d),
        title: Text(
          'VIP SEAT',
          style: TextStyle(
              color: Colors.amber, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Only ticket for the next home game available",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: NextFixture(
                  date: listTicketController.nearestMatch["formattedTimeStart"]
                      .substring(0, 21)
                      .toString(),
                  logo: listTicketController.nearestMatch["link"],
                  clubName: listTicketController.nearestMatch["against"],
                  timeStart: listTicketController
                      .nearestMatch["formattedTimeStart"]
                      .substring(21),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Seat",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Ticket",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Price",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 30,
                    width: 50,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: controller.tickets.isEmpty
                    ? Center(
                        child: Text("No Tickets Available"),
                      )
                    : ListView.builder(
                        itemCount: controller.tickets.length,
                        itemBuilder: (context, index) {
                          var ticket = controller.tickets[index];
                          return Column(
                            children: [
                              Container(
                                height: 80,
                                width: 500,
                                color: Color(0XFF7c0b0d),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Text(
                                        "${ticket.seatId}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${ticket.ticketId}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${ticket.price}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.selectedSeatId.value =
                                              ticket.seatId;
                                          controller.selectedTicketId.value =
                                              ticket.ticketId;
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext) {
                                              return AlertDialog(
                                                backgroundColor: Colors.amber,
                                                title: Center(
                                                  child: Text(
                                                    "Please confirm your order",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                content: Container(
                                                  width: 250,
                                                  height: 260,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Full Name:",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        listTicketController2
                                                            .name.value,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Email:",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        listTicketController2
                                                            .email.value,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Ticket:",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          "${controller.selectedTicketId.value}"),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Seat:",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          "${controller.selectedSeatId.value}"),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          GestureDetector(
                                                            onTap: () {
                                                              controller.paymentGateway(
                                                                  listTicketController2
                                                                      .customerId
                                                                      .value,
                                                                  controller
                                                                      .selectedTicketId
                                                                      .value,
                                                                  controller
                                                                      .selectedSeatId
                                                                      .value,
                                                                  dateTime
                                                                      .toIso8601String(),
                                                                  "success",
                                                                  ticket.price);
                                                            },
                                                            child: Container(
                                                              width: 50,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: Colors
                                                                      .black),
                                                              child: Center(
                                                                child: Text(
                                                                  "Pay",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.amber,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Buy",
                                              style: TextStyle(
                                                color: Color(0XFF7c0b0d),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 0.7,
                                color: Colors.black,
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          );
        }
      }),
    );
  }
}
