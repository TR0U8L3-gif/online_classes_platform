import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_classes_platform/core/common/views/page_under_construction.dart';
import 'package:online_classes_platform/core/services/dependency_injection/injection_container.dart';
import 'package:online_classes_platform/core/utils/adapters/local_user_adapter.dart';
import 'package:online_classes_platform/core/utils/extension/context_extensions.dart';
import 'package:online_classes_platform/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:online_classes_platform/src/auth/presentation/pages/sign_in_screen.dart';
import 'package:online_classes_platform/src/auth/presentation/pages/sign_up_screen.dart';
import 'package:online_classes_platform/src/dashboard/presentation/pages/dashboard.dart';
import 'package:online_classes_platform/src/on_boarding/data/data_sources/on_boarding_local_data_source.dart';
import 'package:online_classes_platform/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:online_classes_platform/src/on_boarding/presentation/pages/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router.main.dart';
