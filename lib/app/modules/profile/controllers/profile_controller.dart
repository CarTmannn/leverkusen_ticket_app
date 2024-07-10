import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_app/app/modules/home/controllers/home_controller.dart';

class ProfileController extends GetxController {
  double positionY = 0;
  var isLoading = true.obs;
  var saldo = 0.obs;
  var tickets = [].obs;
  HomeController ip = HomeController();

  void updatePosition(double newPositionY) {
    positionY = newPositionY;
    update();
  }

  Future<void> getSaldo(int customer_id) async {
    final response = await http.post(
      Uri.parse('http://${ip.ip}:8080/fetch_saldo'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "customer_id": customer_id,
      }),
    );

    if (response.statusCode == 200) {
      final balance = int.tryParse(response.body);
      if (balance != null) {
        saldo.value = balance;
      } else {
        print('Failed to parse balance value');
      }
    } else {
      print('Failed to fetch saldo: ${response.statusCode}');
    }
    isLoading.value = false;
  }

  Future<void> getTicket(int customer_id) async {
    final response = await http.post(
      Uri.parse('http://${ip.ip}:8080/fetch_ticket'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "customer_id": customer_id,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is List) {
        tickets.value = jsonData;
      } else {
        print('Invalid response format');
      }
    } else {
      print('Failed to fetch tickets: ${response.statusCode}');
    }
    isLoading.value = false;
  }
}
