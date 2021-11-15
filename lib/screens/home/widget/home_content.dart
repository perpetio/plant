import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant/screens/home/bloc/home_bloc.dart';
import 'package:plant/screens/home/widget/home_recently_added.dart';
import 'package:plant/screens/home/widget/home_search_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    HapticFeedback.heavyImpact();
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void _onLoading() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    _refreshController.loadComplete();
  }

  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, currState) =>
          currState is SearchPlantsState || currState is SearchBackTappedState,
      builder: (context, state) {
        final HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
        if (state is SearchPlantsState) {
          if (state.plantsModels.isEmpty) {
            return Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text(
                  "No plants",
                  style: TextStyle(color: Colors.grey, fontSize: 23),
                ),
              ),
            );
          } else {
            return HomeSearchPlantsList(plants: state.plantsModels);
          }
        }
        return _createHomeData(context, bloc);
      },
    );
  }

  Widget _createHomeData(BuildContext context, HomeBloc bloc) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              bloc.add(RefreshEvent());
              return SingleChildScrollView(
                child: (bloc.listPlantsModels ?? []).isNotEmpty ?? false
                    ? HomeRecentlyAdded(
                        listPlantsModels: bloc.listPlantsModels,
                        size: size,
                      )
                    : _createNoPlants(size),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _createNoPlants(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.3),
      child: Center(
        child: Text(
          'No plants yet',
          style: TextStyle(color: Colors.grey, fontSize: 23),
        ),
      ),
    );
  }
}
