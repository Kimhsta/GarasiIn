import '../datasources/local/garage_local_datasource.dart';
import '../models/garage_model.dart';

/// Repository for garage operations
class GarageRepository {
  final GarageLocalDatasource _datasource = GarageLocalDatasource();

  Future<List<GarageModel>> getAllGarages() async {
    return await _datasource.getAllGarages();
  }

  Future<List<GarageModel>> getAvailableGarages() async {
    return await _datasource.getAvailableGarages();
  }

  Future<List<GarageModel>> getGaragesByOwner(int ownerId) async {
    return await _datasource.getGaragesByOwner(ownerId);
  }

  Future<GarageModel?> getGarageById(int id) async {
    return await _datasource.getGarageById(id);
  }

  Future<int> createGarage(GarageModel garage) async {
    return await _datasource.insertGarage(garage);
  }

  Future<int> updateGarage(GarageModel garage) async {
    return await _datasource.updateGarage(garage);
  }

  Future<int> deleteGarage(int id) async {
    return await _datasource.deleteGarage(id);
  }

  Future<List<GarageModel>> searchGarages(String keyword) async {
    return await _datasource.searchGarages(keyword);
  }

  Future<List<GarageModel>> filterByPrice(
      {int? minPrice, int? maxPrice}) async {
    return await _datasource.filterByPrice(
        minPrice: minPrice, maxPrice: maxPrice);
  }

  Future<int> updateGarageStatus(int id, String status) async {
    return await _datasource.updateGarageStatus(id, status);
  }
}
