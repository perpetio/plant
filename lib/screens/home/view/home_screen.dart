import 'dart:async';

import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/models/plant_model.dart';
import 'package:plant/screens/common_widget/plants_loading.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/home/widget/home_content.dart';
import 'package:plant/widgets/avatar.dart';
import 'package:plant/widgets/screen_template.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return HomeBloc();
      },
      child: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
        buildWhen: (_, currState) =>
            currState is HomeInitial || currState is HomeLoadingState,
        builder: (context, state) {
          final bloc = BlocProvider.of<HomeBloc>(context);
          if (state is HomeInitial) {
            bloc.add(HomeInitialEvent());
          }
          return Stack(
            children: [
              ScreenTemplate(
                index: 0,
                title: 'Home',
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
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      searchContainerColor: Colors.white,
      trailingActionButtons: [
        Avatar(),
      ],
      title: Text(
        "Home",
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      onBackPressed: () {
        bloc.add(SearchBackTappedEvent());
      },
      onClearPressed: () {
        bloc.add(SearchClearTappedEvent());
      },
      onChanged: (query) {
        bloc.add(SearchPlantsEvent(query: query));
      },
    );
  }
}
