import 'dart:convert';
import 'package:http/http.dart' as http;

class THttpHelper {
  static const String _baseUrl =
      'https://your-api-base-url.com'; // Replace with your API base URL

  // Helper method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse(endpoint));
    return _handleResponse(response);
  }

  // Helper method to make a POST request
  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Helper method to make a PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  // Helper method to make a DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  // Handle the HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> getProvincesVN() async {
    final url = Uri.parse(
        'https://online-gateway.ghn.vn/shiip/public-api/master-data/province');
    final response = await http.get(
      url,
      headers: {
        'Token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch province');
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> responseData = responseBody['data'];
    return responseData;
  }

  static Future<List<dynamic>> getDistricts(String? provinceId) async {
    final url = Uri.https(
        'online-gateway.ghn.vn',
        'shiip/public-api/master-data/district',
        {'province_id': '$provinceId'});
    final response = await http.get(url, headers: {
      'Token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch district');
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> responseData = responseBody['data'];
    return responseData;
  }

  static Future<List<dynamic>> getCommunes(String? districtId) async {
    final url = Uri.https('online-gateway.ghn.vn',
        'shiip/public-api/master-data/ward', {'district_id': '$districtId'});
    final response = await http.get(url, headers: {
      'Token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch commune');
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> responseData = responseBody['data'];
    return responseData;
  }

  static Future<List<dynamic>> getShipServices(
      int fromDistrict, int toDistrict) async {
    final url = Uri.https('online-gateway.ghn.vn',
        'shiip/public-api/v2/shipping-order/available-services', {
      'shop_id': '',
      'from_district': fromDistrict,
      'to_district': toDistrict
    });
    final response = await http.get(url, headers: {
      'Token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to get ship services.');
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> responseData = responseBody['data'];
    return responseData;
  }

  static Future<List<dynamic>> getShipFee(
      int fromDistrict,
      String fromCommune,
      int serviceId,
      int serviceTypeId,
      int toDistrict,
      String toCommune,
      int weight,
      int? height,
      int? length,
      int? width) async {
    final url = Uri.https(
        'online-gateway.ghn.vn', 'shiip/public-api/v2/shipping-order/fee', {
      'from_district_id': fromDistrict,
      'from_ward_code': fromCommune,
      'service_id': serviceId,
      'service_type_id': serviceTypeId,
      'to_district_id': toDistrict,
      "to_ward_code": toCommune,
      "height": height,
      "length": length,
      "weight": weight,
      "width": width,
    });
    final response = await http.get(url, headers: {
      'Token': '7dbb1c13-7e11-11ee-96dc-de6f804954c9',
      'ShopId': ''
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to get ship fee.');
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> responseData = responseBody['data'];
    return responseData;
  }
}
