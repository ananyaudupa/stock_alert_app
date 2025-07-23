import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService {
  final String _apiKey = 'SD3YY856GFH82GWR'; // ✅ Your actual API key

  Future<double?> getCurrentPrice(String symbol) async {
    final url = Uri.parse(
      'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey',
    );

    print('🔍 Fetching stock price for: $symbol');
    print('🌐 API URL: $url');

    try {
      final response = await http.get(url);
      print('📦 Status Code: ${response.statusCode}');
      print('📦 Raw Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final quote = data['Global Quote'];
        final priceStr = quote?['05. price'];

        if (priceStr == null) {
          print('⚠️ Price not found in API response');
          return null;
        }

        final price = double.tryParse(priceStr);
        print('✅ Current Price for $symbol: $price');
        return price;
      } else {
        print('❌ Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('💥 Exception occurred: $e');
      return null;
    }
  }
}