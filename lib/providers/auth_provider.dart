import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neofit_mobile/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
