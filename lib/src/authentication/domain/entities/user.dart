// id : "1"
// name : "Hazel Larson"
// avatar : "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/535.jpg"
// createdAt : "2023-12-28T20:34:55.263Z"

import 'package:equatable/equatable.dart';

class User extends Equatable{
  const User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  const User.empty() : this(
    id: "",
    name: "",
    avatar: "",
    createdAt: "",
  );

  final String id;
  final String name;
  final String avatar;
  final String createdAt;

  @override
  List<Object?> get props => [id, name, avatar, createdAt];
}
