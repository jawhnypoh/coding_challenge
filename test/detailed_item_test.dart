import 'package:flutter_test/flutter_test.dart';
import 'package:coding_challenge/detailed_item.dart';

void main() {
  test('Testing building of query URL', () {
    const String itemId = '123456';
    final detailedItemState = DetailedItemState(itemId);

    var result = detailedItemState.buildItemURL(itemId);
    expect(result, 'https://api.ebay.com/buy/browse/v1/item/123456');
  });
}