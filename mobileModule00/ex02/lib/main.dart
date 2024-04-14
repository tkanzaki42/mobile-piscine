import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  void _onPressed(String value) {
    // 出力
    print('button pressed: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Text('Calculator'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.topRight,
            child: Text(
              '0',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(onPressed: () => _onPressed('7'), child: Text('7')),
              ElevatedButton(onPressed: () => _onPressed('8'), child: Text('8')),
              ElevatedButton(onPressed: () => _onPressed('9'), child: Text('9')),
              ElevatedButton(onPressed: () => _onPressed('C'), child: Text('C')),
              ElevatedButton(onPressed: () => _onPressed('AC'), child: Text('AC')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(onPressed: () => _onPressed('4'), child: Text('4')),
              ElevatedButton(onPressed: () => _onPressed('5'), child: Text('5')),
              ElevatedButton(onPressed: () => _onPressed('6'), child: Text('6')),
              ElevatedButton(onPressed: () => _onPressed('+'), child: Text('+')),
              ElevatedButton(onPressed: () => _onPressed('-'), child: Text('-')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(onPressed: () => _onPressed('1'), child: Text('1')),
              ElevatedButton(onPressed: () => _onPressed('2'), child: Text('2')),
              ElevatedButton(onPressed: () => _onPressed('3'), child: Text('3')),
              ElevatedButton(onPressed: () => _onPressed('x'), child: Text('x')),
              ElevatedButton(onPressed: () => _onPressed('/'), child: Text('/')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // 左詰め

            children: <Widget>[
              ElevatedButton(onPressed: () => _onPressed('0'), child: Text('0')),
              ElevatedButton(onPressed: () => _onPressed('.'), child: Text('0')),
              ElevatedButton(onPressed: () => _onPressed('00'), child: Text('0')),
              ElevatedButton(onPressed: () => _onPressed('='), child: Text('0')),
            ],
          ),
        ],
      ),
    );
  }
}
