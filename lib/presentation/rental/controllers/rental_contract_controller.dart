import 'package:get/get.dart';
import '../../../data/models/contract_model.dart';
import '../../../data/models/garage_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/contract_repository.dart';

/// Controller for rental contract page
class RentalContractController extends GetxController {
  final ContractRepository _contractRepo = ContractRepository();

  final Rx<ContractModel?> contract = Rx<ContractModel?>(null);
  final RxString contractNumber = ''.obs;

  // Contract data passed from apply page
  final Rxn<GarageModel> garage = Rxn<GarageModel>();
  final Rxn<UserModel> owner = Rxn<UserModel>();
  final Rxn<UserModel> renter = Rxn<UserModel>();
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final RxInt totalPrice = 0.obs;
  final RxString note = ''.obs;

  @override
  void onInit() {
    super.onInit();
    contractNumber.value = _contractRepo.generateContractNumber();
  }

  void setContractData({
    required GarageModel g,
    required UserModel o,
    required UserModel r,
    required DateTime start,
    required DateTime end,
    required int total,
    String? n,
  }) {
    garage.value = g;
    owner.value = o;
    renter.value = r;
    startDate.value = start;
    endDate.value = end;
    totalPrice.value = total;
    note.value = n ?? '';
  }

  /// Build contract data map to pass to signature controller
  Map<String, dynamic> buildContractDataMap() {
    return {
      'garageId': garage.value!.id!,
      'ownerId': owner.value!.id!,
      'garageName': garage.value!.name,
      'garageAddress': garage.value!.address,
      'ownerName': owner.value!.name,
      'ownerEmail': owner.value!.email,
      'ownerPhone': owner.value!.phone,
      'renterName': renter.value!.name,
      'renterEmail': renter.value!.email,
      'renterPhone': renter.value!.phone,
      'startDate': startDate.value!,
      'endDate': endDate.value!,
      'totalPrice': totalPrice.value,
      'note': note.value.isEmpty ? null : note.value,
    };
  }
}
