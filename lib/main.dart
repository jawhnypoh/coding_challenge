import 'dart:io';

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
  var dio = Dio();
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
      _getQueryResults();
    });
  }

  // Build the query URL based on what user entered
  String _buildQueryURL() {
    final String _finalURL = _queryURL + 'q=' + _queryText;
    print('finalURL is: ' + _finalURL);
    return _finalURL;
  }

  void _getQueryResults() async {
    final String authToken = 'Bearer v^1.1#i^1#f^0#p^1#I^3#r^0#t^H4sIAAAAAAAAAOVYa2wUVRTudNuShlaDCK2NP9bhESKZ2Xt3uq+hu7p9QLdAu3TbpVQJzM7caYfuzkzmzrJdErGpPEwADYpKMTGAgRDjA1BDMKEEE6NGHvIsgsEHChJjiP6QBDVxZncp20papBts4v7ZzLnnnvud7zvn3jsDeoqKH19Xv+5GKTEhf3sP6MknCDgRFBcVzn7Akl9RmAeyHIjtPdN7CnotP1VhLhZV2WaEVUXGyNodi8qYTRm9ZFyTWYXDEmZlLoYwq/NsyL9wAWunAatqiq7wSpS0Bmq9JC8AOwJOJESQg4F2YFjlWzFbFC9pZ0QEnRBGPFBEqDJijGMcRwEZ65ysG+MAeigIKOhoAZUsA1jGRTMueztpDSMNS4psuNCA9KXgsqm5WhbWkaFyGCNNN4KQvoB/bqjJH6ita2ypsmXF8mV4COmcHsdDn2oUAVnDXDSORl4Gp7zZUJznEcakzZdeYWhQ1n8LzD3AT1EdcXERKAJgdwsOh9vO54TKuYoW4/SRcZgWSaDElCuLZF3Sk6MxarARWYF4PfPUaIQI1FrNv0VxLiqJEtK8ZF21f4k/GCR9DUqnLCeDCmVQLskdNZ1UsLmWYiIMFCGoFCjkrGTcosBnFkpHy9A8bKUaRRYkkzRsbVT0amSgRsO5sWdxYzg1yU2aX9RNRNl+zlscOmG7KWpaxbjeKZu6ophBhDX1OLoCg7N1XZMicR0NRhg+kKLIS3KqKgnk8MFULWbKpxt7yU5dV1mbLZFI0AmGVrQOmx0AaGtbuCDEd6IYRxq+Zq+n/aXRJ1BSKhUeGTOxxOpJ1cDSbdSqAUDuIH2VALoYd4b3obB8w63/MGTlbBvaEbnqEI4XXVAAgGEAcDoZJhcd4ssUqc3EgSJckopxWhfS1SjHI4o36iweQ5oksIxDtBtFiijB6RGpSo8oUhGH4KTMfQ8gFInwHvf/qVHuttRDiNeQnpNaz1mdB5NSF6pra0s4Ztc7g3X+JYtd1YIot4dm18xvbfbUtbU73ZHqRXi+q8N7t91w5+R5RUVBJSrxyRwwYPZ6DllgNCHIaXoyhKJRwzCmRLGZ6PgS2ZyPjQCcKtFmY9O8ErMpnLGjm6ZlKcRjytmvqoFYLK5zkSgK5GY3/4928jumJxl3nXGVk6FfWkhJSF9S6JSaNF7J0xrCSlwz7md0k3lmtyhdSDZ2QF1TolGkheGYhb7f+pq9Pgof//KwuLfcc3dTGU+1zUclo4SWjbfM7ouiEjfOTmPocEEIGTfjGlNeNSlNW5Lj7RyqV7COhJFSK5h3j9dq29CXfF9e6gd7iQ9BL7EvnyCADcyA08BjRZbWAktJBZZ0REucSGOpQzbeXTVEd6GkyklafhEhvXRq/dmszwrbl4LywQ8LxRY4MesrA3j09kghfLCsFHoggA5QyQDG1Q6m3R4tgFMLHraUJ1br55UJS/oO3xA3HaW04MAjoHTQiSAK8wp6ibwnHxq4tmsgfOlkyVJH/5TCI+8enTGZO/NEefP1089dPDC98ZDrfefMD+aV/nb1+znnlu/ZWv7qz8f7/kw8vybUN3VHycw927rD/vPE64vWVcwTjn3z8VsTLhf9MfnZMx/98HndVy9svOzexUkDi+3Lzzbu7/z66CbsqLJ9uXbDviMW1vfrU5/1/zjnwtMC2llyetszV1o/uR46F1bf6N9zcP/xjWuLV646eQHdLPv2wKSLVcENnl9efPm1y5vJlmOnyr64GtxCqBWz+r17e9+7dulwWYNr7+Kt4eW7PwUbJ/Wt/v3gwI41U9bfBCfAsfoTu//anLfm0JVprSumN7xyhthyhG14c+eVWd+tWi8yq99+Jy3f3yLk/jHwEQAA';
    dio.options.headers = {'Authorization' : authToken};
    // Get results from eBay API with query text
    try {
      final Response response = await dio.get<void>(_buildQueryURL()
      );
      print(response);
    }
    catch (e) {
      print(e);
    }
  }
}

class EbaySearch extends StatefulWidget {
  @override
  EbaySearchState createState() => EbaySearchState();
}

// Ebay Response List Object
class ResponseList {
  final int total;
  final List<Item> itemSummaries;

  ResponseList({this.total, this.itemSummaries});
}

// EBay Response Individual Item Object
class Item {
  final String itemId;
  final String title;
  final String condition;

  Item({this.itemId, this.title, this.condition});
}