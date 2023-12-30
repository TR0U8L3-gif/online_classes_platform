// id : "1"
// name : "Hazel Larson"
// avatar : "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/535.jpg"
// createdAt : "2023-12-28T20:34:55.263Z"

import 'package:equatable/equatable.dart';

class User extends Equatable{
  const User({
    required int id,
    required String name,
    required String avatar,
    required String createdAt,
  }):
    _id = id,
    _name = name,
    _avatar = avatar,
    _createdAt = createdAt;

  const User.empty() : this(
    id: 0,
    name: "",
    avatar: "",
    createdAt: "",
  );

  factory User.fromJson(Map<String, Object?> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  final int _id;
  final String _name;
  final String _avatar;
  final String _createdAt;

  User copyWith({
    int? id,
    String? name,
    String? avatar,
    String? createdAt,
  }) =>
      User(
        id: id ?? _id,
        name: name ?? _name,
        avatar: avatar ?? _avatar,
        createdAt: createdAt ?? _createdAt,
      );

  int get id => _id;
  String get name => _name;
  String get avatar => _avatar;
  String get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['avatar'] = _avatar;
    map['createdAt'] = _createdAt;
    return map;
  }

  @override
  String toString(){
    return 'User('
      'id: $_id, '
      'name: $_name, '
      'avatar: $_avatar, '
      'createdAt: $createdAt, '
    ')';
  }

  @override
  List<Object?> get props => [_id, _name, _avatar, _createdAt];
}
