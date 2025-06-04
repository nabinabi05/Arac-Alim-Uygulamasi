// lib/providers/ai_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/ai_service.dart';

/// Riverpod Provider: Uygulamanın herhangi bir yerinde `ref.read(aiServiceProvider)`
/// diyerek tek bir AiService örneğine erişebilirsiniz.
final aiServiceProvider = Provider<AiService>((ref) {
  return AiService();
});
