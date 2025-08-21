import 'dart:convert';
import 'package:http/http.dart' as http;

typedef Decoder<T> = T Function(Object json);

class ApiClient {
  ApiClient(this._baseUrl);

  final String _baseUrl;

  Future<T> get<T>({required String path, required Decoder<T> decode, Map<String, String>? query, Map<String, String>? headers}) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);

    final res = await http.get(uri, headers: {'Content-Type': 'application/json', if (headers != null) ...headers});

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    if (res.body.isEmpty) throw Exception('Empty response body');

    final raw = jsonDecode(res.body);

    return decode(raw);
  }

  Future<T> post<T>({required String path, required Map<String, dynamic> body, Decoder<T>? decode}) async {
    final uri = Uri.parse('$_baseUrl$path');

    final res = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    if (res.body.isEmpty) {
      throw Exception('Empty response body');
    }

    final raw = jsonDecode(res.body);

    try {
      return decode!(raw);
    } catch (e) {
      throw Exception('Decode error for $T: $e');
    }
  }
}
