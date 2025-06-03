import 'package:dio/dio.dart';
import 'package:neofit_mobile/services/dio_client.dart';
import 'package:neofit_mobile/models/membership/membership.dart';

class MembershipService {
  final Dio _dio = DioClient.instance;

  Future<Membership?> fetchMembershipForUser() async {
    try {
      final response = await _dio.get('/memberships');

      final data = response.statusCode == 200 ? response.data : null;

      if (data is Map<String, dynamic>) {
        return Membership.fromJson(data);
      }
    } catch (e) {
      print('Error fetching membership: $e');
    }

    return null;
  }
}
