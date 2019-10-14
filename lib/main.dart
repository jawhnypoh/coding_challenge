import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding Challenge',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: EbaySearch(),
    );
  }
}

class EbaySearchState extends State<EbaySearch> {
  final TextEditingController _query = TextEditingController();
  String _queryText = '';
  String _queryURL = 'https://api.ebay.com/buy/browse/v1/item_summary/search?';
  Widget _appTitle = Text('eBay Search App');
  Icon _queryIcon = Icon(Icons.search);

  EbaySearchState() {
    _query.addListener(() {
      if(_query.text.isEmpty) {
        setState(() {
          _queryText = '';
        });
      }
      else {
        setState(() {
          _queryText = _query.text;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        child: _buildResultsList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _appTitle,
      leading: IconButton(icon: _queryIcon, onPressed: _queryPressed),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('Loading Results...'),
        CircularProgressIndicator()],
      )
    );
  }

  Widget _buildResultsList() {

  }

  // If query button is pressed, change the state to allow user to search
  void _queryPressed() {
    setState(() {
      if(_queryIcon.icon == Icons.search) {
        _queryIcon = Icon(Icons.close);
        _appTitle = TextField(
          controller: _query,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search for stuff...',
            hintStyle: TextStyle(color: Colors.white),
          ),
        );

      }
      // Otherwise, revert to default AppBar state
      else {
        _queryIcon = Icon(Icons.search);
        _appTitle = Text('eBay Search App');
      }
      print('_queryText is: ' + _queryText);
    });
  }

  String _buildQueryURL() {
    // Build the query URL based on what user entered
    String _finalURL = _queryURL + 'q=' + _queryText;
    print("finalURL is: " + _finalURL);
    return _finalURL;
  }

  void _getQueryResults() async {
    // Get results from eBay API with query text
//    final response = await Dio().get(_buildQueryURL());
  }
}

class EbaySearch extends StatefulWidget {
  @override
  EbaySearchState createState() => EbaySearchState();
}