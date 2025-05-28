// lib/services/cloud_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cloud_repository.dart';

enum CloudStatus { initial, loading, success, error }

class CloudState {
  final CloudStatus status;
  final int? predictedPrice;
  final String? error;

  CloudState({this.status = CloudStatus.initial, this.predictedPrice, this.error});
}

class CloudNotifier extends StateNotifier<CloudState> {
  final CloudRepository _repo = CloudRepository();

  CloudNotifier() : super(CloudState());

  /// carData ile API’ye istek atar, sonucu state’e yazar.
  Future<void> predict(Map<String, dynamic> carData) async {
    state = CloudState(status: CloudStatus.loading);
    try {
      final price = await _repo.predictPrice(carData);
      state = CloudState(status: CloudStatus.success, predictedPrice: price);
    } catch (e) {
      state = CloudState(status: CloudStatus.error, error: e.toString());
    }
  }
}

final cloudProvider = StateNotifierProvider<CloudNotifier, CloudState>((ref) {
  return CloudNotifier();
});
