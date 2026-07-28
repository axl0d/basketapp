// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderHiveModelAdapter extends TypeAdapter<OrderHiveModel> {
  @override
  final int typeId = 2;

  @override
  OrderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderHiveModel(
      id: fields[0] as String,
      items: (fields[1] as List).cast<CartItemHiveModel>(),
      totalPrice: fields[2] as double,
      status: fields[3] as OrderStatusHiveModel,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OrderHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.totalPrice)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
