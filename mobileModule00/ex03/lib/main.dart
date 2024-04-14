import 'package:flutter/material.dart';
import 'dart:math';

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
  // 文字のstackを宣言
  List<String> elements = [];
  var intValue = Random().nextInt(10);
  bool answerFlag = false;

  // stackをStringに変換する関数
  String _stackToString() {
    if (elements.isEmpty) {
      return '0';
    }
    return elements.join();
  }

  void _onPressed(String value) {
    // 出力
    if (answerFlag) {
      elements.clear();
      answerFlag = false;
    }

    // stackに保存
    if (value == 'C') {
      if (elements.isNotEmpty) {
        elements.removeLast();
      }
    } else if (value == 'AC') {
      elements.clear();
    } else if (value == '=') {
      calculate();
    } else {
      elements.add(value);
    }
    prepareElements();

    // stackを表示
    setState(() {});
  }

  void prepareElements() {
    List<String> preparedElements = [];
    String currentNumber = '';

    for (var element in elements) {
      if (RegExp(r'[0-9.]').hasMatch(element)) { // 数字または小数点なら
        // 既に小数点が含まれている場合は無視
        if (element == '.' && currentNumber.contains('.')) {
          continue;
        }
        // 0が連続している場合は無視
        if (currentNumber == '' && element == '0') {
          continue;
        }
        // いきなり小数点が来た場合は0を追加してから小数点を追加
        if (currentNumber == '' && element == '.') {
          currentNumber = '0';
        }
        currentNumber += element; // 数字を組み合わせる
      } else if (element == '-' && (preparedElements.isEmpty || RegExp(r'[x/+]').hasMatch(preparedElements.last))) {
        // 負の符号の場合（リストが空、または直前の要素が演算子の場合）
        if (currentNumber.isNotEmpty) {
          preparedElements.add(currentNumber); // 既存の数値を追加
          currentNumber = ''; // リセット
        }
        currentNumber = '-'; // 負の数値を開始
      } else {
        if (currentNumber.isNotEmpty) {
          preparedElements.add(currentNumber); // 完成した数値を追加
          currentNumber = ''; // リセット
        }
        preparedElements.add(element); // 演算子を追加
      }
    }

    if (currentNumber.isNotEmpty) {
      preparedElements.add(currentNumber); // 最後の数値を追加
    }

    elements = preparedElements; // 更新されたelements
  }

  void calculate() {
    if (elements.length < 3) {
      return;
    }

    // 乗算と除算を先に計算
    List<String> newElements = [];
    double temp = double.parse(elements[0]);

    for (int i = 1; i < elements.length; i += 2) {
      switch (elements[i]) {
        case 'x':
          temp *= double.parse(elements[i + 1]);
          break;
        case '/':
          double divisor = double.parse(elements[i + 1]);
          if (divisor == 0) {
            // Infinityを追加して終了
            elements.clear();
            elements.add('Infinity');
          }
          temp /= divisor;
          break;
        default:
          // tempをdoubleからStringに変換してnewElementsに追加
          String tempString = temp.toString();
          newElements.add(tempString);
          newElements.add(elements[i]);
          temp = double.parse(elements[i + 1]);
          break;
      }
    }
    newElements.add(temp.toString());

    // 加算と減算を計算
    double answer = double.parse(newElements[0]);
    for (int i = 1; i < newElements.length; i += 2) {
      switch (newElements[i]) {
        case '+':
          answer += double.parse(newElements[i + 1]);
          break;
        case '-':
          answer -= double.parse(newElements[i + 1]);
          break;
      }
    }

    // 結果を更新
    elements.clear();
    elements.add(answer.toString());
    setState(() {});
    answerFlag = true;
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
              _stackToString(),
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
              ElevatedButton(onPressed: () => _onPressed('.'), child: Text('.')),
              ElevatedButton(onPressed: () => _onPressed('00'), child: Text('00')),
              ElevatedButton(onPressed: () => _onPressed('='), child: Text('=')),
            ],
          ),
        ],
      ),
    );
  }
}
