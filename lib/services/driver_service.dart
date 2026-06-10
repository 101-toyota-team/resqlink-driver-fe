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
    
    if (session == null) {
      debugPrint('DEBUG: _getValidToken: NO SESSION FOUND');
      return null;
    }

    // Jika token kedaluwarsa atau hampir habis (misal dalam 60 detik), refresh session
    if (session.isExpired || (session.expiresAt != null && 
        DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
            .difference(DateTime.now()).inSeconds < 60)) {
      debugPrint('DEBUG: _getValidToken: SESSION EXPIRED or expiring soon. Refreshing...');
      try {
        final response = await auth.refreshSession();
        session = response.session;
        debugPrint('DEBUG: _getValidToken: REFRESH SUCCESS');
      } catch (e) {
        debugPrint('DEBUG: _getValidToken: REFRESH FAILED: $e');
        return null;
      }
    } else {
      debugPrint('DEBUG: _getValidToken: TOKEN STILL VALID');
    }
    
    return session?.accessToken;
  }

  static Map<String, String> _getHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<List<dynamic>> getDriverAssignments() async {
    final token = await _getValidToken;
    if (token == null) throw Exception('Not authenticated');

    final url = Uri.parse('$_baseUrl/driver/assignments');
    debugPrint('DEBUG: Calling GET $url');
    
    final response = await http.get(
      url,
      headers: _getHeaders(token),
    );

    debugPrint('DEBUG: GET $url returned ${response.statusCode}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      debugPrint('DEBUG: GET $url failed: ${response.body}');
      throw Exception('Failed to fetch assignments: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<String?> _getProviderToken() async {
    try {
      final url = Uri.parse('https://oddfremdisrivnepklga.supabase.co/auth/v1/token?grant_type=password');
      final response = await http.post(
        url,
        headers: {
          'apikey': _apiKey ?? '',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': 'provider1@test.com',
          'password': 'password123',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      } else {
        debugPrint('DEBUG: Failed to get provider token: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('DEBUG: Error getting provider token: $e');
      return null;
    }
  }

  static Future<void> updateBookingStatus(String bookingId, String status) async {
    // Gunakan token provider sesuai permintaan untuk bypass 403
    final token = await _getProviderToken();
    if (token == null) throw Exception('Failed to obtain provider token for status update');

    final url = Uri.parse('$_baseUrl/bookings/$bookingId/status');
    debugPrint('DEBUG: Calling PUT $url with provider token for status: $status');

    final response = await http.put(
      url,
      headers: _getHeaders(token),
      body: jsonEncode({'status': status}),
    );

    debugPrint('DEBUG: PUT $url returned ${response.statusCode}');
    if (response.statusCode != 200) {
      debugPrint('DEBUG: PUT $url failed: ${response.body}');
      throw Exception('Failed to update booking status: ${response.statusCode} - ${response.body}');
    }
  }
static Future<void> updateLocation({
  String? bookingId,
  required double lat,
  required double lng,
  double? heading,
  double? speed,
  double? accuracy,
}) async {
  // Kembali menggunakan token driver sendiri untuk lokasi sesuai permintaan
  final token = await _getValidToken;
  if (token == null) return;

  final url = Uri.parse('$_baseUrl/driver/location');

  final Map<String, dynamic> body = {
    'lat': lat,
    'lng': lng,
    'heading': heading ?? 0.0,
    'speed': speed ?? 0.0,
    'accuracy': accuracy ?? 0.0,
  };

  if (bookingId != null) {
    body['booking_id'] = bookingId;
  }

  try {
    final jsonBody = jsonEncode(body);
    debugPrint('DEBUG: Calling POST $url (Driver Token)');
    debugPrint('DEBUG: Payload: $jsonBody');

    final response = await http.post(
      url,
      headers: _getHeaders(token),
      body: jsonBody,
    );

    debugPrint('DEBUG: POST $url returned ${response.statusCode}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint('DEBUG: POST $url failed: ${response.statusCode} - ${response.body}');
    } else {
      debugPrint('DEBUG: Location update SUCCESS (Driver Token)');
    }
  } catch (e) {
    debugPrint('DEBUG: Error updating location: $e');
  }
}

  static Future<void> updateStatus(bool online) async {
    final token = await _getValidToken;
    if (token == null) return;

    final url = Uri.parse('$_baseUrl/driver/status');
    debugPrint('DEBUG: Calling PUT $url with online: $online');
    try {
      final response = await http.put(
        url,
        headers: _getHeaders(token),
        body: jsonEncode({'online': online}),
      );

      debugPrint('DEBUG: PUT $url returned ${response.statusCode}');
      if (response.statusCode != 200) {
        debugPrint('DEBUG: PUT $url failed: ${response.body}');
        throw Exception('Failed to update status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
