import 'package:dio/dio.dart';
import 'package:neofit_mobile/models/membership.dart';

class MembershipService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:5000/api'));

  Future<Membership?> fetchMembershipForUser() async {
    // Temporary test data (while backend is not available)
    return Membership.fromJson({
      'user_id': 123456,
      'membership_name': 'Premium Membership',
      'membership_description': 'Access to gym and unlimited group classes',
      'membership_price': 129,
      'membership_type': 'gym',
      'count_of_training': 10,
      'type': 'group',
      'start_date': '2025-05-01',
      'end_date': '2025-06-30',
    });

    // Real request (uncomment when backend is ready)
    /*
    try {
      final response = await _dio.get('/membership');

      final data = response.statusCode == 200 ? response.data : null;

      if (data is Map<String, dynamic>) {
        return Membership.fromJson(data);
      }
    } catch (e) {
      print('Error fetching membership: $e');
    }

    return null;
    */
  }
}
