// To parse this JSON data, do
//
//     final getCompany = getCompanyFromJson(jsonString);

import 'dart:convert';

List<GetCompany> getCompanyFromJson(String str) =>
    List<GetCompany>.from(json.decode(str).map((x) => GetCompany.fromJson(x)));

String getCompanyToJson(List<GetCompany> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCompany {
  int? total;
  String? type;
  String? tblName;

  GetCompany({
    this.total,
    this.type,
    this.tblName,
  });

  factory GetCompany.fromJson(Map<String, dynamic> json) => GetCompany(
        total: json["total"],
        type: json["type"],
        tblName: json["tblName"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "type": type,
        "tblName": tblName,
      };
}
