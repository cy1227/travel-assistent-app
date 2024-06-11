import 'package:intl/intl.dart';
// //Round trip 假設直飛

class Flight {
  final String price; //票價
  //去程1
  final String origin1; //出發地
  final String destination1; //目的地
  final String departDate1; //出發日期
  final String arriveDate1; //到達日期
  final String departTime1; //出發時間
  final String arriveTime1; //到達時間
  final String duration1; //飛行時間
  final String carrier1; //航空公司
  final String carrierUrl1; //航空公司圖片
  //回程2
  final String origin2; //出發地
  final String destination2; //目的地
  final String departDate2; //出發日期
  final String arriveDate2; //到達日期
  final String departTime2; //出發時間
  final String arriveTime2; //到達時間
  final String duration2; //飛行時間
  final String carrier2; //航空公司
  final String carrierUrl2; //航空公司圖片

  Flight({
    required this.price,
    required this.origin1,
    required this.destination1,
    required this.departDate1,
    required this.departTime1,
    required this.arriveDate1,
    required this.arriveTime1,
    required this.duration1,
    required this.carrier1,
    required this.carrierUrl1,
    required this.origin2,
    required this.destination2,
    required this.departDate2,
    required this.departTime2,
    required this.arriveDate2,
    required this.arriveTime2,
    required this.duration2,
    required this.carrier2,
    required this.carrierUrl2,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    if (json['legs'] == null || json['legs'].length < 2) {
      throw ArgumentError('Invalid legs data');
    }

    var departureLegs = json['legs'][0]; // 去程的資料
    var returnLegs = json['legs'][1]; // 回程的資料

    String getFormattedDate(String dateTimeStr, String format) {
      return DateFormat(format).format(DateTime.parse(dateTimeStr));
    }

//根據網址規律自己拼出api裡沒有提供的航空公司圖片
    String buildCarrierUrl(String alternateId) {
      return 'https://www.skyscanner.net/images/airlines/small/$alternateId.png';
    }

    String formatMinutesToHoursAndMinutes(int totalMinutes) {
      //把分鐘轉成時間表示
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;

      return '$hours小時$minutes分';
    }

    return Flight(
      price: json['price']['formatted'] ?? 'N/A',
      // 去程
      origin1: departureLegs['origin']['displayCode'] ?? 'N/A',
      destination1: departureLegs['destination']['displayCode'] ?? 'N/A',
      departDate1: getFormattedDate(departureLegs['departure'], 'yyyy-MM-dd'),
      departTime1: getFormattedDate(departureLegs['departure'], 'HH:mm'),
      arriveDate1: getFormattedDate(departureLegs['arrival'], 'yyyy-MM-dd'),
      arriveTime1: getFormattedDate(departureLegs['arrival'], 'HH:mm'),
      duration1: formatMinutesToHoursAndMinutes(
          departureLegs['durationInMinutes'] ?? 0),
      carrier1: departureLegs['carriers']['marketing'][0]['name'] ?? 'N/A',
      carrierUrl1: buildCarrierUrl(
          departureLegs['segments'][0]['operatingCarrier']['alternateId']),
      // 回程
      origin2: returnLegs['origin']['displayCode'] ?? 'N/A',
      destination2: returnLegs['destination']['displayCode'] ?? 'N/A',
      departDate2: getFormattedDate(returnLegs['departure'], 'yyyy-MM-dd'),
      departTime2: getFormattedDate(returnLegs['departure'], 'HH:mm'),
      arriveDate2: getFormattedDate(returnLegs['arrival'], 'yyyy-MM-dd'),
      arriveTime2: getFormattedDate(returnLegs['arrival'], 'HH:mm'),
      duration2:
          formatMinutesToHoursAndMinutes(returnLegs['durationInMinutes'] ?? 0),
      carrier2: returnLegs['carriers']['marketing'][0]['name'] ?? 'N/A',
      carrierUrl2: buildCarrierUrl(
          returnLegs['segments'][0]['operatingCarrier']['alternateId']),
    );
  }
  @override
  String toString() {
    return 'Flight(price: $price, origin1: $origin1, destination1: $destination1, departDate1: $departDate1, arriveDate1: $arriveDate1, departTime1: $departTime1, arriveTime1: $arriveTime1, durationInMinutes1: $duration1, carrier1: $carrier1, carrierUrl1: $carrierUrl1, origin2: $origin2, destination2: $destination2, departDate2: $departDate2, arriveDate2: $arriveDate2, departTime2: $departTime2, arriveTime2: $arriveTime2, durationInMinutes2: $duration2, carrier2: $carrier2, carrierUrl2: $carrierUrl2)';
  }
}
