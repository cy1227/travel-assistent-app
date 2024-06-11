import 'package:flutter/material.dart';
import 'package:final_app/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

bool justLoggedout = false;

class _SettingPageState extends State<SettingPage> {
//清除之前儲存的token
  void deleteLoginToken() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確定要清除登入記錄？'),
          content: const Text('下次使用時將不會自動登入'),
          actions: <Widget>[
            TextButton(
              child: const Text('否'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('是'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('清除登入記錄成功！'),
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
              },
            ),
          ],
        );
      },
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: const Color.fromARGB(255, 143, 164, 247),
      ),
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
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100.0),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('登出成功！'),
                          // content: Text(error),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
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
                    justLoggedout = true;
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 192, 171, 214),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 9.0),
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 40.0),
                        Text(
                          '登出',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: () {
                    deleteLoginToken();
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 192, 171, 214),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 9.0),
                    child: Row(
                      children: [
                        Icon(Icons.delete_forever),
                        SizedBox(width: 12.0),
                        Text(
                          '清除登入記錄',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
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
//   void loginOut() async {
//   final String apiUrl = 'https://favqs.com/api/session';
//   final String apiKey = '16e5b92e652c1616e6362c26ed186ebd'; //API 金鑰

//   Map<String, dynamic> credentials = {
//     "user": {
//       "login": account,
//       "password": password,
//     }
//   };

//   //登入POST request
//   final http.Response response = await http.delete(
//     Uri.parse(apiUrl),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'Token token=$apiKey', // 添加 API 金鑰到標頭
//     },
//     body: jsonEncode(credentials),
//   );
//   print('Credentials: $credentials');
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> responseBody = jsonDecode(response.body);
//     if (responseBody['error_code'] != null) {
//       _showLoginDialog('登入失敗!', '請確認帳號或密碼是否正確');
//     } else {
//       print('登入成功!');
//       _showLoginDialog('登入成功!', "");
//       //儲存token
//       token = responseBody['User-Token'];
//       print('token2: $token');
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString('token', token);
//       Navigator.pushNamed(context, ContentPage.id); //進到畫面
//     }
//   } else {
//     _showLoginDialog('登入失敗!', '請確認帳號或密碼是否正確');
//     print('Failed to create session. Status code: ${response.statusCode}');
//     print('Response body: ${response.body}');
//   }
// }
