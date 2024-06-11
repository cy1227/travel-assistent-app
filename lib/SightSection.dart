import 'package:flutter/material.dart';
import 'package:final_app/Flight.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
//景點的區塊

class SightSection extends StatefulWidget {
  const SightSection({super.key});

  @override
  State<SightSection> createState() => _SightSectionState();
}

class _SightSectionState extends State<SightSection> {
  Future<List<Flight>>? futureTracks;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
  }

  Future<List<Flight>> fetchTracks() async {
    var url = Uri.parse(
        'https://itunes.apple.com/search?term=$searchTerm&media=music&country=tw');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List results = jsonResponse['results'];
      List<Flight> tracks = results
          .map(
            (e) => Flight.fromJson(e),
          )
          .toList();
      return tracks;
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  Future<void> refresh() async {
    setState(() {
      futureTracks = fetchTracks();
    });
    await futureTracks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('尋找景點'),
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  leading: const Icon(Icons.search),
                  controller: controller,
                  hintText: 'Search place',
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    setState(() {
                      searchTerm = value;
                      futureTracks = fetchTracks();
                    });
                  },
                );
              },
              suggestionsBuilder: (context, controller) {
                return [];
              },
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     String chatURL = "https://flutter.dev";
          //     var url = Uri.parse(chatURL);
          //     if (await canLaunchUrl(url)) {
          //       await launchUrl(url, mode: LaunchMode.externalApplication);
          //     } else {
          //       throw 'Could not launch $url';
          //     }
          //   },
          //   style: ButtonStyle(
          //     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          //     backgroundColor: MaterialStateProperty.all<Color>(
          //       Color.fromARGB(255, 143, 164, 247),
          //     ),
          //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //       RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text('選擇'),
          //       Icon(Icons.arrow_forward, size: 20),
          //     ],
          //   ),
          // ),
          // Expanded(
          //   child: Center(
          //     child: FutureBuilder<List<Flight>>(
          //       future: futureTracks,
          //       builder: (context, snapshot) {
          //         if (snapshot.hasData) {
          //           var tracks = snapshot.data!;
          //           if (tracks.isEmpty) {
          //             return const Text('No results found.');
          //           }
          //           return RefreshIndicator(
          //             onRefresh: refresh,
          //             child: ListView.builder(
          //               itemCount: tracks.length,
          //               itemBuilder: (context, index) {
          //                 var track = tracks[index];
          //                 var formattedDate = DateFormat('yyyy/MM/dd')
          //                     .format(track.releaseDate);
          //                 return ListTile(
          //                   title: Text(track.trackName),
          //                   subtitle: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(track.artistName),
          //                       Text(formattedDate),
          //                     ],
          //                   ),
          //                 );
          //               },
          //             ),
          //           );
          //         } else if (snapshot.hasError) {
          //           return Text('${snapshot.error}');
          //         }
          //         if (searchTerm.isEmpty) {
          //           return const SizedBox();
          //         } else {
          //           return const CircularProgressIndicator();
          //         }
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
