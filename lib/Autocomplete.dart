import 'package:final_app/FlightSection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AutoCompleteField extends StatefulWidget {
  final bool isdepart;
  const AutoCompleteField({Key? key, required this.isdepart}) : super(key: key);
  @override
  _AutoCompleteFieldState createState() => _AutoCompleteFieldState();
}

class _AutoCompleteFieldState extends State<AutoCompleteField> {
  List<String> _suggestions = [];
  Map<String, String> skyIDMap = {};
  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchSuggestions(String query) async {
    final url = Uri.parse(
        'https://sky-scanner3.p.rapidapi.com/flights/auto-complete?query=$query&locale=zh-TW');
    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': 'f5c594f263msh847a1985e13d7d9p1bd507jsn0427bf3d7428',
      'X-RapidAPI-Host': 'sky-scanner3.p.rapidapi.com'
    });

    if (response.statusCode == 200) {
      final List<dynamic> data =
          json.decode(utf8.decode(response.bodyBytes))['data'];
      setState(() {
        _suggestions = data
            .map((item) => item['presentation']['suggestionTitle'] as String)
            .toList();
        skyIDMap = {
          for (var item in data)
            item['presentation']['suggestionTitle']: item['presentation']
                ['skyId']
        };
      });
      print('seggestion: $_suggestions');
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        } else {
          await _fetchSuggestions(textEditingValue.text);
        }
        return _suggestions;
      },
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 12.0),
            prefixIcon: const Icon(Icons.location_on),
            filled: true,
            fillColor: const Color.fromARGB(255, 192, 171, 214),
            hintText: widget.isdepart ? '出發地' : '目的地',
            border: const OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 18),
          keyboardType: TextInputType.text,
        );
      },
      onSelected: (String value) {
        //取得sky id;
        if (widget.isdepart) {
          departure = skyIDMap[value] ?? '';
          print('departure ID: $departure');
        } else {
          destination = skyIDMap[value] ?? '';
          print('destination ID: $destination');
        }
        debugPrint('You just selected $value');
      },
    );
  }
}
