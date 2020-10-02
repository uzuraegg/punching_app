import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/my_app_model.dart';

class ResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigatorに渡された引数をここで受け取る
    final args = ModalRoute.of(context).settings.arguments as Map;
    String choise;

    if (args["choise"] == "LEFT") {
      choise = "左";
    } else if (args["choise"] == "RIGHT") {
      choise = "右";
    }

    final model = Provider.of<MyAPPModel>(context, listen: false);
    int correctNum = 1;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              choise + "を選択しました\nご協力ありがとうございました！",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: SizedBox(
                width: 300,
                height: 80,
                child: RaisedButton(
                  child: Text(
                    "戻る",
                    style: TextStyle(fontSize: 30),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/quiz');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
