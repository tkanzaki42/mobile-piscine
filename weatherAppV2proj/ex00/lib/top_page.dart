import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

Future<void> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 位置情報サービスが有効かどうか
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    setState(() {
      _displayedText = '位置情報サービスが無効です。';
    });
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 権限が拒否された場合、次回に再度権限を要求することができます
      // (これがAndroidのshouldShowRequestPermissionRationaleがtrueを返したとき)。
      // Androidのガイドラインによると、この時点で説明UIを表示する必要があります。
      setState(() {
        _displayedText = '位置情報の権限が拒否されました';
      });
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // 権限が永久に拒否された場合、適切に対処します。
    setState(() {
      _displayedText =
          '位置情報の権限が永久に拒否されました。権限をリクエストすることができません。';
    });
    return;
  }

  // ここに到達した場合、権限が付与されており、デバイスの位置情報にアクセスできます。
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  setState(() {
    _displayedText = '緯度: ${position.latitude}, 経度: ${position.longitude}';
  });
}


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
              onPressed: _getCurrentLocation,
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
          _buildPage('Currently'),
          _buildPage('Today'),
          _buildPage('Weekly'),
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

  Widget _buildPage(String tabName) {
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
          if (_displayedText.isNotEmpty)
            Text(
              _displayedText,
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
