// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'product.dart';
//
// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************
//
// class ProductAdapter extends TypeAdapter<Product> {
//   @override
//   final int typeId = 1;
//
//   @override
//   Product read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Product(
//       id: fields[0] as int,
//       categoryId: fields[1] as int,
//       arabicName: fields[2] as String,
//       englishName: fields[3] as String,
//       imagePath: fields[4] as String,
//       description: fields[5] as String?,
//       price: fields[6] as int,
//     );
//   }
//
//   @override
//   void write(BinaryWriter writer, Product obj) {
//     writer
//       ..writeByte(7)
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.categoryId)
//       ..writeByte(2)
//       ..write(obj.arabicName)
//       ..writeByte(3)
//       ..write(obj.englishName)
//       ..writeByte(4)
//       ..write(obj.imagePath)
//       ..writeByte(5)
//       ..write(obj.description)
//       ..writeByte(6)
//       ..write(obj.price);
//   }
//
//   @override
//   int get hashCode => typeId.hashCode;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is ProductAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
