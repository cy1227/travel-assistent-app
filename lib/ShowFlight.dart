import 'package:final_app/FlightSection.dart';
import 'package:flutter/material.dart';
import 'package:final_app/Flight.dart';
import 'package:url_launcher/url_launcher.dart';

//顯示飛機的widget
class ShowFlight extends StatelessWidget {
  const ShowFlight({super.key, required this.flight});
  final Flight flight;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      // decoration: BoxDecoration(
//         color: Colors.purple[100],
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 8.0,
//             offset: Offset(0, 4),
//           ),
//         ],
      // ),
      child: Column(
        children: [
          FlightInfo(
            flight: flight,
          ),
        ],
      ),
    );
  }
}

class FlightInfo extends StatelessWidget {
  final Flight flight;
  const FlightInfo({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 169, 149, 190),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8.0,
//             offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Image.network(
                flight.carrierUrl1,
                height: 30,
              ),
              Text(
                //超過四個字的航空公司名換行顯示
                flight.carrier1.length > 4
                    ? '${flight.carrier1.substring(0, 4)}\n${flight.carrier1.substring(4)}'
                    : flight.carrier1,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20, height: 10),
              Image.network(
                flight.carrierUrl2,
                height: 30,
              ),
              Text(
                flight.carrier2.length > 4
                    ? '${flight.carrier2.substring(0, 4)}\n${flight.carrier2.substring(4)}'
                    : flight.carrier2,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                flight.departTime1, //出發時間
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                flight.origin1, //出發地
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20, height: 10),
              Text(
                flight.departTime2, //出發時間
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                flight.origin2, //出發地
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                flight.duration1, //飛行時間
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const Icon(
                Icons.airplanemode_active,
                color: Colors.white,
              ),
              const Text(
                '直飛',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                flight.duration2, //飛行時間
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const Icon(
                Icons.airplanemode_active,
                color: Colors.white,
              ),
              const Text(
                '直飛',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                flight.arriveTime1, //到達時間
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                flight.destination1, //目的地
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20, height: 10),
              Text(
                flight.arriveTime2, //到達時間
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                flight.destination2, //目的地
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Center(
                child: Text(
                  flight.price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              //選擇按鈕
              ElevatedButton(
                onPressed: () async {
                  String skyUrl =
                      'https://www.skyscanner.com.tw/transport/flights/$departure/$destination/$departDateSearchString/$returnDateSearchString/?adultsv2=$passengers&cabinclass=economy&childrenv2=&inboundaltsenabled=false&outboundaltsenabled=false&preferdirects=true&ref=home&rtn=1';
                  var url = Uri.parse(skyUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 143, 164, 247),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('選擇'),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
