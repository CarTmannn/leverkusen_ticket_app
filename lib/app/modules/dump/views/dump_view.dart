import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:ticket_app/app/routes/app_pages.dart';

import '../controllers/dump_controller.dart';

class DumpView extends GetView<DumpController> {
  const DumpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.INTRO);
            },
            child: Text("Book"))
      ],
    ));
  }
}
