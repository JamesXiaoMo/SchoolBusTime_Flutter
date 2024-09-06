import 'package:flutter/material.dart';
import 'generated/l10n.dart';

class SpecialThanksPage extends StatelessWidget {
  const SpecialThanksPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).specialthanks),
        backgroundColor: Colors.green,
      ),
      body:
      const SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Text("呉　昀罡", style: TextStyle(fontSize: 28)),
                Text("電気電子工学科", style: TextStyle(fontSize: 18)),
                Text("Programing/App Design", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("Pratap Gurung", style: TextStyle(fontSize: 28)),
                Text("International Economics", style: TextStyle(fontSize: 18)),
                Text("Marketing/App Design", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("Mike, Chan Kwan Shun", style: TextStyle(fontSize: 28)),
                Text("メディア学科", style: TextStyle(fontSize: 18)),
                Text("UI Desgin", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("常乐", style: TextStyle(fontSize: 28)),
                Text("メディア学科", style: TextStyle(fontSize: 18)),
                Text("Android Software Testing", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("张程信", style: TextStyle(fontSize: 28)),
                Text("国際経済学科", style: TextStyle(fontSize: 18)),
                Text("Android Software Testing", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("Mike, Chan Kwan Shun", style: TextStyle(fontSize: 28)),
                Text("メディア学科", style: TextStyle(fontSize: 18)),
                Text("Android Software Testing", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("Nikolay Dralev", style: TextStyle(fontSize: 28)),
                Text("人間文化学科", style: TextStyle(fontSize: 18)),
                Text("Android Software Testing", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("苑博文", style: TextStyle(fontSize: 28)),
                Text("国際経済学科", style: TextStyle(fontSize: 18)),
                Text("Android Software Testing", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("黄晨", style: TextStyle(fontSize: 28)),
                Text("税務会計学科", style: TextStyle(fontSize: 18)),
                Text("Android Software Testing", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("相原　麗史", style: TextStyle(fontSize: 28)),
                Text("国際経済学科", style: TextStyle(fontSize: 18)),
                Text("Android Software Testing", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("Pratap Gurung", style: TextStyle(fontSize: 28)),
                Text("International Economics", style: TextStyle(fontSize: 18)),
                Text("Android Software Testing", style: TextStyle(fontSize: 18)),
                Divider(),
                Text("westjr -Github", style: TextStyle(fontSize: 28)),
                Text("By unyacat&eggplants", style: TextStyle(fontSize: 18)),
                Text("An open source project helps complete the JR prediction function.", style: TextStyle(fontSize: 18)),
                Divider(),
              ],
            ),
          )
      )
    );
  }
}