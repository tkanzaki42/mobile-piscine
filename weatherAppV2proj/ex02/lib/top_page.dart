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
  List<String> _suggestions = [];
  Map<String, dynamic> _weatherData = {};

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    List<String> suggestions = await LocationService.getSuggestions(query);
    setState(() {
      _suggestions = suggestions;
      _displayedText = query;
    });
  }

  void _getWeather(String cityName) async {
    Map<String, dynamic> weatherData = await LocationService.getWeather(cityName, _currentIndex);
    setState(() {
      _weatherData = weatherData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () async {
                    String locationText = await LocationService.getCurrentLocation();
                    setState(() {
                      _displayedText = locationText;
                      _textController.text = locationText;
                    });
                    _getWeather(locationText);
                  },
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          PageView(
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
          if (_suggestions.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                elevation: 4.0,
                child: Container(
                  color: Colors.white,
                  constraints: BoxConstraints(
                    maxHeight: 250.0, // 必要に応じて調整
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_suggestions[index]),
                        onTap: () {
                          setState(() {
                            _displayedText = _suggestions[index];
                            _textController.text = _suggestions[index];
                          });
                          _getWeather(_suggestions[index]);
                          _suggestions = [];
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          if (_weatherData.isNotEmpty)
            Positioned(
              top: kToolbarHeight + 280.0, // 検索バーと候補リストの高さ + パディング
              left: 0,
              right: 0,
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Weather in ${_weatherData['name']}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${(_weatherData['main']['temp'] - 273).toStringAsFixed(1)}°C',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(_weatherData['weather'][0]['description']),
                    ],
                  ),
                ),
              ),
            ),
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
