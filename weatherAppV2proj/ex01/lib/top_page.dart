import 'package:flutter/material.dart';
import 'location_service.dart';
import 'custom_page_view.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key, required this.title});
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  TextEditingController _textController = TextEditingController();
  String _displayedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textController,
          decoration: InputDecoration(
            hintText: 'Search',
            suffixIcon: IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () async {
                String locationText = await LocationService.getCurrentLocation();
                setState(() {
                  _displayedText = locationText;
                });
              },
            ),
          ),
          onChanged: (text) {
            setState(() {
              _displayedText = text;
            });
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          CustomPageView(tabName: 'Currently', displayedText: _displayedText),
          CustomPageView(tabName: 'Today', displayedText: _displayedText),
          CustomPageView(tabName: 'Weekly', displayedText: _displayedText),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Currently',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_week),
            label: 'Weekly',
          ),
        ],
      ),
    );
  }
}
