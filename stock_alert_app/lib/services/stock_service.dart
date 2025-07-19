import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService {
  final String _apiKey = 'YOUR_API_KEY_HERE'; // 🔁 Replace this
  final String _baseUrl = 'https://www.alphavantage.co/query';

  Future<double?> getCurrentPrice(String symbol) async {
    final url = Uri.parse(
      '$_baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final price = data['Global Quote']?['05. price'];
      return price != null ? double.tryParse(price) : null;
    }
    return null;
  }
}
