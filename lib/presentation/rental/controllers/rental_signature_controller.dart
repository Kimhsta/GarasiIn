import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/session_manager.dart';
import '../../../data/models/contract_model.dart';
import '../../../data/models/rental_model.dart';
import '../../../data/repositories/contract_repository.dart';
import '../../../data/repositories/rental_repository.dart';

class RentalSignatureController extends GetxController {
  final RentalRepository _rentalRepo = RentalRepository();
  final ContractRepository _contractRepo = ContractRepository();
  final _session = SessionManager.instance;

  late final SignatureController signatureController;
  final RxBool hasSigned = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    signatureController = SignatureController(
      penStrokeWidth: 2.5,
      penColor: AppColors.primaryDark,
      exportBackgroundColor: Colors.white,
    );
    signatureController.addListener(() {
      if (signatureController.isNotEmpty && !hasSigned.value) {
        hasSigned.value = true;
      }
    });
  }

  @override
  void onClose() {
    signatureController.dispose();
    super.onClose();
  }

  void clearSignature() {
    signatureController.clear();
    hasSigned.value = false;
  }

  Future<String?> saveSignatureToFile() async {
    if (signatureController.isEmpty) return null;
    try {
      final Uint8List? data = await signatureController.toPngBytes();
      if (data == null) return null;
      final dir = await getApplicationDocumentsDirectory();
      final sigDir = Directory('${dir.path}/signatures');
      if (!await sigDir.exists()) await sigDir.create(recursive: true);
      final fileName = 'sig_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${sigDir.path}/$fileName');
      await file.writeAsBytes(data);
      return file.path;
    } catch (e) {
      debugPrint('Error saving signature: $e');
      return null;
    }
  }

  Future<void> submitRentalWithContract(Map<String, dynamic> cd) async {
    if (!hasSigned.value) {
      Get.snackbar('Perhatian', 'Silakan buat tanda tangan terlebih dahulu',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;
    try {
      final sigPath = await saveSignatureToFile();
      if (sigPath == null) {
        Get.snackbar('Error', 'Gagal menyimpan tanda tangan',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      final rental = RentalModel(
        garageId: cd['garageId'] as int,
        renterId: _session.currentUserId ?? 0,
        ownerId: cd['ownerId'] as int,
        startDate: cd['startDate'] as DateTime,
        endDate: cd['endDate'] as DateTime,
        totalPrice: cd['totalPrice'] as int,
        note: cd['note'] as String?,
      );
      final rentalId = await _rentalRepo.createRental(rental);
      final contract = ContractModel(
        rentalId: rentalId,
        contractNumber: cd['contractNumber'] as String? ?? _contractRepo.generateContractNumber(),
        ownerName: cd['ownerName'] as String,
        ownerEmail: cd['ownerEmail'] as String,
        ownerPhone: cd['ownerPhone'] as String,
        renterName: cd['renterName'] as String,
        renterEmail: cd['renterEmail'] as String,
        renterPhone: cd['renterPhone'] as String,
        garageName: cd['garageName'] as String,
        garageAddress: cd['garageAddress'] as String,
        startDate: cd['startDate'] as DateTime,
        endDate: cd['endDate'] as DateTime,
        totalPrice: cd['totalPrice'] as int,
        note: cd['note'] as String?,
        renterSignaturePath: sigPath,
        termsText: ContractModel.generateTermsText(),
      );
      await _contractRepo.createContract(contract);
      Get.offAllNamed(AppRoutes.renterHome);
      Get.snackbar('Berhasil',
        'Pengajuan sewa berhasil dikirim! Tunggu konfirmasi pemilik.',
        backgroundColor: AppColors.success.withValues(alpha: 0.1),
        colorText: AppColors.success,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim pengajuan: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
