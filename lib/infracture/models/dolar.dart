
import 'dart:convert';

List<Dolar> dolarFromJson(String str) =>
    List<Dolar>.from(json.decode(str).map((x) => Dolar.fromJson(x)));

String dolarToJson(List<Dolar> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Dolar {
  String valor;
  String vigenciadesde;
  String vigenciahasta;

  Dolar({
    required this.valor,
    required this.vigenciadesde,
    required this.vigenciahasta,
  });

  factory Dolar.fromJson(Map<String, dynamic> json) => Dolar(
        valor: json["valor"],
        vigenciadesde: json["vigenciadesde"],
        vigenciahasta: json["vigenciahasta"],
      );

  Map<String, dynamic> toJson() => {
        "valor": valor,
        "vigenciadesde": vigenciadesde,
        "vigenciahasta": vigenciahasta
      };
}
