import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/my_app_model.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MyAPPModel>(context, listen: false);
    const quizMaxLength = 5;
    return Scaffold(
      body: Center(child: Consumer<MyAPPModel>(builder: (context, model, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                '好きなのはどっち？\n',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300], width: 1.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'Win',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 300,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300], width: 1.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'Mac',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      })),
    );
  }
}
