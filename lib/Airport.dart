import 'package:intl/intl.dart';

//沒有用到
class Airport {
  final String name;
  final String skyID;
  Airport({
    required this.name,
    required this.skyID,
  });
  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      name: json['suggestionTitle'],
      skyID: json['skyId'],
    );
  }
}
