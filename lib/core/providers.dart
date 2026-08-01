import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyclone/core/services/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
