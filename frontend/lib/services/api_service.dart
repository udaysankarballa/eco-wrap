import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recommendation_model.dart';

class ApiService {
  static const String baseUrl = 'https://eco-wrap-backend.onrender.com';

  Future<PackagingRecommendation> getRecommendation({
    required String commodity,
    required double moisture,
    required double ph,
    required double fat,
    required String respirationRate,
    required int shelfLife,
    required String storageType,
    required double temperature,
    required double humidity,
    required String transportMode,
    required int transportDuration,
    required bool useLabValues,
  }) async {
    final uri = Uri.parse('$baseUrl/api/recommend');

    final requestBody = {
      'commodity': commodity,
      'moisture': moisture,
      'ph': ph,
      'fat': fat,
      'respiration_rate': respirationRate,
      'shelf_life': shelfLife,
      'storage_type': storageType,
      'temperature': temperature,
      'humidity': humidity,
      'transport_mode': transportMode,
      'transport_duration': transportDuration,
      'use_lab_values': useLabValues,
    };

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);

        return PackagingRecommendation.fromJson(
          decoded as Map<String, dynamic>,
        );
      }

      String errorMessage = 'Server returned status ${response.statusCode}.';

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic> && decoded['detail'] != null) {
          errorMessage = decoded['detail'].toString();
        }
      } catch (_) {
        // Keep the default error message if the response is not JSON.
      }

      throw Exception(errorMessage);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception('Unable to connect to ECO WRAP backend.');
    }
  }
}
