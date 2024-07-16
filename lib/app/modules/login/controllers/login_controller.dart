import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';
import 'package:ticket_app/app/modules/home/controllers/home_controller.dart';
import 'package:ticket_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:ticket_app/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final customerId = 0.obs;
  final name = "".obs;
  final birthDate = "".obs;
  final gender = "".obs;
  final email = "".obs;
  final emailView = "".obs;
  final password = "".obs;
  final saldo = 0.obs;
  final photo = "".obs;
  final errorMessage = "".obs;
  final isLoading = false.obs;
  HomeController ip = HomeController();

  Future<void> login() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('http://${ip.ip}:8080/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.value,
          "password": password.value,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('customer_id') && data['customer_id'] != null) {
          name.value = data['name'];
          saldo.value = data['balance'];
          gender.value = data['gender'];
          birthDate.value = data['birthdate'];
          customerId.value = data["customer_id"];
          photo.value = data["photo"];
          emailView.value = data["email"];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('customer_id', data['customer_id']);
          await prefs.setString('name', data['name']);
          await prefs.setString('balance', data['balance'].toString());
          await prefs.setString('gender', data['gender']);
          await prefs.setString('birthdate', data['birthdate']);
          await prefs.setString('photo', data['photo']);
          await prefs.setString('emailView', data['email']);
          Get.offAllNamed(Routes.HOME);
        } else {
          errorMessage.value = 'Invalid email or password';
        }
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Invalid email or password';
      } else {
        final Map<String, dynamic> error = jsonDecode(response.body);
        errorMessage.value = error["error"] ?? 'An unexpected error occurred.';
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      login();
    }
  }
}
