class ContactMethod {
  ContactMethod({
    required this.contactMethod,
    required this.value,
  });

  String contactMethod;
  String value;

  factory ContactMethod.fromJson(Map<String, dynamic> json) => ContactMethod(
    contactMethod: json["contact_method"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "contact_method": contactMethod,
    "value": value,
  };
}