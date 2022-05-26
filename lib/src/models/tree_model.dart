import 'package:markets/src/models/user.dart';

class TreeSecond {
  String name;
  List<User> children;

  TreeSecond({this.name, this.children});

  TreeSecond.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['children'] != null) {
      children = new List<User>();
      json['children'].forEach((v) { children.add(new User.fromJSON(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

class Tree {
  String name;
  List<TreeSecond> children;

  Tree({this.name, this.children});

  Tree.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['children'] != null) {
      children = new List<TreeSecond>();
      json['children'].forEach((v) { children.add(new TreeSecond.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}