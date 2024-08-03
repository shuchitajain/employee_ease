class Address {
  Address({
    required this.line1,
    required this.city,
    required this.country,
    required this.zipCode,
  });

  String line1;
  String city;
  String country;
  String zipCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    line1: json["line1"],
    city: json["city"],
    country: json["country"],
    zipCode: json["zip_code"],
  );

  Map<String, dynamic> toJson() => {
    "line1": line1,
    "city": city,
    "country": country,
    "zip_code": zipCode,
  };
}