import 'dart:convert';

LicensePlateModel licensePlateModelFromJson(String str) =>
    LicensePlateModel.fromJson(json.decode(str));

String licensePlateModelToJson(LicensePlateModel data) =>
    json.encode(data.toJson());

class LicensePlateModel {
  LicensePlateModel({
    required this.box,
    required this.rChar,
    required this.rDigit,
    required this.rProvince,
    required this.recognition,
  });

  List<double> box;
  String rChar;
  String rDigit;
  String rProvince;
  String recognition;

  factory LicensePlateModel.fromJson(Map<String, dynamic> json) =>
      LicensePlateModel(
        box: List<double>.from(json["box"].map((x) => x.toDouble())),
        rChar: json["r_char"],
        rDigit: json["r_digit"],
        rProvince: json["r_province"],
        recognition: json["recognition"],
      );

  Map<String, dynamic> toJson() => {
        "box": List<dynamic>.from(box.map((x) => x)),
        "r_char": rChar,
        "r_digit": rDigit,
        "r_province": rProvince,
        "recognition": recognition,
      };
}
