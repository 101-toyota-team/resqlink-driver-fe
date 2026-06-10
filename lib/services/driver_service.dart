import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DriverService {
  static String get _baseUrl {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null) {
      throw Exception('API_BASE_URL not found in .env file');
    }
    return url;
  }

  static String? get _token => Supabase.instance.client.auth.currentSession?.accessToken;

  static Future<void> updateLocation({
    required String bookingId,
    required double lat,
    required double lng,
    double? heading,
    double? speed,
    double? accuracy,
  }) async {
    final token = _token;
    if (token == null) return;

    final url = Uri.parse('$_baseUrl/driver/location');
    final body = {
      'booking_id': bookingId,
      'lat': lat,
      'lng': lng,
      'heading': heading,
      'speed': speed,
      'accuracy': accuracy,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        print('Failed to update location: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  static Future<void> updateStatus(bool online) async {
    final token = _token;
    if (token == null) return;

    final url = Uri.parse('$_baseUrl/driver/status');
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'online': online}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update status: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
