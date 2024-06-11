import 'package:final_app/RegisterPage.dart';
import 'package:final_app/SettingPage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:final_app/ContentPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String username = '';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = '/LoginPage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String account = "", password = "";
  String token = "";
  @override
  void initState() {
    super.initState();
    print(justLoggedout);
    if (justRegistered || justLoggedout) {
      //剛註冊完不要用之前的資料自動登入
      justLoggedout = false;
      justRegistered = false;
    } else {
      _getToken();
    }
  }

//取得之前儲存的token
  void _getToken() async {
    // SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    String loginToken = prefs.getString('token') ?? '';
    print('token:  $loginToken');
    if (loginToken.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ContentPage()),
      );
      //詢問是否自動登入
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('自動登入'),
      //       content: Text('檢測到先前的登入資料，是否自動登入？'),
      //       actions: <Widget>[
      //         TextButton(
      //           child: Text('否'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //         TextButton(
      //           child: Text('是'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //             // Future.delayed(Duration(seconds: 1), () {
      //             Navigator.of(context).push(
      //               MaterialPageRoute(builder: (context) => ContentPage()),
      //             );
      //             // Navigator.pushNamed(context, ContentPage.id);
      //             // });
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  }

  void login() async {
    final String apiUrl = 'https://favqs.com/api/session';
    final String apiKey = '16e5b92e652c1616e6362c26ed186ebd'; //API 金鑰

    Map<String, dynamic> credentials = {
      "user": {
        "login": account,
        "password": password,
      }
    };

    //登入POST request
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token token=$apiKey', // 添加 API 金鑰到標頭
      },
      body: jsonEncode(credentials),
    );
    print('Credentials: $credentials');
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['error_code'] != null) {
        _showLoginDialog('登入失敗!', '請確認帳號或密碼是否正確');
      } else {
        print('登入成功!');
        _showLoginDialog('登入成功!', "");
        //儲存token
        token = responseBody['User-Token'];
        username = account;
        // print('token2: $token');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ContentPage()),
        ); //進到畫面
      }
    } else {
      _showLoginDialog('登入失敗!', '請確認帳號或密碼是否正確');
      print('Failed to create session. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void _showLoginDialog(String state, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(state),
          content: Text(error),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '旅行小幫手',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 143, 164, 247),
      ),
      backgroundColor: Colors.pink[50],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '登入',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 143, 164, 247),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              // keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                account = value;
              },
              decoration: InputDecoration(
                labelText: '使用者名稱',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 143, 164, 247),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 143, 164, 247),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 143, 164, 247),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                labelText: '密碼',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 143, 164, 247),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 143, 164, 247),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 143, 164, 247),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 登入邏輯
                  print("username: $account");
                  print("password: $password");
                  login();
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
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    '登入',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '沒有帳號？',
                    style: TextStyle(
                        color: Color.fromARGB(255, 143, 164, 247),
                        fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 143, 164, 247),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    '註冊',
                    style: TextStyle(
                        color: Color.fromARGB(255, 143, 164, 247),
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
