import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class KeyBoard extends StatefulWidget {
  const KeyBoard({Key? key}) : super(key: key);

  @override
  _KeyBoardState createState() => _KeyBoardState();
}

class _KeyBoardState extends State<KeyBoard> {
  final bgPrimaryColor = const Color(0xff222831);
  final bgSecundaryColor = const Color(0xff393e46);
  final highlightColor = const Color(0xff00adb5);

  var screenOperation = '';
  var screenResult = '';
  var previus = '';

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(screenOperation,
                      style:
                          const TextStyle(fontSize: 30, color: Colors.white))),
              Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(screenResult,
                      style:
                          const TextStyle(fontSize: 50, color: Colors.white)))
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (BuildContext contex, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (buttons[index] == 'C') {
                        clearScreenOp();
                        clearScreenResult();
                      } else if (buttons[index] == 'DEL') {
                        removeLastChar();
                      } else if (buttons[index] == '=') {
                        equalPressed();
                      } else if (isOperator(previus) &&
                          isOperator(buttons[index])) {
                        return;
                      } else {
                        setState(() {
                          screenOperation += buttons[index];
                          previus = buttons[index];
                        });
                      }
                    },
                    child: Text(
                      buttons[index],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  bool isOperator(String x) {
    if (x == '+' || x == '-' || x == '*' || x == '%' || x == '=' || x == '/') {
      return true;
    }
    return false;
  }

  void clearScreenOp() {
    setState(() {
      screenOperation = '';
      previus = '';
    });
  }

  void clearScreenResult() {
    setState(() {
      screenResult = '';
      previus = '';
    });
  }

  void removeLastChar() {
    setState(() {
      screenOperation =
          screenOperation.substring(0, screenOperation.length - 1);
    });
  }

  void equalPressed() {
    String a = screenOperation;
    Parser p = Parser();
    Expression exp = p.parse(a);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    setState(() {
      screenResult = eval.toString();
      clearScreenOp();
    });
  }
}