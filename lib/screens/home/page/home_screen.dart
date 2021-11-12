import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/common_widget/plants_loading.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/home/widget/home_content.dart';
import 'package:plant/screens/plant/page/plant_screen.dart';
import 'package:plant/core/utils/debouncer.dart';
import 'package:plant/core/utils/router.dart';
import 'package:plant/common_widget/avatar.dart';
import 'package:plant/common_widget/screen_template.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(),
      child: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (_, currState) =>
            currState is OpenPlantDetailState || currState is AvatarTappedState,
        listener: (context, state) {
          if (state is OpenPlantDetailState) {
            // Navigator.pushNamed(context, Routers.plant, arguments: state.plant);
            Navigator.of(context).push(
              PageRouteBuilder(
                fullscreenDialog: true,
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secAnimation) {
                  return PlantScreen(plantsModels: state.plant);
                },
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        reverseCurve: Curves.easeOut,
                        curve: Interval(
                          0.50,
                          1.00,
                          curve: Curves.linear,
                        ),
                      ),
                    ),
                    child: child,
                  );
                },
              ),
            );
          } else if (state is AvatarTappedState) {
            Navigator.pushNamed(context, Routers.profile);
          }
        },
        buildWhen: (_, currState) =>
            currState is HomeInitial || currState is HomeLoadingState,
        builder: (context, state) {
          final HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
          if (state is HomeInitial) {
            bloc.add(HomeInitialEvent());
          }
          return Stack(
            children: [
              ScreenTemplate(
                index: 0,
                appBar: _createAppBar(bloc),
                isAppBar: true,
                body: HomeContent(),
              ),
              if (state is HomeLoadingState) PlantsLoading(),
            ],
          );
        },
      ),
    );
  }

  Widget _createAppBar(HomeBloc bloc) {
    return AppBarTextField(
      autofocus: false,
      focusNode: focusNode,
      controller: searchController,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      searchContainerColor: Colors.white,
      textInputAction: TextInputAction.search,
      trailingActionButtons: [
        InkWell(
          child: Container(
            padding: const EdgeInsets.only(right: 10),
            child: Avatar(),
          ),
          onTap: () {
            bloc.add(AvatarTappedEvent());
          },
        ),
      ],
      title: _createAppBarTitle(bloc),
      onTap: () {
        focusNode.requestFocus();
      },
      onBackPressed: () {
        bloc.add(SearchBackTappedEvent());
        focusNode.unfocus();
      },
      onClearPressed: () {
        bloc.add(SearchClearTappedEvent());
      },
      onChanged: (query) {
        _debouncer.run(() {
          bloc.add(SearchPlantsEvent(query: query));
        });
      },
    );
  }

  Widget _createAppBarTitle(HomeBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              // bloc.user.name != null || bloc.user.name == ''
              //     ? 'Hi ${bloc.user.name}'
              //     : 'Hi, name!',
              'hi',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 5),
            Image.asset('assets/images/plant.png'),
          ],
        ),
        SizedBox(height: 5),
        Text(
          'Let’s explore new plants!',
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
