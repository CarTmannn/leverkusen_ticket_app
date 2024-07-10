import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ticket_app/app/modules/home/controllers/home_controller.dart';

class TopUpController extends GetxController {
  var isLoading = true.obs;
  HomeController ip = HomeController();

  void onInit() {
    super.onInit();
  }

  Future<void> topUp(int customerId, int balance) async {
    final response = await http.post(
      Uri.parse('http://${ip.ip}:8080/top_up'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "customer_id": customerId,
        "balance": balance,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'top up successfully',
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.green,
        colorText: Colors.black,
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 500),
      );
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
