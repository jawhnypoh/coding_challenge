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
  String _queryURL = 'https://api.ebay.com/buy/browse/v1/item_summary/search?';
  Widget _appTitle = Text('eBay Search App');
  Icon _queryIcon = Icon(Icons.search);

  EbaySearchState() {
//    _query.addListener(() {
//      if(_query.text.isEmpty) {
//        setState(() {
//          _queryText = '';
//        });
//      }
//      else {
//        setState(() {
//          _queryText = _query.text;
//        });
//      }
//    });
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
      leading: _queryIcon,
      title: TextField(
        controller: _query,
        decoration: InputDecoration(
          hintText: 'Search for anything...',
          hintStyle: TextStyle(color: Colors.white),
        ),
        onSubmitted: (_queryText) {
          if(_queryText.isNotEmpty) {
            _getQueryResults(_queryText);
          }
        },
        style: TextStyle(
            color: Colors.white),
      ),
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
              MaterialPageRoute(builder: (context) => DetailedItem(itemId: items[idx]['itemId'])),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  // Build the query URL based on what user entered
  String _buildQueryURL(String _queryText) {
    print('_buildQueryURL _queryText: ' + _queryText);
    final String _finalURL = _queryURL + 'q=' + _queryText + '&limit=100';
    print('finalURL is: ' + _finalURL);
    return _finalURL;
  }

  // Build the item detailed URL based on itemID
  String _buildItemURL() {

  }

  // Get results from eBay API with query text
  void _getQueryResults(String _queryText) async {
    final String authToken = 'Bearer v^1.1#i^1#p^1#r^0#I^3#f^0#t^H4sIAAAAAAAAAOVYW2gUVxjObjZpxUZFRaPYuh0rKYadPWfvM7oLm5vZmsvqbtIY1DiXM9lJdmeWOWebbLE0Ro19aCuEgrGiCCkUKX3QeoM+1Jda9cHaQimpUhSh9AYFK7XgpZ2ZXeMmlcSaxQa6L8v85z//+f7v+/9zzgwYKJ+zZqhx6HaF5RnrkQEwYLVY4Fwwp7ysel6pdXlZCShwsBwZeGnANlj64zrMpZJpdhPCaVXByN6fSiqYNY1BKqMprMphGbMKl0KYJQIbCzc3sS4asGlNJaqgJil7pC5IQQ8PIHBJrgDyMAIPdKvyIGZcDVJ+BAS3i+NFABjeI4j6OMYZFFEw4RQSpFwAMg4IHNAXB4B1u1jgpf1e0EnZ25GGZVXRXWhAhUy4rDlXK8A6NVQOY6QRPQgVioQbYq3hSF19S3ydsyBWKM9DjHAkgyc+1aoisrdzyQyaehlserOxjCAgjClnKLfCxKBs+AGYJ4BvUu3nGBfyBSTGL0JRZ7MoVDaoWoojU+MwLLLokExXFilEJtnpGNXZ4HuQQPJPLXqISJ3d+NuY4ZKyJCMtSNXXhDeHo1Eq9IqaUJRsVHXolMtKd23CEd1U53DzbihB4BEdyOdxByRRyC+Ui5anedJKtaoiygZp2N6ikhqko0aTuXEVcKM7tSqtWlgiBqJCP9cDDj2eTkPUnIoZklAMXVFKJ8JuPk6vwPhsQjSZzxA0HmHygElRkOLSaVmkJg+atZgvn34cpBKEpFmns6+vj+5z06rW7XQBAJ0dzU0xIYFSHKX7Gr2e85enn+CQzVQEpM/EMkuyaR1Lv16rOgClmwp5APS7A3neJ8IKTbb+w1CQs3NiRxSrQ5AfQCi4OTeC0Md5uWJ0SChfpE4DB+K5rCPFab2IpJOcgByCXmeZFNJkkXV7JZdepMgh+hjJ4WEkycF7RZ8DSggBhHheYAL/p0Z53FKPIUFDpCi1XrQ6j2blXlTf0dHnrW70RevDm1/114iS0hmrrt3Qtomp7+j0BfiajXiDvzv4uN3w6OQFNY2ialIWskVgwOj1IrLg1sQop5FsDCWTumFGiWIj0dklsjEf6wG4tEwbjU0LasqpcvqObpi6TMQzyjmcTkdSqQzh+CSKFGc3/4928kemJ+t3nVmVk65fTkhZzF1SaFNNGr8m0BrCakbT72d0q3Fmx9VepOg7INHUZBJp7XDGQj9tfY1en4aPf3lYPFnuxbupzKbaFpKyXkJdsy2zp6KozM2y0xh6/RAGvIzLO6O8ak1N49nZdg41qpggcarUbOuf8FrtnPiSHyoxf3DQchIMWo5ZLRbgBKvhKvBieWmbrfS55VgmiJY5icZyt6K/u2qI7kXZNCdr1nKLPPz13m8KPisc2Qoqxz8szCmFcwu+MoAVD0fK4PylFZCBAPoAcLuAtxOsejhqg0tsi+1XW4ai23Y2nTu6rKr9rfekZ4e2fAIqxp0slrIS26ClhDn2/o3T+9dc/L7xfC35NjTv/raFP30Zd94cHW37dXjl2NzPhUXUrfWe148uraraSiLHL5y52jx8/t69tjp1d6Xnsu3gz6NdXR6pYQEWGr57Y2wkfmN0F1O59u7uM22LLyZ2jlyvTPyAr97sWrll++IDJ5rZ+ddbP/tr7O5vlzoGD+0Ff1y60gNG7n28urny1v5Fb795pXrhuoNnVsBTfnSK6e554dqyrw5du3z2wx0Vgzd/X/4nv+NOQ5O2dgSfGL5DLzxbdemjji9OVy3ped5y4eWjp603Vp7c8wtYffv4ucORQ0nuHXzgWuTAu3JneMHhD85bPQfBvl0X1+4hvbc+bd9/+f7Y9n1Mf2NOvr8BHf0NLfARAAA=';
    dio.options.headers = {'Authorization' : authToken};
    try {
      final Response response = await dio.get<void>(_buildQueryURL(_queryText));
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

class DetailedItem extends StatelessWidget {
  // Declare itemId that holds itemId
  final String itemId;

  // Require an ItemId in the constructor
  DetailedItem({Key key, @required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Center(
        child: Text(itemId),
      ),
    );
  }
}

class EbaySearch extends StatefulWidget {
  @override
  EbaySearchState createState() => EbaySearchState();
}