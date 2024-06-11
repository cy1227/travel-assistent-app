import 'package:flutter/material.dart';
import 'package:final_app/ShowFlight.dart';
import 'package:final_app/Flight.dart';
import 'package:final_app/Autocomplete.dart';
import 'package:final_app/animation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';

String departure = '';
String destination = '';
String passengers = '1';
String departDateSearchString = '';
String returnDateSearchString = '';

class FlightSection extends StatefulWidget {
  const FlightSection({super.key});
  @override
  _FlightSectionState createState() => _FlightSectionState();
}

class _FlightSectionState extends State<FlightSection> {
  Future<List<Flight>>? futureFlights;
  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController departureDateController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();
  String selectedPassengers = '1';
  @override
  void initState() {
    super.initState();
  }

  //搜尋建議自動完成
  //取得航班資訊
  Future<List<Flight>> fetchFlights() async {
    //搜索關鍵詞
    String departureDate = departureDateController.text;
    String returnDate = returnDateController.text;
    DateTime date = DateTime.parse(departureDate);
    departDateSearchString = DateFormat('yyMMdd').format(date);
    date = DateTime.parse(returnDate);
    returnDateSearchString = DateFormat('yyMMdd').format(date);
    passengers = selectedPassengers;
    print('出發地: $departure');
    print('目的地: $destination');
    print('出發日期: $departureDate');
    print('回程日期: $returnDate');
    print('人數: $passengers');
    var url = Uri.parse(
        'https://sky-scanner3.p.rapidapi.com/flights/search-roundtrip?fromEntityId=$departure&toEntityId=$destination&departDate=$departureDate&returnDate=$returnDate&adults=$passengers&currency=TWD&locale=zh-TW&stops=direct');
    var response = await http.get(
      url,
      headers: <String, String>{
        'X-RapidAPI-Key': 'f5c594f263msh847a1985e13d7d9p1bd507jsn0427bf3d7428',
        'X-RapidAPI-Host': 'sky-scanner3.p.rapidapi.com',
      },
    );
    if (response.statusCode != 200) {
      print('Failed to initialize search: ${response.statusCode}');
      throw Exception('Failed to load flights');
    } else {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes)); //處理中文亂碼
      print('response.body');
      print(response.body);
      List results = jsonResponse['data']['itineraries'];
      List<Flight> flights = results
          .map(
            (e) => Flight.fromJson(e),
          )
          .toList();
      for (var flight in flights) {
        print(flight);
      }
      return flights;
    }
  }

  //更新
  Future<void> refresh() async {
    setState(() {
      futureFlights = fetchFlights();
    });
    await futureFlights;
  }

//過濾航空公司
  void airlineFilter(String airlineName) {
    if (futureFlights != null) {
      setState(() {
        futureFlights = futureFlights!.then((flights) {
          return flights
              .where((flight) =>
                  flight.carrier1.contains(airlineName) ||
                  flight.carrier2.contains(airlineName))
              .toList();
        });
      });
    }
  }

  DateTime? minDate;
  DateTime? maxDate;
  DateTime? currentPicked1;
  DateTime? currentPicked2;
//動畫
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage(
                'https://i.pinimg.com/564x/9d/05/d9/9d05d95790b47d651602c0c352085452.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), BlendMode.dstATop),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: AutoCompleteField(
                      isdepart: true,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  const Expanded(
                    flex: 2,
                    child: AutoCompleteField(
                      isdepart: false,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: selectedPassengers,
                      items: ['1', '2', '3', '4'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedPassengers = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 12.0),
                        hintText: '人數',
                        filled: true,
                        fillColor: Color.fromARGB(255, 192, 171, 214),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    // flex: 3,
                    child: TextField(
                      controller: departureDateController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 12.0),
                        hintText: '出發',
                        filled: true,
                        fillColor: const Color.fromARGB(255, 192, 171, 214),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final DateTime? departPicked = await showDatePicker(
                              context: context,
                              initialDate: currentPicked1 ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2026),
                            );

                            if (departPicked != null) {
                              setState(() {
                                departureDateController.text =
                                    "${departPicked.toLocal()}".split(' ')[0];
                                minDate =
                                    departPicked.add(const Duration(days: 1));
                                //如果調整後的出發日期比回程日期前面則回程設定為出發的後一天
                                if (maxDate!.isBefore(minDate!)) {
                                  returnDateController.text =
                                      "${minDate!.toLocal()}".split(' ')[0];
                                }
                                currentPicked1 = departPicked;
                              });
                            }
                          },
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: returnDateController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(16.0, 12.0, 12.0, 12.0),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 192, 171, 214),
                        hintText: '回程日期',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final DateTime? returnPicked =
                                  await showDatePicker(
                                context: context,
                                //若已經選擇則日期留在以選的那天 若還沒選擇設定出發日期的隔天
                                initialDate: currentPicked2 ??
                                    (minDate ?? DateTime.now()),
                                firstDate: minDate ?? DateTime.now(),
                                lastDate: DateTime(2026),
                              );
                              if (returnPicked != null) {
                                setState(() {
                                  returnDateController.text =
                                      "${returnPicked.toLocal()}".split(' ')[0];
                                  maxDate = returnPicked;
                                  currentPicked2 = returnPicked;
                                });
                              }
                            }),
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  SizedBox(
                    width: 245,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8.0, 12.0, 12.0),
                      child: SearchAnchor(
                        builder: (context, controller) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color.fromARGB(255, 143, 164, 247),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.search,
                                        color: Colors.white)),
                                Expanded(
                                  child: TextField(
                                    controller: controller,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: '航空公司篩選',
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: InputBorder.none,
                                    ),
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (value) {
                                      setState(() {
                                        airlineFilter(controller.text);
                                      });
                                      // You can add any onSubmitted logic here
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        suggestionsBuilder: (context, controller) {
                          return []; // Suggestions builder
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    //  width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          futureFlights = fetchFlights();
                        });
                      },
                      style: ButtonStyle(
                        // elevation: MaterialStateProperty.all<double>(8.0),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 143, 164, 247),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 9.0),
                        child: Text(
                          '搜尋航班',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Expanded(
                child: Center(
                  child: FutureBuilder<List<Flight>>(
                    future: futureFlights,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        var flights = snapshot.data!;
                        if (flights.isEmpty) {
                          return const Text('No results found.');
                        }
                        return RefreshIndicator(
                          onRefresh: refresh,
                          child: ListView.builder(
                            itemCount: flights.length,
                            itemBuilder: (context, index) {
                              //顯示飛機的widget
                              var currentFlight = flights[index];
                              refresh();
                              return ShowFlight(flight: currentFlight);
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        //還沒搜尋時顯示動畫
                        return AnimationScreen();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
