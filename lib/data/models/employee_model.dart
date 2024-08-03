import 'address_model.dart';
import 'contact_methods_model.dart';

class EmployeeModel {
  EmployeeModel({
    this.id,
    required this.name,
    required this.address,
    required this.contactMethods,
    this.dateAdded,
  });

  String? id;
  String name;
  Address address;
  List<ContactMethod> contactMethods;
  DateTime? dateAdded;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    id: json["_id"],
    name: json["name"],
    address: Address.fromJson(json["address"]),
    contactMethods: List<ContactMethod>.from(json["contact_methods"].map((x) => ContactMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address.toJson(),
    "contact_methods": List<dynamic>.from(contactMethods.map((x) => x.toJson())),
  };
}
