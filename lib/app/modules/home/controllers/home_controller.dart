import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var matches = [].obs;
  var nearestMatch = {}.obs;
  var players = [].obs;
  String ip = "192.168.1.9";

  void onInit() {
    super.onInit();
    _fetchMatches();
    _fetchPlayers();
  }

  Future<void> _fetchMatches() async {
    final response = await http.get(Uri.parse("http://${ip}:8080/game_match"));
    if (response.statusCode == 200) {
      matches.value = jsonDecode(response.body);
      matches.forEach((match) {
        DateTime matchDateTime = DateTime.parse(match["time_start"]);
        String formattedDate = DateFormat("EEEE d MMMM yyyy HH:mm:ss", "en_US")
            .format(matchDateTime);

        match['formattedTimeStart'] = formattedDate;
      });

      _fetchNearestMatch();
    } else {
      throw Exception("Failed to load game matches");
    }
  }

  void _fetchNearestMatch() {
    DateTime now = DateTime.now();
    List<dynamic> upcomingMatches = matches
        .where((match) =>
            DateTime.parse(match['time_start']).isAfter(now) ||
            DateTime.parse(match['time_start']).isAtSameMomentAs(now))
        .toList();

    if (upcomingMatches.isNotEmpty) {
      upcomingMatches.sort((a, b) => DateTime.parse(a['time_start'])
          .compareTo(DateTime.parse(b['time_start'])));
      nearestMatch.value = upcomingMatches[0];
    }
  }

  Future<void> _fetchPlayers() async {
    final response = await http.get(Uri.parse("http://${ip}:8080/player"));
    if (response.statusCode == 200) {
      players.value = jsonDecode(response.body);

      _fetchNearestMatch();
    } else {
      throw Exception("Failed to load players");
    }
    isLoading.value = false;
  }
}
