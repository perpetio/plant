import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant/common_widget/plants_loading.dart';
import 'package:plant/screens/login/page/sign_in_screen.dart';
import 'package:plant/screens/profile/bloc/profile_bloc.dart';
import 'package:plant/utils/router.dart';
import 'package:plant/widgets/bottom_navigation_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    return BlocProvider<ProfileBloc>(
      create: (_) => ProfileBloc(),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        listenWhen: (_, currState) => true,
        buildWhen: (_, currState) =>
            currState is ProfileInitial || currState is ProfileLoadingState,
        builder: (context, state) {
          if (state is ProfileInitial) {
            bloc.add(ProfileInitialEvent());
          } else if (state is ProfileLoadingState) {
            return Stack(
              children: [_createProfileScreen(context, bloc), PlantsLoading()],
            );
          }
          return _createProfileScreen(context, bloc);
        },
      ),
    );
  }

  Widget _createProfileScreen(BuildContext context, ProfileBloc bloc) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        index: 2,
      ),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Profile",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routers.edit_profile,
                arguments: bloc.user,
              );
            },
          ),
        ],
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  _Body({Key key}) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          // ignore: close_sinks
          final bloc = BlocProvider.of<ProfileBloc>(context);
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            bloc.user == null || bloc.user.imageUrl == ''
                                ? AssetImage('assets/images/profile.png')
                                : NetworkImage(bloc.user.imageUrl),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      bloc.user?.name != null ? bloc.user.name : '',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      bloc.user?.email != null ? bloc.user.email : '',
                      style: TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                InkWell(
                  onTap: () {
                    bloc.add(SingOutTappedEvent());
                    Navigator.of(context).pushAndRemoveUntil(
                      PageTransition(
                          type: PageTransitionType.fade, child: SignInScreen()),
                      ModalRoute.withName(Routers.sign_in),
                    );
                  },
                  child: Container(
                    height: size.height * 0.06,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Color(0xFFF3F7FB),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20.0),
                        Icon(Icons.logout),
                        SizedBox(width: 10.0),
                        Text('Logout'),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded),
                        SizedBox(
                          width: 20.0,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
