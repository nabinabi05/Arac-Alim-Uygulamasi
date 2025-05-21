// lib/services/car_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/car.dart';
import 'car_repository.dart';

/// Olası durumlar.
enum CarStatus { initial, loading, loaded, error }

/// Araç listesi, durum ve hata mesajını tutan state.
class CarState {
  final CarStatus status;
  final List<Car>? cars;
  final String? error;

  CarState({this.status = CarStatus.initial, this.cars, this.error});
}

/// StateNotifier ile CRUD akışını yönetir.
class CarNotifier extends StateNotifier<CarState> {
  final CarRepository _repo = CarRepository();

  CarNotifier() : super(CarState());

  /// Listeyi API’den çeker.
  Future<void> fetchCars() async {
    state = CarState(status: CarStatus.loading);
    try {
      final cars = await _repo.fetchCars();
      state = CarState(status: CarStatus.loaded, cars: cars);
    } catch (e) {
      state = CarState(status: CarStatus.error, error: e.toString());
    }
  }

  /// Yeni araç ekle ve listeyi güncelle.
  Future<void> addCar(Car car) async {
    try {
      final ok = await _repo.addCar(car);
      if (ok) await fetchCars();
    } catch (e) {
      state = CarState(status: CarStatus.error, error: e.toString());
    }
  }

  /// Araç güncelle ve listeyi yenile.
  Future<void> updateCar(Car car) async {
    try {
      final ok = await _repo.updateCar(car);
      if (ok) await fetchCars();
    } catch (e) {
      state = CarState(status: CarStatus.error, error: e.toString());
    }
  }

  /// Araç sil ve listeyi yenile.
  Future<void> deleteCar(int id) async {
    try {
      final ok = await _repo.deleteCar(id);
      if (ok) await fetchCars();
    } catch (e) {
      state = CarState(status: CarStatus.error, error: e.toString());
    }
  }
}

/// Riverpod provider
final carProvider = StateNotifierProvider<CarNotifier, CarState>((ref) {
  return CarNotifier();
});
