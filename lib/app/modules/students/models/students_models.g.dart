// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentsAdapter extends TypeAdapter<Students> {
  @override
  final int typeId = 2;

  @override
  Students read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Students(
      ident: fields[0] as int,
      updatedApps: fields[1] as String,
      nomeM1: fields[3] as String,
      photoName: fields[2] as String,
      condicao: fields[4] as String,
      dataNascM1: fields[5] as String,
      estadoCivil: fields[6] as String,
      fone: fields[7] as dynamic,
      rg: fields[8] as dynamic,
      cpf: fields[9] as dynamic,
      logradouro: fields[10] as String,
      endereco: fields[11] as String,
      numero: fields[12] as dynamic,
      bairro: fields[13] as String,
      complemento: fields[14] as String,
      cep: fields[15] as dynamic,
      obs: fields[16] as String,
      chamada: fields[17] as String,
      parentescos: (fields[18] as List).cast<String>(),
      nomesMoradores: (fields[19] as List).cast<String>(),
      datasNasc: (fields[20] as List).cast<String>(),
      fotoPoints: (fields[21] as List).cast<double>(),
    );
  }

  @override
  void write(BinaryWriter writer, Students obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.ident)
      ..writeByte(1)
      ..write(obj.updatedApps)
      ..writeByte(2)
      ..write(obj.photoName)
      ..writeByte(3)
      ..write(obj.nomeM1)
      ..writeByte(4)
      ..write(obj.condicao)
      ..writeByte(5)
      ..write(obj.dataNascM1)
      ..writeByte(6)
      ..write(obj.estadoCivil)
      ..writeByte(7)
      ..write(obj.fone)
      ..writeByte(8)
      ..write(obj.rg)
      ..writeByte(9)
      ..write(obj.cpf)
      ..writeByte(10)
      ..write(obj.logradouro)
      ..writeByte(11)
      ..write(obj.endereco)
      ..writeByte(12)
      ..write(obj.numero)
      ..writeByte(13)
      ..write(obj.bairro)
      ..writeByte(14)
      ..write(obj.complemento)
      ..writeByte(15)
      ..write(obj.cep)
      ..writeByte(16)
      ..write(obj.obs)
      ..writeByte(17)
      ..write(obj.chamada)
      ..writeByte(18)
      ..write(obj.parentescos)
      ..writeByte(19)
      ..write(obj.nomesMoradores)
      ..writeByte(20)
      ..write(obj.datasNasc)
      ..writeByte(21)
      ..write(obj.fotoPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
