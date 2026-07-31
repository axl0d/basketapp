// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderStatusHiveModelAdapter extends TypeAdapter<OrderStatusHiveModel> {
  @override
  final int typeId = 0;

  @override
  OrderStatusHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderStatusHiveModel(
      statusIndex: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OrderStatusHiveModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.statusIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
