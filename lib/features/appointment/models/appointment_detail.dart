import 'package:win_field_sale/features/appointment/models/address.dart';
import 'package:win_field_sale/features/appointment/models/client.dart';
import 'package:win_field_sale/features/appointment/models/product.dart';

class AppointmentDetail {
  final String appointmentStatusId;
  final String appointmentStatusName;
  final String appointmentId;
  final String purposeTypeId;
  final String purposeTypeName;
  final String? companyId;
  final String companyName;
  final List<Address> addresses;
  final List<Product> products;
  final Client client;

  AppointmentDetail({
    required this.appointmentStatusId,
    required this.appointmentStatusName,
    required this.appointmentId,
    required this.purposeTypeId,
    required this.purposeTypeName,
    required this.companyId,
    required this.companyName,

    required this.addresses,
    required this.products,
    required this.client,
  });

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) => AppointmentDetail(
    appointmentStatusId: json["AppointmentStatusID"],
    appointmentStatusName: json["AppointmentStatusName"] ?? '',
    appointmentId: json["AppointmentID"],
    purposeTypeId: json["PurposeTypeID"],
    purposeTypeName: json['PurposeTypeName'] ?? '',
    companyId: json["CompanyID"],
    companyName: json["CompanyName"] ?? '',
    addresses: (json["addresses"] as List).map((e) => Address.fromJson(e)).toList(),
    products: (json["products"] as List).map((e) => Product.fromJson(e)).toList(),
    client: Client.fromJson(json["Client"]),
  );

  Map<String, dynamic> toJson() => {
    "CompanyID": companyId,
    "AppointmentStatusID": appointmentStatusId,
    "AppointmentStatusName": appointmentStatusName,
    "AppointmentID": appointmentId,
    "PurposeTypeID": purposeTypeId,
    'PurposeTypeName': purposeTypeName,
    "addresses": addresses.map((e) => e.toJson()).toList(),
    "products": products.map((e) => e.toJson()).toList(),
    "Client": client.toJson(),
  };
}
