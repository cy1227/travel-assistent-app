import 'package:final_app/FlightSection.dart';
import 'package:final_app/SettingPage.dart';
import 'package:flutter/material.dart';
import 'package:final_app/ChangeCurrencySection.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});
  static String id = '/ContentPage';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('旅行小幫手', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 143, 164, 247),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            const FlightSection(),
            ChangeCurrencySection(),
          ],
        ),
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 143, 164, 247),
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.flight),
                text: '看機票',
              ),
              Tab(
                icon: Icon(Icons.attach_money),
                text: '貨幣轉換',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
