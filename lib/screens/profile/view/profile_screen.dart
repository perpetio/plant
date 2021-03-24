import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/profile/bloc/profile_bloc.dart';
import 'package:plant/widgets/screen_template.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ProfileBloc();
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          // ignore: close_sinks
          final provider = context.watch<ProfileBloc>();

          return ScreenTemplate(
            index: 2,
            body: _Body(),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
