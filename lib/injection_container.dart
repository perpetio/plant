import 'package:get_it/get_it.dart';
import 'package:plant/screens/change_password/bloc/change_password_bloc.dart';
import 'package:plant/screens/edit_profile/bloc/edit_profile_bloc.dart';
import 'package:plant/screens/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/login/bloc/login_bloc.dart';
import 'package:plant/screens/profile/bloc/profile_bloc.dart';
import 'package:plant/screens/scan/bloc/scan_bloc.dart';

final serviceLocator = GetIt.instance;

void init() {
  serviceLocator.registerSingleton<HomeBloc>(HomeBloc());
  serviceLocator.registerSingleton<LoginBloc>(LoginBloc());
  serviceLocator.registerSingleton<ScanBloc>(ScanBloc());
  serviceLocator.registerSingleton<ProfileBloc>(ProfileBloc());
  serviceLocator.registerSingleton<ForgotPasswordBloc>(ForgotPasswordBloc());
  serviceLocator.registerSingleton<EditProfileBloc>(EditProfileBloc());
  serviceLocator.registerSingleton<ChangePasswordBloc>(ChangePasswordBloc());
}
