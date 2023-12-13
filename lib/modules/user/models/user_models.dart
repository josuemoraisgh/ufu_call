import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
part 'user_models.g.dart';

@HiveType(typeId: 0, adapterName: 'UserAdapter')
class User extends HiveObject {
  @HiveField(0)
  int ident;
  @HiveField(1)
  String updatedApps;
  @HiveField(2)
  String photoName;
  @HiveField(3)
  String nomeM1;
  @HiveField(4)
  String condicao;
  @HiveField(5)
  String dataNascM1;
  @HiveField(6)
  String estadoCivil;
  @HiveField(7)
  dynamic fone;
  @HiveField(8)
  dynamic rg;
  @HiveField(9)
  dynamic cpf;
  @HiveField(10)
  String logradouro;
  @HiveField(11)
  String endereco;
  @HiveField(12)
  dynamic numero;
  @HiveField(13)
  String bairro;
  @HiveField(14)
  String complemento;
  @HiveField(15)
  dynamic cep;
  @HiveField(16)
  String obs;
  @HiveField(17)
  String chamada;
  @HiveField(18)
  List<String> parentescos;
  @HiveField(19)
  List<String> nomesMoradores;
  @HiveField(20)
  List<String> datasNasc;
  @HiveField(21)
  List<double> fotoPoints;

  User({
    this.ident = -1,
    this.updatedApps = "",
    required this.nomeM1,
    this.photoName = "",
    this.condicao = "ATIVO",
    this.dataNascM1 = "",
    this.estadoCivil = "Não declarado(a)",
    this.fone = "",
    this.rg = "",
    this.cpf = "",
    required this.logradouro,
    required this.endereco,
    required this.numero,
    this.bairro = "Morada Nova",
    this.complemento = "",
    this.cep = "",
    this.obs = "",
    this.chamada = "",
    this.parentescos = const [],
    this.nomesMoradores = const [],
    this.datasNasc = const [],
    this.fotoPoints = const [],
  });

  User.assistido(User assistido)
      : ident = assistido.ident,
        updatedApps = assistido.updatedApps,
        nomeM1 = assistido.nomeM1,
        photoName = assistido.photoName,
        condicao = assistido.condicao,
        dataNascM1 = assistido.dataNascM1,
        estadoCivil = assistido.estadoCivil,
        fone = assistido.fone,
        rg = assistido.rg,
        cpf = assistido.cpf,
        logradouro = assistido.logradouro,
        endereco = assistido.endereco,
        numero = assistido.numero,
        bairro = assistido.bairro,
        complemento = assistido.complemento,
        cep = assistido.cep,
        obs = assistido.obs,
        chamada = assistido.chamada,
        parentescos = assistido.parentescos,
        nomesMoradores = assistido.nomesMoradores,
        datasNasc = assistido.datasNasc,
        fotoPoints = assistido.fotoPoints;

  factory User.fromList(List<dynamic> value) {
    final int yearNow = DateTime.now().year;
    final String aux0 =
        value[5].toString().replaceAll(RegExp(r'[^0-9;\/]'), "");
    final String tst =
        value[20].toString().replaceAll(RegExp(r'[^0-9;\/]'), "");
    final List<String> aux1 = tst.isEmpty
        ? []
        : tst.substring(tst.length - 1) == ";" &&
                tst.substring(tst.length - 2) != ";"
            ? tst.substring(0, tst.length - 1).split(";")
            : tst.split(";");

    final List<String> datanasc = aux1.map((e) {
      return e.isEmpty
          ? DateFormat('dd/MM/yyyy').format(DateTime.now())
          : e.length <= 3
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime(yearNow - int.parse(e)))
              : e;
    }).toList();

    final String morad = value[19].toString();
    final List<String> moradores = morad.isEmpty
        ? []
        : morad.substring(morad.length - 1) == ";" &&
                morad.substring(morad.length - 2) != ";"
            ? morad.substring(0, morad.length - 1).split(";")
            : morad.split(";");

    final String parent = value[18].toString();
    final List<String> parentes = parent.isEmpty
        ? []
        : parent.substring(parent.length - 1) == ";" &&
                parent.substring(parent.length - 2) != ";"
            ? parent.substring(0, parent.length - 1).split(";")
            : parent.split(";");

    return User(
      ident: value[0] as int,
      updatedApps: value[1],
      photoName: value[2].toString(),
      nomeM1: value[3].toString(),
      condicao: value[4].toString(),
      dataNascM1: aux0.isEmpty
          ? DateFormat('dd/MM/yyyy').format(DateTime.now())
          : aux0.length <= 3
              ? DateFormat('dd/MM/yyyy')
                  .format(DateTime(yearNow - int.parse(aux0)))
              : aux0,
      estadoCivil: value[6].toString(),
      fone: value[7].toString(),
      rg: value[8].toString(),
      cpf: value[9].toString(),
      logradouro: value[10],
      endereco: value[11].toString(),
      numero: value[12].toString(),
      bairro: value[13].toString(),
      complemento: value[14],
      cep: value[15].toString(),
      obs: value[16].toString(),
      chamada: value[17].toString(),
      parentescos: parentes,
      nomesMoradores: moradores,
      datasNasc: datanasc,
      fotoPoints: const [],
    );
  }

  void changeItens(String? itens, dynamic datas) {
    if (itens != null && datas != null) {
      switch (itens) {
        case 'key':
          ident = datas;
          break;
        case 'Updated Apps':
          updatedApps = datas;
          break;
        case 'Morador01':
          nomeM1 = datas;
          break;
        case 'Foto':
          photoName = datas;
          break;
        case 'Condição':
          condicao = datas;
          break;
        case 'Data de Nasc':
          dataNascM1 = datas;
          break;
        case 'Estado Civil':
          estadoCivil = datas;
          break;
        case 'Telefone':
          fone = datas;
          break;
        case 'RG':
          rg = datas;
          break;
        case 'CPF':
          cpf = datas;
          break;
        case 'Logradouro':
          logradouro = datas;
          break;
        case 'Endereço':
          endereco = datas;
          break;
        case 'Nº':
          numero = datas;
          break;
        case 'Bairro':
          bairro = datas;
          break;
        case 'Complemento':
          complemento = datas;
          break;
        case 'CEP':
          cep = datas;
          break;
        case 'Obs.:':
          obs = datas;
          break;
        case 'Chamada':
          chamada = datas;
          break;
        case 'Parentescos':
          parentescos = datas;
          break;
        case 'Nomes do Moradores':
          nomesMoradores = datas;
          break;
        case 'Datas Nasc':
          datasNasc = datas;
          break;
      }
    }
  }

  List<dynamic> toList() {
    return [
      photoName,
      nomeM1,
      condicao,
      dataNascM1,
      estadoCivil,
      fone,
      rg,
      cpf,
      logradouro,
      endereco,
      numero,
      bairro,
      complemento,
      cep,
      obs,
      chamada,
      parentescos.join(";"),
      nomesMoradores.join(";"),
      datasNasc.join(";")
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.ident == ident &&
        other.updatedApps == updatedApps &&
        other.photoName == photoName &&
        other.nomeM1 == nomeM1 &&
        other.dataNascM1 == dataNascM1 &&
        other.estadoCivil == estadoCivil &&
        other.fone == fone &&
        other.rg == rg &&
        other.cpf == cpf &&
        other.logradouro == logradouro &&
        other.endereco == endereco &&
        other.numero == numero &&
        other.bairro == bairro &&
        other.complemento == complemento &&
        other.cep == cep &&
        other.obs == obs &&
        other.chamada == chamada &&
        other.parentescos == parentescos &&
        other.nomesMoradores == nomesMoradores &&
        other.datasNasc == datasNasc;
  }

  @override
  int get hashCode {
    return ident.hashCode ^
        updatedApps.hashCode ^
        photoName.hashCode ^
        nomeM1.hashCode ^
        dataNascM1.hashCode ^
        estadoCivil.hashCode ^
        fone.hashCode ^
        rg.hashCode ^
        cpf.hashCode ^
        logradouro.hashCode ^
        endereco.hashCode ^
        numero.hashCode ^
        bairro.hashCode ^
        complemento.hashCode ^
        cep.hashCode ^
        obs.hashCode ^
        chamada.hashCode ^
        parentescos.hashCode ^
        nomesMoradores.hashCode ^
        datasNasc.hashCode;
  }
}
