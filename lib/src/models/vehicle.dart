import 'media.dart';

class Vehicle {
    int id;
    String name;
    String role;
    String desc;
    num price;
    Media image;

    Vehicle({this.id, this.name, this.role, this.desc, this.price});

    Vehicle.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        name = json['name'];
        role = json['role'];
        desc = json['desc'];
        price = json['price'] ?? 00.00;
        image = json['media'] != null && (json['media'] as List).length > 0 ? Media.fromJSON(json['media'][0]) : new Media();

    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        data['role'] = this.role;
        data['desc'] = this.desc;
        data['price'] = this.price;
        return data;
    }
}