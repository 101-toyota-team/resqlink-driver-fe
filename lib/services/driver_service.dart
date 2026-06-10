import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
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

  static String? get _apiKey => dotenv.env['SUPABASE_PUBLISHABLE_KEY'];

  static Future<String?> get _getValidToken async {
    final auth = Supabase.instance.client.auth;
    var session = auth.currentSession;
    
    if (session == null) return null;

    // Jika token kedaluwarsa atau hampir habis (misal dalam 60 detik), refresh session
    if (session.isExpired || (session.expiresAt != null && 
        DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
            .difference(DateTime.now()).inSeconds < 60)) {
      try {
        final response = await auth.refreshSession();
        session = response.session;
      } catch (e) {
        debugPrint('Error refreshing session: $e');
        return null;
      }
    }
    
    return session?.accessToken;
  }

  static Map<String, String> _getHeaders(String token) {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    if (_apiKey != null) {
      headers['apikey'] = _apiKey!;
    }
    return headers;
  }

  static Future<List<dynamic>> getDriverAssignments() async {
    final token = await _getValidToken;
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$_baseUrl/driver/assignments'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch assignments: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<void> updateBookingStatus(String bookingId, String status) async {
    final token = await _getValidToken;
    if (token == null) throw Exception('Not authenticated');

    final response = await http.put(
      Uri.parse('$_baseUrl/bookings/$bookingId/status'),
      headers: _getHeaders(token),
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update booking status: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<void> updateLocation({
    required String bookingId,
    required double lat,
    required double lng,
    double? heading,
    double? speed,
    double? accuracy,
  }) async {
    final token = await _getValidToken;
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
        headers: _getHeaders(token),
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        debugPrint('Failed to update location: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error updating location: $e');
    }
  }

  static Future<void> updateStatus(bool online) async {
    final token = await _getValidToken;
    if (token == null) return;

    final url = Uri.parse('$_baseUrl/driver/status');
    try {
      final response = await http.put(
        url,
        headers: _getHeaders(token),
        body: jsonEncode({'online': online}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
