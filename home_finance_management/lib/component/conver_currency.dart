import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = 'd3d37cccac2e9edeb3161e0f';
const String apiUrl = 'https://api.exchangerate-api.com/v4/latest/';

Future<double> convertCurrency(String from, String to, double amount) async {
  final response = await http.get(Uri.parse('$apiUrl$from'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final rate = data['rates'][to];
    return amount * rate;
  } else {
    throw Exception('Failed to load currency data');
  }
}
