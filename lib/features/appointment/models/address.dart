class Address {
  final double? latitude;
  final double? longitude;
  final String address;

  Address({this.latitude, this.longitude, required this.address});

  factory Address.fromJson(Map<String, dynamic> json) => Address(latitude: json["Latitude"], longitude: json["Longitude"], address: json["Address"]);

  Map<String, dynamic> toJson() => {"Latitude": latitude, "Longitude": longitude, "Address": address};
}
