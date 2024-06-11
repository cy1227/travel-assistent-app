import 'dart:async';
import 'package:flutter/material.dart';
import 'package:final_app/CurrencyCalculator.dart';
import 'package:final_app/CurrencySelectionDialog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';

class ChangeCurrencySection extends StatefulWidget {
  @override
  _ChangeCurrencySectionState createState() => _ChangeCurrencySectionState();
}

class _ChangeCurrencySectionState extends State<ChangeCurrencySection> {
  String amount = '0';
  String transferredAmount = '0';
  String inputCurrencyCode = 'TWD';
  String outputCurrencyCode = 'KRW';
  double rate = 0.5;
  String utcTime = "";
  String rateStatement = "";

  String tempAmount = '0';
  bool calculating = false;
  @override
  void initState() {
    super.initState();
    fetchCurrencyRate();
  }

  //處理時間字串
  String processTime() {
    initializeDateFormatting('zh_TW', null);
    DateTime parsedDate = DateTime.now();
    String formattedDate =
        DateFormat('yyyy/M/d a hh:mm', 'zh_TW').format(parsedDate);
    return formattedDate;
  }

  var jsonResponse;
  //取得匯率資訊
  void fetchCurrencyRate() async {
    var response = await http
        .get(Uri.parse('https://open.er-api.com/v6/latest/$inputCurrencyCode'));
    if (response.statusCode != 200) {
      print('Failed to initialize search: ${response.statusCode}');
      throw Exception('Failed to load currency rate');
    } else {
      //成功
      jsonResponse = jsonDecode(utf8.decode(response.bodyBytes)); //處理中文亂碼
      setState(() {
        rate = jsonResponse['rates'][outputCurrencyCode]; //指定的匯率
        utcTime = processTime(); //下方顯示的時間
        rateStatement =
            '$utcTime\n1 $inputCurrencyCode = ${rate.toStringAsFixed(4)} $outputCurrencyCode';
        double temp = double.parse(amount);
        temp = temp * rate;
        // print('temp: $temp');
        transferredAmount = temp.toStringAsFixed(2);
      });
    }
  }

  void updateAmount(String value) {
    setState(() {
      if (amount == '0' && value != '.') {
        amount = value;
      } else {
        amount += value;
      }
      //更新下面的幣值
      double temp = double.parse(amount);
      //計算換算後的值
      temp = temp * rate;
      transferredAmount = temp.toStringAsFixed(2);
    });
  }

  void clearAmount() {
    setState(() {
      amount = '0';
      transferredAmount = '0';
    });
  }

//刪掉最後一位數
  void deleteLast() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
      } else {
        amount = '0';
      }
      //更新轉換的貨幣
      double temp = double.parse(amount);
      //計算換算後的值
      temp = temp * rate;
      transferredAmount = temp.toStringAsFixed(2);
    });
  }

//上下交換換算
  void switchCurrencies() {
    setState(() {
      String temp = inputCurrencyCode;
      inputCurrencyCode = outputCurrencyCode;
      outputCurrencyCode = temp;
      fetchCurrencyRate();
    });
  }
  // void Plus(){
  //   calculating = true;
  //   setState(() {

  //   });
  // }
  //   final Function() onDividePressed; //除
  // final Function() onMultiplyPressed; //乘
  // final Function() onPlusPressed; //加
  // final Function() onSubstractPressed; //減
  // final Function() onRemainderPressed; //%
  // final Function() onEqualPressed; //=

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 192, 171, 214),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  CurrencyDisplay(
                    currencyCode: inputCurrencyCode,
                    amount: amount,
                    onCurrencyCodeChanged: (newCurrencyCode) {
                      setState(() {
                        //改變輸入的幣值要重新呼叫api
                        inputCurrencyCode = newCurrencyCode;
                        fetchCurrencyRate();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CurrencyDisplay(
                    currencyCode: outputCurrencyCode,
                    amount: transferredAmount,
                    onCurrencyCodeChanged: (newCurrencyCode) {
                      setState(() {
                        outputCurrencyCode = newCurrencyCode;
                        //更新計算換算後的值
                        rate = jsonResponse['rates'][outputCurrencyCode];
                        double temp = double.parse(amount);
                        temp = temp * rate;
                        transferredAmount = temp.toStringAsFixed(2);
                        //改變下方敘述
                        rateStatement =
                            '$utcTime\n1 $inputCurrencyCode = ${rate.toStringAsFixed(4)} $outputCurrencyCode';
                      });
                    },
                  ),
                ],
              ),
            ),
            Calculator(
              onNumberPressed: updateAmount,
              onClearPressed: clearAmount,
              onDeletePressed: deleteLast,
              onSwitchPressed: switchCurrencies,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                rateStatement,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromARGB(255, 82, 66, 146),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyDisplay extends StatelessWidget {
  final String currencyCode;
  final String amount;
  // bool isInputCurrency;//上面輸入的那個
  final ValueChanged<String> onCurrencyCodeChanged;

  const CurrencyDisplay({
    required this.currencyCode,
    required this.amount,
    required this.onCurrencyCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                final selectedCurrency = await showCurrencySelection(context);
                if (selectedCurrency != null) {
                  onCurrencyCodeChanged(selectedCurrency);
                }
              },
              child: Text(
                currencyCode,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(0, 255, 255, 255), // 按鈕背景色
              ),
            ),
          ],
        ),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
          ),
        ),
      ],
    );
  }

  Future<String?> showCurrencySelection(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return CurrencySelectionDialog();
      },
    );
  }
}
