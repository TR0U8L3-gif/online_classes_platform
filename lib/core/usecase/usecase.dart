import 'package:equatable/equatable.dart';
import 'package:online_classes_platform/core/utils/typedef.dart';

// ignore: one_member_abstracts
abstract class UseCase<Type,Params> {
  ResultFuture<Type> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => List.empty();
}
