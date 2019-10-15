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
  List items = List();
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
    return ListView.separated(
      itemCount: items == null ? 0 : items.length,
      itemBuilder: (BuildContext context, int idx) {
        return ListTile(
          title: Text(items[idx]['title']),
          subtitle: Text('\$' + items[idx]['price']['value']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailedItem()),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
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
    final String _finalURL = _queryURL + 'q=' + _queryText + '&limit=100';
    print('finalURL is: ' + _finalURL);
    return _finalURL;
  }

  void _getQueryResults() async {
    final String authToken = 'Bearer v^1.1#i^1#p^1#f^0#I^3#r^0#t^H4sIAAAAAAAAAOVYa2wUVRTuttvKq/hDESQI7YAPKDt778w+B3bJ9kF3KaVLt61tkcDszJ3t0NmZde5dyxqF2pCCRIOKYkSMNSbERE3kB4YY/UF8EYIGiQI/IPFBkKCQQAwai4+Z2aVsK2mRbrCJ+2cz55577ne+75x77wzoLZu8qD/c/2u57Y7igV7QW2yzwalgcllp1fSS4tmlRSDPwTbQu6DX3ldybinmk0qKa0Y4pakYVWxMKirmLGOASusqp/FYxpzKJxHmiMDFQo0rOYYGXErXiCZoClURqQ1QiOG9rAu5vR5/nHUz0LCq12K2aAHK5eOZuMj6xDgLBL/bY4xjnEYRFRNeJQGKAdDvgMAB3S3AwzGQYxgaukAnVdGGdCxrquFCAypoweWsuXoe1tGh8hgjnRhBqGAktDzWFIrU1q1qWerMixXM8RAjPEnj4U81mogq2ngljUZfBlveXCwtCAhjyhnMrjA8KBe6BuYW4FtUs8Dv90sAsW6fX3AxTEGoXK7pSZ6MjsO0yKJDslw5pBKZZMZi1GAjvgEJJPe0yggRqa0w/1aneUWWZKQHqLrqUEcoGqWCK7QuVc1ENYdBuawmaroc0eZaBxtnoQSBS3Qgj4v1SaKQWygbLUfziJVqNFWUTdJwxSqNVCMDNRrJDczjxnBqUpv0kERMRPl+vmscsu5OU9SsimnSpZq6oqRBRIX1OLYCQ7MJ0eV4mqChCCMHLIoCFJ9KySI1ctCqxVz5bMQBqouQFOd09vT00D0srekJJwMAdLY3rowJXSjJU4av2etZf3nsCQ7ZSkVAxkwscySTMrBsNGrVAKAmqKALQC/ry/E+HFZwpPUfhrycncM7olAdgpAgAEFwAyhKcUmSCtEhwVyROk0cKM5nHEle70YkpfACcghGnaWTSJdFjnVLjFGkyCF6/JLD5ZckR9wtehxQQgggFI8Lft//qVFuttRjSNARKUitF6zOoxm5G9W1t/e4q8KeaF2o42FvtSipnbGqmobWZn9de6fHF69ejRu8icDNdsONkxe0FIpqiixkCsCA2esFZIHVxSivk0wMKYphGFei2Ex0YolszsdGAD4l02Zj04KWdGq8saObpnUW4nHlHEqlIslkmvBxBUUKs5v/Rzv5DdOTjbvOhMrJ0C8rpCxmLym0pSaNHxNoHWEtrRv3M7rJPLNbtG6kGjsg0TVFQXobHLfQt1tfs9fH4ONfHha3lnvhbioTqbYFRTZKaN1Ey+y2KCrzE+w0hm4vhAxw+Zhx5VVjadqSmWjnUFjDBImjpWavv8VrtXP4S36wyPrBPtt+0GfbV2yzASe4H84HlWUlrfaSabOxTBAt8xKN5YRqvLvqiO5GmRQv68VlNvmFY1u/yfusMLAWzBr6sDC5BE7N+8oA5lwfKYV3ziyHfgigG3gYyDCdYP71UTu8x3534s2qr7b/8WPjpfq9zeWXAh+07Tt7FZQPOdlspUX2PlvRzqPTFpxe8eGUU0+dvOvJiwtPbHuo6ruPScOa+vPqrleirS8lng/+VouKHnxbq1x3YWDLwdi3bw00KmdXvrF/e0fU/3r5lLWdl48d7/NSyrTKOacaznOfLTn6xPrBL+aeXf9o9Z6Xt7Ue7rrvyulNC36+KP/JHG677J7evfvcEpHOPLJmcE7VrMHKQ4kdx79/bm1o5+aDs8KfPrtLWD6vfdnjZ8LR9z+hIhceeHXhkb2LDvyyo37Pa6dp/O4z27Z/zk66Opied7Tu5AZ6Rsd7mxcy8MDuQfT7pBN7bB/V2ufva/8686K3tPrMpi//YgZObt4SePrKvYunHunf+9MP78xb1jy3f/GhXeEZM4+Ht87Fela+vwFxtakK8BEAAA==';
    dio.options.headers = {'Authorization' : authToken};
    // Get results from eBay API with query text
    try {
      final Response response = await dio.get<void>(_buildQueryURL());
      print(response);

      List resultsList = List();
      for(int i=0; i<response.data['itemSummaries'].length; i++) {
        resultsList.add(response.data['itemSummaries'][i]);
      }
      setState(() {
        items = resultsList;
      });
    }
    catch (e) {
      print(e);
    }
  }
}

class DetailedItemState extends State<DetailedItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Center(
        child: Text('Item Details Here'),
      ),
    );
  }
}

class EbaySearch extends StatefulWidget {
  @override
  EbaySearchState createState() => EbaySearchState();
}

class DetailedItem extends StatefulWidget {
  @override
  DetailedItemState createState() => DetailedItemState();
}