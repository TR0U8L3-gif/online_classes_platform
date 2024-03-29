import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:online_classes_platform/core/services/network/network_info.dart';
import 'package:online_classes_platform/src/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:online_classes_platform/src/auth/data/repositories/auth_repository_impl.dart';
import 'package:online_classes_platform/src/auth/domain/repositories/auth_repository.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/forgot_password.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/sign_in.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/sign_up.dart';
import 'package:online_classes_platform/src/auth/domain/use_cases/update_user.dart';
import 'package:online_classes_platform/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_classes_platform/src/on_boarding/data/data_sources/on_boarding_local_data_source.dart';
import 'package:online_classes_platform/src/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:online_classes_platform/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:online_classes_platform/src/on_boarding/domain/use_cases/cache_first_timer.dart';
import 'package:online_classes_platform/src/on_boarding/domain/use_cases/check_if_user_is_first_timer.dart';
import 'package:online_classes_platform/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.main.dart';
