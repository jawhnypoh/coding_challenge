import 'package:flutter_test/flutter_test.dart';
import 'package:coding_challenge/main.dart';


void main() {
  test('Testing building of query URL', () {
    final ebaySearchState = EbaySearchState();
    String queryText = 'Test';

    var result = ebaySearchState.buildQueryURL(queryText);
    expect(result, 'https://api.ebay.com/buy/browse/v1/item_summary/search?q=Test');
  });
}