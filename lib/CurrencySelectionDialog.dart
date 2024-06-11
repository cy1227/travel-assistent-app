import 'package:flutter/material.dart';

class CurrencySelectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> currencyKeys = currencyMap.keys.toList();
    return Dialog(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('選擇貨幣'),
            backgroundColor: Color.fromARGB(255, 207, 169, 206),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currencyKeys.length,
              itemBuilder: (BuildContext context, int index) {
                String key = currencyKeys[index];
                return ListTile(
                  title: Text(key),
                  tileColor: Color.fromARGB(255, 246, 219, 245),
                  subtitle: Text(currencyMap[key]!),
                  onTap: () {
                    Navigator.of(context).pop(key);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final Map<String, String> currencyMap = {
  "TWD": "台灣",
  "JPY": "日本",
  "KRW": "南韓",
  "SGD": "新加坡",
  "THB": "泰國",
  "CNY": "中國",
  "MOP": "澳門",
  "CAD": "加拿大",
  "MYR": "馬來西亞",
  "USD": "美國",
  "AED": "阿拉伯聯合大公國",
  "AFN": "阿富汗",
  "ARS": "阿根廷",
  "AUD": "澳大利亞",
  "BRL": "巴西",
  "EUR": "歐盟",
  "GBP": "英國",
  "HKD": "香港",
  "TRY": "土耳其",
  "CUP": "古巴",
  "CZK": "捷克共和國",
  "DKK": "丹麥",
  "EGP": "埃及",
  "HUF": "匈牙利",
  "IDR": "印尼",
  "ILS": "以色列",
  "INR": "印度",
  "ISK": "冰島",
  "JOD": "約旦",
  "KHR": "柬埔寨",
  "MMK": "緬甸",
  "MNT": "蒙古",
  "MVR": "馬爾地夫",
  "MXN": "墨西哥",
  "NOK": "挪威",
  "NZD": "紐西蘭",
  "PHP": "菲律賓",
  "PLN": "波蘭",
  "RUB": "俄羅斯",
  "SAR": "沙烏地阿拉伯",
  "SEK": "瑞典",
  "VND": "越南",
  "ZAR": "南非",
};
//加上圖片？