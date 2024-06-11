import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_app/LoginPage.dart';

bool justRegistered = false;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String id = '/RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = "",
      userName = "",
      password = "",
      confirmPassword = "",
      country = "";
  final TextEditingController birthdayController = TextEditingController();

  void register() async {
    if (password != confirmPassword) {
      _showDialog('密碼欄位兩者不相符', "請重新確認");
      return;
    }
    final String apiUrl = 'https://favqs.com/api/users';
    final String apiKey = '16e5b92e652c1616e6362c26ed186ebd'; //API 金鑰

    Map<String, dynamic> credentials = {
      "user": {
        "login": userName,
        "email": email,
        "password": password,
      }
    };
    //註冊 POST request
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Token token=$apiKey', // 添加 API 金鑰到標頭
      },
      body: jsonEncode(credentials),
    );

    // Check the status code and print the response
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['error_code'] != null) {
        String error = '請確認輸入格式是否正確';
        if (responseBody['error_code'] == 32) error = "用戶名稱已被使用或密碼長度小於五位";
        _showDialog('註冊失敗!', error);
      } else {
        print('註冊成功!');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('註冊成功!'),
              // content: Text(error),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            );
          },
        );
        justRegistered = true;
      }
      print('Session ID: ${responseBody['error_code']}');
    } else {
      _showDialog('註冊失敗!', '請確認輸入格式是否正確');
      print('Failed to create session. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void _showDialog(String state, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(state),
          content: Text(error),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
        backgroundColor: Colors.pink,
      ),
      backgroundColor: Colors.pink[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '註冊',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  labelText: '郵件',
                  labelStyle: TextStyle(color: Colors.pink),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.email, color: Colors.pink),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  userName = value;
                },
                decoration: InputDecoration(
                  labelText: '使用者名稱',
                  labelStyle: const TextStyle(color: Colors.pink),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.person, color: Colors.pink),
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
                  labelStyle: const TextStyle(color: Colors.pink),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.lock, color: Colors.pink),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  confirmPassword = value;
                },
                decoration: InputDecoration(
                  labelText: '確認密碼',
                  labelStyle: const TextStyle(color: Colors.pink),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.lock, color: Colors.pink),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: '國家',
                  labelStyle: const TextStyle(color: Colors.pink),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.public, color: Colors.pink),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: birthdayController,
                decoration: InputDecoration(
                  labelText: '生日',
                  labelStyle: const TextStyle(color: Colors.pink),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.cake, color: Colors.pink),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.pink),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2002),
                        firstDate: DateTime(1920),
                        lastDate: DateTime(2020),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          birthdayController.text =
                              "${pickedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                  ),
                ),
                style: const TextStyle(
                  // color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 註冊邏輯
                    register();
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.pink),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: Text(
                      '註冊',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
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
