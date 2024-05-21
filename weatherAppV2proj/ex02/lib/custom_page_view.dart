import 'package:flutter/material.dart';

class CustomPageView extends StatelessWidget {
  final String tabName;
  final String displayedText;

  const CustomPageView({Key? key, required this.tabName, required this.displayedText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            tabName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          if (displayedText.isNotEmpty)
            Text(
              displayedText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
        ],
      ),
    );
  }
}
