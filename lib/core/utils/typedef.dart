import 'package:dartz/dartz.dart';

import 'package:online_classes_platform/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;