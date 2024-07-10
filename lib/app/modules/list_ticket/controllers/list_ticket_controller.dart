import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_app/app/modules/home/controllers/home_controller.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:get/get.dart';
import 'package:ticket_app/app/routes/app_pages.dart';

class ListTicketController extends GetxController {
  final isLoading = false.obs;
  final tickets = [].obs;
  final selectedSeatId = ''.obs;
  final selectedTicketId = 0.obs;
  late WebSocketChannel channel;
  HomeController ip = HomeController();

  @override
  void onInit() {
    super.onInit();
    connectWebSocket();
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(Uri.parse('ws://${ip.ip}:8080/ws'));
    channel.stream.listen((message) {
      var jsonData = json.decode(message) as List;
      tickets.value =
          jsonData.map((ticket) => Ticket.fromJson(ticket)).toList();
    });
  }

  /*Future<void> fetchTickets() async {
    final response =
        await http.get(Uri.parse("http://192.168.1.11:8080/ticket"));
    if (response.statusCode == 200) {
      tickets.value = jsonDecode(response.body);
    } else {
      throw Exception("Failed to load tickets");
    }

    isLoading.value = false;
  }*/

  Future<void> paymentGateway(int customerId, int ticketId, String seatId,
      String bookingDate, String status, int price) async {
    final response = await http.post(
      Uri.parse('http://${ip.ip}:8080/transaction'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "customer_id": customerId,
        "ticket_id": ticketId,
        "seat_id": seatId,
        "booking_date": bookingDate,
        "status": status,
        "price": price
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Booking successfully',
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.green,
        colorText: Colors.black,
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 500),
      );
      Get.toNamed(Routes.HOME);
    } else if (response.statusCode == 409) {
      Get.snackbar("failed",
          "Seat is occupied by someone else or no longer available, please check few minutes later",
          snackStyle: SnackStyle.FLOATING,
          backgroundColor: Colors.amber,
          colorText: Colors.black,
          duration: Duration(seconds: 10),
          animationDuration: Duration(milliseconds: 500));
      Get.toNamed(Routes.BOOKING);
    } else {
      Get.snackbar(
        'Error',
        'Failed',
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.red,
        colorText: Colors.black,
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 500),
      );
    }
    isLoading.value = false;
  }
}

class Ticket {
  final int ticketId;
  final int price;
  final String seatId;

  Ticket({required this.ticketId, required this.price, required this.seatId});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketId: json['ticket_id'],
      price: json['price'],
      seatId: json['seat_id'],
    );
  }
}
