// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_card_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentCardHiveModelAdapter extends TypeAdapter<PaymentCardHiveModel> {
  @override
  final int typeId = 3;

  @override
  PaymentCardHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentCardHiveModel(
      id: fields[0] as String,
      cardholderName: fields[1] as String,
      last4: fields[2] as String,
      brandIndex: fields[3] as int,
      expiryMonth: fields[4] as int,
      expiryYear: fields[5] as int,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentCardHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cardholderName)
      ..writeByte(2)
      ..write(obj.last4)
      ..writeByte(3)
      ..write(obj.brandIndex)
      ..writeByte(4)
      ..write(obj.expiryMonth)
      ..writeByte(5)
      ..write(obj.expiryYear)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentCardHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
