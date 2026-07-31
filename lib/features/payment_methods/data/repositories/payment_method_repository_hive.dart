import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:basketapp/core/database/hive_boxes.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/payment_methods/data/models/payment_card_hive_model.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';
import 'package:basketapp/features/payment_methods/domain/repositories/payment_method_repository.dart';

class PaymentMethodRepositoryHive implements PaymentMethodRepository {
  late final Box<PaymentCardHiveModel> _box;

  PaymentMethodRepositoryHive() {
    _box = Hive.box<PaymentCardHiveModel>(HiveBoxes.paymentCards);
  }

  @override
  Future<Either<Failure, List<PaymentCard>>> getSavedCards() async {
    try {
      final cards = _box.values
          .map((model) => model.toEntity())
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(cards);
    } catch (e) {
      return Left(LocalStorageFailure('Error al obtener tarjetas guardadas: $e'));
    }
  }

  @override
  Future<Either<Failure, PaymentCard>> addCard(PaymentCard card) async {
    try {
      final cardToSave = card.id.isEmpty ? card.copyWith(id: _generateCardId()) : card;
      final hiveModel = PaymentCardHiveModel.fromEntity(cardToSave);
      await _box.put(cardToSave.id, hiveModel);
      return Right(cardToSave);
    } catch (e) {
      return Left(LocalStorageFailure('Error al guardar tarjeta: $e'));
    }
  }

  String _generateCardId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (DateTime.now().microsecond % 10000).toString().padLeft(4, '0');
    return 'CARD-$timestamp-$random';
  }
}
