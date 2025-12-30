import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  final String apiKey =  dotenv.env['EXCHANGE_RATE_API_KEY'] ?? '';
  final String baseUrl = dotenv.env['EXCHANGE_RATE_API_URL'] ?? '';

  Future<Map<String,double>?> getRates(String baseCurrency) async
  {
    final url = Uri.parse('$baseUrl$apiKey/latest/$baseCurrency');

    try
    {
      final response = await http.get(url);

      if(response.statusCode == 200)
      {
        final data = jsonDecode(response.body);

        if(kDebugMode)print('Rates fetched successfully: $data');

         Map<String, dynamic> rates = data['conversion_rates'];

        return rates.map((key, value) => MapEntry(key, value.toDouble()));
      }

      else
      {
        if(kDebugMode)print('Failed to load rates: ${response.statusCode}');
        return null;
      }
    }

    catch(error)
    {
      if(kDebugMode)print('Error fetching rates: $error');
      return null;
    }
  }

}